ActiveAdmin.register AdminUser do
  config.per_page = 50

  permit_params :email, :password, :password_confirmation

  before_action :only => [:show, :edit, :update, :destroy] do
    @user = AdminUser.find_by(id: params[:id])
  end

  controller do
    def update
      p 'update 1'
      p user_params
      p 'update 2'
      if user_params[:password].blank?
        @user.update_without_password(user_params)
      else
        @user.update_attributes(user_params)
      end
      if @user.errors.blank?
        redirect_to admin_admin_users_path, :notice => "Admin User updated successfully."
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation)
    end
  end

  index do
    selectable_column
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions defaults: false do |user|
      item "View", admin_admin_user_path(user), class: 'member_link'
      item "Edit", edit_admin_admin_user_path(user)
    end
  end

  form do |f|
    f.semantic_errors
    inputs :email, :password, :password_confirmation
    f.actions
  end
end
