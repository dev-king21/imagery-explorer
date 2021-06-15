RSpec.shared_examples 'respond to empty' do |url|

  let(:user) { create :user }

  before do
    header "api-key", user.api_token
  end

  it 'should respond with empty data' do
    get url
    expect(json).not_to be_empty
    expect(json['_metadata']).not_to be_empty
    expect(json['_metadata']['total_count']).to eq(0)
  end

end