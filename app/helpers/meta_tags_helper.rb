# frozen_string_literal: true
module MetaTagsHelper

  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : Rails.application.class.parent_name
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : app_description
  end

  def meta_image
    content_for?(:meta_image) ? content_for(:meta_image) : app_image
  end

  def meta_url
    content_for?(:meta_url) ? content_for(:meta_url) : app_url
  end

  def photo_og_meta_tag(photo)
      if Rails.env.staging?
        set_meta_tags og: {image: photo.image.url(:med) } if photo.present?
      end
  end

  def tour_og_meta_tag(tour)
      if Rails.env.staging?
        if tour.present? && tour.photos.present?
            photo = tour.photos.first
            set_meta_tags og: {image: photo.image.url(:med) } if photo.present?
        end
      end
  end

end