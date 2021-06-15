class ViewpointComponent < ActionView::Component::Base
  # validates :content, presence: true

  def initialize(viewpoint:, photo_id:)
    @viewpoint = viewpoint
    @photo_id = photo_id
  end

  private
  attr_reader :viewpoint
  attr_reader :photo_id
end
