class Finder
  def initialize(params, user = nil)
    @params = params
    @user = user
  end

  def search
    set_search_params
    set_sort_params

    search_tours_and_tourbooks

    @tours = @tours.page(@params[:tour_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tours])
    @tourbooks = @tourbooks.page(@params[:tourbook_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tourbooks])
    {
        tours: @tours,
        tourbooks: @tourbooks,
        sort: @sort,
        query: @query,
        search_text: @search_text,
        tab: @tab
    }

  end

  private

  def search_tours_and_tourbooks
    # look for tours
    find_all_tours
    find_alll_tourbooks

    if @query.present?
      if @query['country_id'].present?
        tour_ids = Photo.where(country_id: @query['country_id']).pluck(:tour_id).uniq
        @tours = @tours.where(id: tour_ids)
      end
      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
      @tours = @tours.where(transport_type: @query['transport_type']) if @query['transport_type'].present?
    end

    tourbook_ids = []

    if @search_text.present?
      @tours = @tours.search(@search_text)
      tourbook_ids = @tourbooks.search(@search_text).pluck(:id).uniq
    end

    sort_tours

    # look for tourbooks including tours
    tour_ids = @tours.present? ? @tours.map(&:id) : []
    if tour_ids.present?
      tourbook_ids += TourTourbook.where(tour_id: tour_ids).pluck(:tourbook_id).uniq
    end

    @tourbooks = Tourbook.where(id: tourbook_ids.uniq)

    sort_tourbooks
  end

  def search_tourbooks
    # look for tourbooks
    find_alll_tourbooks
    @tourbooks = @tourbooks.search(@search_text) if @search_text.present?
    sort_tourbooks

    # look for tours belongs to tourbooks
    find_all_tours
    tourbook_ids = @tourbooks.present? ? @tourbooks.map(&:id) : []
    if tourbook_ids.present?
      tour_ids = TourTourbook.where(tourbook_id: tourbook_ids).pluck(:tour_id).uniq
      @tours = Tour.where(id: tour_ids)
    end
    sort_tours
  end

  def find_all_tours
    if @user.present?
      @tours = @user.tours
    else
      @tours = Tour.all
    end
  end

  def find_alll_tourbooks
    if @user.present?
      @tourbooks = @user.tourbooks
    else
      @tourbooks = Tourbook.all
    end
  end

  def sort_tours
    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order("tours.tourbooks_count DESC") if @sort[:tours] == 'tourbooks_count'
      @tours = @tours.order("tours.photos_count DESC") if @sort[:tours] == 'photos_count'
    end
    @tours = @tours.order(created_at: :desc)
  end

  def sort_tourbooks
    if @sort.present?
      @tourbooks = @tourbooks.order('tourbooks.name ASC') if @sort[:tourbooks] == 'name'
      @tourbooks = @tourbooks.order('tourbooks.tours_count DESC') if @sort[:tourbooks] == 'tours_count'
    end
    @tourbooks = @tourbooks.order('tourbooks.created_at DESC')
  end

  def set_search_params
    @search_text = search_params[:search_text]
    @tab = search_params[:tab] || 'tours'
    @query = search_params[:query]
  end

  def search_params
    @params.permit(:search_text, :tab, query: [:country_id, :tour_type, :transport_type])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    @params.permit(sort: [:tours, :tourbooks])
  end
end
