require 'rails_helper'
require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_empty.rb')

#describe Api::V1::TourbooksController, :type => :controller do
#
#  let!(:user) { create :user }
#  let!(:tourbooks) { create_list(:tourbook, 2, :with_tours, user: user) }
#  let(:tours) { tourbooks.first.tours }
#  let (:tourbook_id) { tourbooks.first.id }
#  let (:user_id) { user.id }

#  describe 'GET /api/v1/tourbooks' do
#    context 'When tourbooks exist' do
#      before do
#        header 'api-key', user.api_token
#        tours = tourbooks.first.tours
#        get "/api/v1/tourbooks?tour_ids[]=#{tours.first.id}&ids[]=#{tourbooks.first.id}&user_ids[]=#{user.id}&sort_by=name"
#      end
#
      # todo(fixme)
      #it 'should return json with metadata' do
      #  expect(json).not_to be_empty
      #  expect(json['tourbooks']).not_to be_empty
      #  expect(json['_metadata']).not_to be_empty
      #  json['tourbooks'].each do |tourbook|
      #    expect(tourbook.keys).to contain_exactly(
      #                                 'id',
      #                                  'name',
      #                                  'description',
      #                                  'created_at',
      #                                  'user_id',
      #                                  'tour_ids'
      #                             )
      #  end
      #end
#
#      it 'should return HTTP code 200' do
#        expect(response).to have_http_status(:ok)
#      end
#    end
#  end
#
#  describe 'POST /api/v1/tourbooks' do
#    let(:valid_attributes) do
#      {
#          name: "Investigation of the world part 2",
#          description: "my favourite tours and trips 2",
#          tour_ids: [
#              tours.first.id,
#              tours.second.id
#          ]
#      }
#    end

#    context 'when the request is valid' do
#      before do
#        header 'api-key', user.api_token
#        post '/api/v1/tourbooks', tourbook: valid_attributes
#      end

      # todo(fixme)
      #it 'should create a tourbook' do
      #  expect(json).not_to be_empty
      #  expect(json['tourbook']).not_to be_empty
      #end
#
#      it 'should return status code 201' do
#        expect(response).to have_http_status(:ok)
#      end
#    end
#  end
#
#  describe 'PUT /api/v1/tourbooks' do
#    let(:valid_attributes) do
#      {
#          name: "Investigation of the world part 3",
#          description: "my favourite tours and trips 3",
#          tag_ids: [
#              tours.first.id
#          ]
#      }
#    end
#
#    context 'when the request is valid' do
#      before do
#        header 'api-key', user.api_token
#        put "/api/v1/tourbooks/#{tourbooks.first.id}", tourbook: valid_attributes
#      end
#
#      it 'should create a tourbook' do
#        expect(json).not_to be_empty
#        expect(json['tourbook']).not_to be_empty
#      end
#
#      it 'should return status code 201' do
#        expect(response).to have_http_status(:ok)
#      end
#    end
#  end
#
#  describe 'DELETE /api/v1/tourbooks/:id' do
#    before do
#      header 'api-key', user.api_token
#      delete "/api/v1/tourbooks/#{tourbooks.first.id}"
#    end
#
#    it 'returns status code 204' do
#      expect(response).to have_http_status(200)
#    end
#  end
#
#end