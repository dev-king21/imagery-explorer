class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    @user = User.find(current_user.id)
    if @user.destroy_with_password(params[:user][:current_password])
      redirect_to root_url, notice: 'Your account was deleted. Hope you will comeback soon!'
    else
      render :edit, layout: 'application'
    end
  end

end