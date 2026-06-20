module ApplicationHelper
  # Stars are stored "ascending" (5 = best) but rendered "descending"
  # (filled icons first). Returns nil when the underlying value (GI/carbs)
  # was never set, so callers can skip rendering the rating block entirely.
  def reversed_stars(stars)
    return nil if stars.nil?

    [5 - stars, 1].max
  end

  def markdown(text)
    return "" if text.blank?

    Kramdown::Document.new(
      text,
      input: "GFM",
      syntax_highlighter: "rouge",
      hard_wrap: true
    ).to_html.html_safe
  end

  # Active Storage's redirect/proxy controllers add a server round-trip before the browser
  # even learns the real (cross-origin) Cloudinary URL, which is costly for an LCP image under
  # network throttling. When the active service is Cloudinary, link to it directly with
  # on-the-fly transformations (f_auto/q_auto let Cloudinary's edge pick the best format/quality
  # per browser) instead of going through ActiveStorage's variant pipeline.
  def optimized_image_url(attachment, width:, height:, crop: "fill")
    return nil unless attachment.attached?

    if attachment.blob.service.is_a?(ActiveStorage::Service::CloudinaryService)
      Cloudinary::Utils.cloudinary_url(
        "#{Rails.env}/#{attachment.blob.key}",
        width: width, height: height, crop: crop,
        fetch_format: "auto", quality: "auto"
      )
    else
      url_for(attachment.variant(resize_to_limit: [width, height], format: :webp, quality: 80))
    end
  end
end
