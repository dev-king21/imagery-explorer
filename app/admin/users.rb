ActiveAdmin.register User do
  config.per_page = 50

  permit_params :name, :email, :password, :password_confirmation

  before_action :only => [:show, :edit, :update, :destroy] do
    @user = User.find_by_slug(params[:id])
  end

  controller do
    def update
      if user_params[:password].blank?
        @user.update_without_password(user_params)
      else
        @user.update_attributes(user_params)
      end
      if @user.errors.blank?
        redirect_to admin_users_path, :notice => "User updated successfully."
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end


  index do
    selectable_column
    column :email
    column :name
    column :created_at
    column :last_sign_in_at
    column :tours_count
    column :tourbooks_count

    actions defaults: false do |user|
      item "View", admin_user_path(user), class: 'member_link'
      item "Edit", edit_admin_user_path(user)
    end
  end

  show do
    attributes_table do
      row :email
      row :name
      row :created_at
      row :last_sign_in_at
      row :tours_count
      row :tourbooks_count
    end
  end

  form do |f|
    f.semantic_errors
    inputs :email, :name, :password, :password_confirmation
    f.actions
  end
end
