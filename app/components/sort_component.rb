class SortComponent < ActionView::Component::Base
  # validates :content, presence: true

  def initialize(collection_name:, value:)
    @collection_name = collection_name
    @value = value
  end

  private

  attr_reader :collection_name
  attr_reader :value
end
