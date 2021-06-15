require 'rails_helper'

describe Api::V1::PhotosController, :type => :controller do

  let!(:user) { create :user }
  let!(:tour) { create :tour, user: user }
  let!(:photos) { create_list(:photo, 2, tour: tour) }
  let(:tour_id) { tour.id }
  let(:photo_id) { photos.first.id }
  let!(:vp_tours) { create_list(:tour, 1, :with_photos, user: user) }

  let(:valid_attributes) {{
      taken_at: 1.day.ago,
      latitude: -20.516189,
      longitude: 44.533069,
      elevation_meters: 745,
      camera_make: "GoPro",
      camera_model: "Fusion",
      google: {
          plus_code_global_code: "849VCWC8+R9",
          plus_code_compound_code: "CWC8+R9, Mountain View, CA, USA"
      },
      address: {
          country: "France",
          country_code: "FR"
      },
      streetview: {
          photo_id: "738475838",
          capture_time: "2019-10-01T12:00:01.000Z",
          share_link: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          download_url: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          thumbnail_url: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          lat: "-20.516189",
          lon: "44.533069",
          altitude: "745",
          heading: "90",
          pitch: "90",
          roll: "90",
          level: "1",
          connections: [
              738475838,
              738475839
          ]
      },
      tourer: {
          photo_id: "tkKjChLHbE",
          connections: [
              {
                  photo_id: "fkujChLJJJ",
                  distance_meters: "4",
                  heading_degrees: "90",
                  elevation_meters: "4"
              },
              {

                  photo_id: "fkujChLJJK",
                  distance_meters: "4",
                  heading_degrees: "90",
                  elevation_meters: "4"
              }
          ]
      },
      opentrailview: {
          photo_id: "tkKjChLHbE"
      },
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/images/sample.jpeg'), 'image/jpeg')
  }}

#  describe 'GET /api/v1/tours/:tour_id/photos' do
#    context 'When photos exists' do
#      before do
#        header 'api-key', user.api_token
#        get "/api/v1/tours/#{tour_id}/photos?ids[]=#{photos.first.id}&countries[]=#{photos.first.country.code}&streetview_connections=#{photos.first.streetview['connections']}&tourer_connection_photos[]=#{photos.first.tourer_connection_photos[0]}&sot_by=created_at"
#      end

      # todo(fixme)
      #it 'should return photos', focus: true do
      #  expect(json).not_to be_empty
      #  expect(json['_metadata']).not_to be_empty
      #  expect(json['photos']).not_to be_empty
      #  json['photos'].each do |photo|
      #    expect(photo.keys).to contain_exactly('id',
      #                                          'tour_id',
      #                                          'created_at',
      #                                          'updated_at',
      #                                          'taken_at',
      #                                          'user_id',
      #                                          'image',
      #                                          'latitude',
      #                                          'longitude',
      #                                          'elevation_meters',
      #                                          'address',
      #                                          'google',
      #                                          'streetview',
      #                                          'filename',
      #                                          'tourer',
      #                                          'opentrailview')
      #  end
      #end
#
#      it 'should return status code 200' do
#        expect(response).to have_http_status(:ok)
#      end
#    end
#  end

#  describe 'GET /api/v1/tours/:tour_id/photos/:id' do
#    context 'When photos exists' do
#      before do
#        header 'api-key', user.api_token
#        get "/api/v1/tours/#{tour_id}/photos/#{photo_id}"
#      end

      #it 'should return photos' do
      #  expect(json).not_to be_empty
      #  expect(json['photo']).not_to be_empty
      #end

