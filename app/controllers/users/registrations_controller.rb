class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_update_path_for(resource)
    profile_path
  end

  def build_resource(hash = {})
    super
    resource.skip_confirmation!
  end

  def update_resource(resource, params)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    sensitive_change = params[:password].present? ||
      (params.key?(:email) && params[:email].to_s != resource.email.to_s)

    result = if sensitive_change
      if resource.valid_password?(current_password)
        resource.update(params)
      else
        resource.assign_attributes(params)
        resource.valid?
        resource.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    else
      resource.update(params)
    end

    resource.clean_up_passwords
    result
  end
end
