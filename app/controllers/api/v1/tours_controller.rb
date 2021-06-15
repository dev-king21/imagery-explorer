# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController

    before_action :set_tour, only: %i[show update destroy]
    before_action :set_user, only: %i[get_tours]

    # GET /api/v1/tours
    def index
      find_tours
      @tours = @tours.page(params[:page] ? params[:page].to_i : 1)
      tours_json = ActiveModelSerializers::SerializableResource.new(@tours).as_json
      tours_json['_metadata'] = pagination_meta(@tours)
      render json: tours_json, status: :ok
    end

    # GET /api/v1/tours/:id
    def show
      render json: @tour, status: :ok
    end

    # POST /api/v1/tours
    def create
      @tour = api_user.tours.build(tour_params)

      if @tour.save
        render json: @tour, status: :created
      else
        render json: {
            status: :unprocessable_entity,
            message: @tour.errors
        }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:id
    def update
      if tour_params[:name].present?
        render json: {
            status: :unprocessable_entity,
            message: 'you cannot update the name of a tour'
        }, status: :unprocessable_entity
        return
      end

      if api_user.tours.include?(@tour)
        begin
          if @tour.update(tour_params)
            render json: @tour.reload, status: :ok
          else
            render json: {
                status: :unprocessable_entity,
                message: @tour.errors
            }, status: :unprocessable_entity
          end
        rescue ArgumentError => e
          @tour.errors.add(:tour_type, e)
          render json: {
              status: :unprocessable_entity,
              message: @tour.errors
          }, status: :unprocessable_entity
        end
      else
        render json: {
            status: :unauthorized,
            message: 'You cannot update this tour'
        }, status: :unauthorized
      end
    end

    # DELETE /api/v1/tours/:id
    def destroy
      if api_user.tours.include?(@tour)
        @tour.destroy
        if @tour.errors.any?
          render json: {
              status: :unprocessable_entity,
              message: @tour.errors
          }, status: :unprocessable_entity
        else
          render json: {
                        "tour": {
                                  "id": @tour.id,
                                  "deleted_at": DateTime.now.rfc3339
                                }
                        }, status: :ok
        end
      else
        render json: {
            status: :unauthorized,
            message: 'You cannot delete this tour'
        }, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/tours
    def get_tours
      if api_user == @user
        render json: api_user.tours, status: :ok
      else
        render json: {
            status: :forbidden,
            message: 'You can get only your own tours'
        }, status: :forbidden
      end
    end

    private

    def set_tour
      @tour = Tour.find_by(id: params[:id])
    end

    def tour_params
      parameters = params.permit(*permitted_params)
      parameters[:tag_names] = parameters[:tags] if parameters[:tags]
      parameters[:tourer_tour_id] = parameters[:tourer][:tour_id] if parameters[:tourer]
      parameters[:tourer_version] = parameters[:tourer][:version] if parameters[:tourer]
      parameters.except(:tags, :tourer)
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
    end

    def permitted_params
      [
          :name,
          :description,
          :tourer_tour_id,
          :tourer_version,
          :tour_type,
          :transport_type,
          :tags,
          tourer: [:tour_id, :version]
      ]
    end

    def list_tours
      @tours.map do |tour|
        {
            id: tour[:id],
            name: tour[:name],
            description: tour[:description],
            tour_type: tour[:tour_type],
            transport_type: tour[:transport_type],
            tourer_version: tour[:tourer_version],
            tourer_tour_id: tour[:tourer_tour_id],
            created_at: tour[:created_at],
            user_id: tour[:user_id]
        }
      end
    end

    def pagination_meta(object)
      {
        current_page: object.current_page,
        per_page: Constants::ITEMS_PER_PAGE[:tours],
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end

    def find_tours
      set_tours_search_params

      @tours = Tour.includes(:countries, :tags, :user)

      if @query.present?
        @tours = @tours.left_joins(:countries).where(countries: { code: @query[:countries] }).distinct if @query[:countries].present?
        @tours = @tours.left_joins(:tags).where(tags: { name: @query[:tags] }) if @query[:tags].present?
        @tours = @tours.where(id: @query[:ids]) if @query[:ids].present?
        @tours = @tours.where(user_id: @query[:user_ids]) if @query[:user_ids].present?

        if @query[:tour_types].present?
          tour_types = []
          @query[:tour_types].each do |t|
            tour_types << Constants::TOUR_TYPES[t.to_sym] if Constants::TOUR_TYPES.has_key?(t.to_sym)
          end
          @tours = @tours.where(tour_type: tour_types)
        end

        if @query[:transport_types].present?
          transport_types = []
          @query[:transport_types].each do |t|
            transport_types << Constants::TRANSPORT_TYPES[t.to_sym] if Constants::TRANSPORT_TYPES.has_key?(t.to_sym)
          end
          @tours = @tours.where(transport_type: transport_types)
        end

        if @query[:sort_by].present?
          if @query[:sort_by] == 'name'
            @tours = @tours.reorder("tours.#{@query[:sort_by]} ASC")
          else
            @tours = @tours.reorder("tours.#{@query[:sort_by]} DESC")
          end
        end
      end

      @tours = @tours.order(updated_at: :desc)
    end

    def set_tours_search_params
      @query = tour_search_params
    end

    def tour_search_params
      params.permit(:sort_by, ids: [], tags: [], countries: [], user_ids: [], tour_types: [], transport_types: [])
    end

  end

end
