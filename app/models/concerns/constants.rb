# frozen_string_literal: true
module Constants

  ITEMS_PER_PAGE = {
      tours: 50,
      tourbooks: 15,
      photos: 50
  }

  WEB_ITEMS_PER_PAGE = {
      tours: 15,
      tourbooks: 15,
      photos: 15
  }

  TOUR_TYPES = {
      land: 0,
      water: 1,
      air: 2
  }

  DEPENDENCY_OF_TYPES = {
      land: %w(
          drive
          hike
          bike
          climb
          ski
          snowboard
          skateboard
          rollerblade
          otherland
      ),
      water: %w(
          sail
          kayak
          raft
          standuppaddleboard
          otherwater
      ),
      air: %w(
          drone
          hangglide
          parachute
          windsuit
          plane
          otherair
      )
  }.with_indifferent_access

  TRANSPORT_TYPES = {
      drive: 1,
      hike: 2,
      bike: 3,
      climb: 4,
      ski: 5,
      snowboard: 6,
      skateboard: 7,
      rollerblade: 8,
      otherland: 9,
      sail: 10,
      kayak: 11,
      raft: 12,
      standuppaddleboard: 13,
      otherwater: 14,
      drone: 15,
      hangglide: 16,
      parachute: 17,
      windsuit: 18,
      plane: 19,
      otherair: 20,
  }

  SUBSCRIPTION_TYPES = {
      global: 0
  }

  TAGS_AMOUNT = {
      tour: 10
  }

  TAGS_LENGTH = {
      tour: 240
  }

end
