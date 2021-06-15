# frozen_string_literal: true
class PhotosController < ApplicationController
  include MetaTagsHelper

  before_action :authenticate_user!, only: %i[set_photo_view_point]
  before_action :set_photo, only: %i[show
                                      set_photo_view_point]

  def index
    find_photos
    @photos = @photos.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:photos])
    photo_og_meta_tag(@photos.first) unless @photos.empty?
  end

  def viewpoints
    find_viewpoints
    @photos = @photos.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:photos])
    photo_og_meta_tag(@photos.first) unless @photos.empty?
  end

  def show
    photo_og_meta_tag(@photo)
    @tour = @photo.tour
    @connected_photos = []

    connections = JSON.parse(@photo.tourer['connections']) if @photo.tourer['connections']

    connections&.keys&.each do |key|
      photo = @tour.photos.find_by(tourer_photo_id: connections[key]["photo_id"])
      if photo
        @connected_photos << photo
      end
    end

    gon.pannellum_config = pannellum_config
    gon.photos = @tour.photos
    gon.tour_name = @tour.name
    gon.author_name = @tour.user.name
    gon.root_url = root_url
  end

  def find_photos
    set_sort_params

    @photos = Photo.all

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
      @photos = @photos.order(filename: :asc) if @sort[:photos] == 'filename'
    end

    @photos = @photos.order('substring(favoritable_score from 15)::integer DESC')
  end

  def find_viewpoints
    set_sort_params

    @photos = Photo.where('substring(favoritable_score from 15)::integer > 0')

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
      @photos = @photos.order(filename: :desc) if @sort[:photos] == 'filename'
    end

    @photos = @photos.order('substring(favoritable_score from 15)::integer DESC')
  end

  private

  def set_photo
    @photo = Photo.includes(tour: :user).find(params[:id])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:photos])
  end

  def pannellum_config
    # photos = []
    # node_stack = [@photo]

    # max_limit = 10000
    # loop_count = 0

    # loop do
    #   break if loop_count > max_limit
    #   break if node_stack.empty?

    #   curr_node = node_stack.pop
    #   photos << curr_node unless photos.include?(curr_node)

    #   next unless curr_node
    #   next unless curr_node.tourer["connections"].present?

    #   connections = JSON.parse(curr_node.tourer["connections"])

    #   connections&.keys&.each do |key|
    #     photo = @photo.tour.photos.find_by(tourer_photo_id: connections[key]["photo_id"])

    #     if photo && !photos.include?(photo)
    #       node_stack << photo
    #     end
    #   end

    #   loop_count += 1
    # end

    options = {
      "autoLoad": true,
        "default": {
            "firstScene": @photo.tourer_photo_id,
            "title": @tour.name,
            "author": @tour.user.name,
            "authorURL": photo_path(@photo),
            "sceneFadeDuration": 1000
        },
        "scenes": {}
    }

    @tour.photos.each do |photo|
      next unless photo.tourer["connections"]
      connections = JSON.parse(photo.tourer["connections"])

      hot_spots = []

      connections&.keys&.each do |key|
        hot_photo = @tour.photos.select{ |connected_photo| connected_photo.tourer_photo_id == connections[key]["photo_id"] }.first

        if hot_photo
          hot_spots << {
              "type": "scene",
              "pitch": connections[key]["pitch_degrees"].to_f,
              "yaw": connections[key]["adjusted_heading_degrees"].to_f,
              "text": hot_photo.tourer_photo_id,
              "sceneId": hot_photo.tourer_photo_id
          }
        end
      end

      options[:scenes][photo.tourer["photo_id"]] = {
        "title": @tour.name,
        "author": @tour.user.name,
        "authorURL": photo_path(photo),
        "type": "equirectangular",
        "panorama": photo.image.url(:med),
        "hotSpots": hot_spots
      }
    end

    options
  end
end