#      it 'should return status code 200' do
#        expect(response).to have_http_status(:ok)
#      end
#    end
#  end

  describe 'POST /api/v1/tours/:tour_id/photos' do
    context 'When the request is valid' do
      before do
        header 'api-key', user.api_token
        post "/api/v1/tours/#{tour_id}/photos", valid_attributes
      end

      # todo(fixme)
      #it 'should create a photo' do
      #  expect(json).not_to be_empty
      #  expect(json['photo']).not_to be_empty
      #end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'When the request is invalid(image is empty)' do
      let (:invalid_attrs) { valid_attributes.except(:image) }

      before do
        header 'api-key', user.api_token
        post "/api/v1/tours/#{tour_id}/photos", invalid_attrs
      end

      # todo(fixme)
      #it 'should return status code unprocessable_entity' do
      #  expect(json).not_to be_empty
      #  expect(json['message']).not_to be_empty
      #  expect(json['status']).to eq('unprocessable_entity')
      #end
    end

    context 'When the request is invalid (tourer_photo_id is duplicated)' do
      let (:invalid_attrs) do
        valid_attributes[:tourer][:photo_id] = photos.first.tourer_photo_id
        valid_attributes
      end

      before do
        header 'api-key', user.api_token
        post "/api/v1/tours/#{tour_id}/photos", invalid_attrs
      end

      # todo(fixme)
      #it 'should return status code unprocessable_entity' do
      #  expect(json).not_to be_empty
      #  expect(json['message']).not_to be_empty
      #  expect(json['status']).to eq('unprocessable_entity')
      #end
    end

    context 'When the request is invalid (country is empty)' do
      let (:invalid_attrs) do
        valid_attributes[:address][:country_code] = ''
        valid_attributes
      end

      before do
        header 'api-key', user.api_token
        post "/api/v1/tours/#{tour_id}/photos", invalid_attrs
      end

      # todo(fixme)
      #it 'should return status code unprocessable_entity' do
      #  expect(json).not_to be_empty
      #  expect(json['message']).not_to be_empty
      #  expect(json['status']).to eq('unprocessable_entity')
      #end
    end
  end

  describe 'PUT /api/v1/tours/:tour_id/photos/:id' do
    let (:new_attrs) do
      valid_attributes[:camera_make] = 'x'
      valid_attributes
    end

    before do
      header 'api-key', user.api_token
      put "/api/v1/tours/#{tour_id}/photos/#{photo_id}", new_attrs
    end

    # todo(fixme)
    #it 'should update the photo' do
    #  expect(json).not_to be_empty
    #  expect(json['photo']).not_to be_empty
    #  expect(json['photo']['camera_make']).to eq('x')
    #end

    it 'should return status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

#  describe 'PATCH /api/v1/tours/:tour_id/photos/:id' do
#    let(:v_attrs) {{
#        camera_make: '500'
#    }}
#    before do
#      header 'api-key', user.api_token
#      put "/api/v1/tours/#{tour_id}/photos/#{photo_id}", v_attrs
#    end
#
#    it 'should update the photo' do
#      expect(json).not_to be_empty
#      expect(json['photo']).not_to be_empty
#      expect(json['photo']['camera_make']).to eq('500')
#    end
#
#    it 'should return status code 200' do
#      expect(response).to have_http_status(:ok)
#    end
#  end

  describe 'DELETE /api/v1/tours/:tour_id/photos/:id' do
    before do
      header 'api-key', user.api_token
      delete "/api/v1/tours/#{tour_id}/photos/#{photo_id}"
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(200)
    end
  end

# todo(fixme)
#  describe 'POST /api/v1/viewpoints' do
#   let(:valid_attributes) do {
#        photo_id: vp_tours.first.photos.first.id
#    }
#    end
#
#    context 'Mark viewpoint' do
#      before do
#        header 'api-key', user.api_token
#        post '/api/v1/viewpoints', viewpoint: valid_attributes
#      end
#
#     it 'should return updated viewpoint with 1' do
#        expect(json).not_to be_empty
#        expect(json['viewpoint']).not_to be_empty
#        expect(json['viewpoint']['count']).to equal(1)
#      end
#    end
#
#    context 'Unmark viewpoint' do
#      before do
#        photo = vp_tours.first.photos.first
#        user.favorite(photo)
#        header 'api-key', user.api_token
#        post '/api/v1/viewpoints', viewpoint: valid_attributes
#      end
#
#      it 'should return updated viewpoint with 0' do
#        expect(json).not_to be_empty
#        expect(json['viewpoint']).not_to be_empty
#        expect(json['viewpoint']['count']).to equal(0)
#      end
#    end
#  end
#
#  describe 'GET /api/v1/viewpoints?photo_ids[]=&user_ids[]=' do
#    before do
#      photo = vp_tours.first.photos.first
#      user.favorite(photo)
#      header 'api-key', user.api_token
#      get "/api/v1/viewpoints?photo_ids[]=#{photo.id}&user_ids[]=#{user.id}"
#    end
#
#    it 'should return viewpoints' do
#      expect(json).not_to be_empty
#      expect(json['_metadata']).not_to be_empty
#      expect(json['viewpoints']).not_to be_empty
#      json['viewpoints'].each do |viewpoint|
#        expect(viewpoint.keys).to contain_exactly('count', 'user_ids', 'photo_id')
#      end
#    end
#  end


end
