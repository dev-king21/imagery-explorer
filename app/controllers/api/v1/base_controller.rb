# frozen_string_literal: true
module Api::V1
  class BaseController < ActionController::API

    respond_to :json

    include Error::ErrorHandler

    before_action :authorize_request, except: [:user_not_authorized]

    attr_reader :api_user

    def user_not_authorized
      render json: { status: :unauthorized, message: 'Unauthorized'}, status: :unauthorized
    end

    # for update methods
    def render_with_details(relation, item_field)
      if relation.all? { |item| item.persisted? }
        render json: relation, status: :created
      else
        errors = relation.map do |item|
          item.errors.full_messages.empty? ? {file_name:  item.send(item_field), status: :created} : {file_name: item.send(item_field), errors: item.errors.full_messages}
        end
        render json: errors, status: :unprocessable_entity
      end
    end

    private

      def authorize_request
        result = AuthorizeApiRequest.call(request.headers).result
        User.current = result[:user]
        @api_user = result[:user]        

        render json: { status: 401, message: result[:messages]}, status: 401 unless @api_user
      end

  end
end
