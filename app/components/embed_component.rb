class EmbedComponent < ActionView::Component::Base
  def initialize(code:)
    @code = code
  end

  private
  attr_reader :code
end
