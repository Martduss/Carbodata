class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :prevent_demo_account_changes

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
  protected

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile_name, :photo, :accept_terms])
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_name, :photo])
  end

  # The demo account is locked: visitors can explore recipes/items/posts freely,
  # but can't edit its profile, delete it, or log out of it. The only way out
  # is the "Back to homepage" link. This runs for every controller (including
  # Devise's own, since Devise.parent_controller defaults to ApplicationController),
  # so it can't be bypassed by hitting a Devise URL directly.
  def prevent_demo_account_changes
    return unless current_user&.demo?

    blocked = (is_a?(Devise::SessionsController) && action_name == "destroy") ||
      (is_a?(Devise::RegistrationsController) && %w[edit update destroy].include?(action_name))

    return unless blocked

    redirect_to home_path, alert: "The demo account is locked. Head back to the homepage to end your tour."
  end
end
