# frozen_string_literal: true
module ToursHelper

  def countries_for_select
    Country.all.map {|country| [country.name, country.id]}
  end

  def tour_types_for_select
    Tour.tour_types.map {|k , v| [k, v] }
  end

  def transport_types_for_select
    Tour.transport_types.map {|k , v| [k, v] }
  end

  def tour_countries(countries)
    countries.uniq { |c| c.id }
  end

end
