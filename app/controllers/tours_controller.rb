# frozen_string_literal: true
class ToursController < ApplicationController
  include MetaTagsHelper

  before_action :set_tour, only: %i[show]

  def show
    set_sort_params
    @photos = @tour.photos
    @tourbooks = @tour.tourbooks

    if @sort.present?
      if @sort[:photos] == 'taken_at'
        @photos = @photos.order(taken_at: :desc)
      elsif @sort[:photos] == 'filename'
        @photos = @photos.order(filename: :asc)
      end

      @tourbooks = @tourbooks.order(name: :desc) if @sort[:tourbooks] == 'name'
      @tourbooks = @tourbooks.order('tourbooks.tours_count DESC') if @sort[:tourbooks] == 'tours_count'
    end
    @photos = @photos.order('substring(favoritable_score from 15)::integer ASC')
    @tourbooks = @tourbooks.order(created_at: :desc)

    @photos = @photos.page(params[:photo_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tours])
    @tourbooks = @tourbooks.page(params[:tourbook_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tourbooks])

    tour_og_meta_tag(@tour)
  end

  private

    def set_tour
      @tour = Tour.includes(:countries).friendly.find(params[:id])
    end

    def set_tours_search_params
      @search_text = tour_search_params[:search_text]
      @query = tour_search_params[:query]
    end

    def tour_search_params
      params.permit(:search_text, query: [:country_id, :tour_type])
    end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:photos, :tourbooks])
  end
end
