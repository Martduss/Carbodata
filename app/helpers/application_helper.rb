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
end
