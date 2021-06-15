# frozen_string_literal: true
module ApplicationHelper

  def current_class?(test_path)
    request.path == test_path ? 'active' : ''
  end

  def app_description
    "Unleash your inner explorer and travel the globe without leaving home."
  end

  def app_image
    image_url('google-street-view-tours.jpg')
  end

  def app_url
    root_url
  end

  def set_user
    @user = if current_user
              current_user
            elsif params[:user]
              User.friendly.find(params[:id])
            elsif params[:user_id]
              User.friendly.find(params[:user_id])
            end
  end

  def form_errors_for(object=nil)
    render('shared/form_errors', object: object) unless object.blank?
  end

  def handle_custom_flash(flash)
    msg = flash[:danger] || flash[:alert] || flash[:error]

    if msg.include?('You have to confirm your email address')
      confirm_url = new_confirmation_path(:user)
      raw "#{msg} <a href='#{confirm_url}'>Click here to resend the confirmation email</a>."
    else
      raw msg
    end
  end
end
