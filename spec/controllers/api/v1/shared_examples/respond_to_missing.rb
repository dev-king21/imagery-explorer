RSpec.shared_examples 'respond to missing' do |url|

  let(:user) { create :user }

  before do
    header "api-key", user.api_token
    get url
  end

  # it 'should respond with error' do
  #   expect(response.status).to eq 500
  # end

  it 'responds with error' do
    status = json["status"]
    expect(status).to eq(500)
  end
end