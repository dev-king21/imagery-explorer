class HomeController < ApplicationController
  include MetaTagsHelper
  def index
    result = Finder.new(params).search

    @tours = result[:tours]
    @tourbooks = result[:tourbooks]
    @sort = result[:sort]
    @query = result[:query]
    @search_text = result[:search_text]
    @tab = result[:tab]

    tour_og_meta_tag(@tours.first) unless @tours.empty?
  end

  def about
    render 'about/index'
  end

  def upload
    render 'upload/index'
  end
end
