# frozen_string_literal: true
class ApplicationController < ActionController::Base

  include Pundit
  include ApplicationHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { user_not_authorized }
      format.js   { flash.now[:error] = 'Not authorized. Please Log in to proceed.' }
    end
  end

  def sitemap
    if Rails.env.production? || Rails.env.staging?
      aws_s3_url = "http://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}/sitemaps/sitemap.xml.gz"
      redirect_to(aws_s3_url, status: 301)  
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :terms, :global_subscribe, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:global_subscribe, :email, :password, :password_confirmation, :current_password) }
    end

  private

    def user_not_authorized
      render file: 'public/401.html', status: :unauthorized
    end

end
