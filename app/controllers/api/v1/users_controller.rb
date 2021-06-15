module Api::V1
  class UsersController < BaseController
    
    def show
      @user = User.find(params[:id])
      render json: @user, status: :ok
    end
    
    def get_info
      resp = {
        user: {
          id: @api_user.id,
          username: @api_user.name,
          email: @api_user.email
        }
      }
      render json: resp, status: :ok
    end
  end
end