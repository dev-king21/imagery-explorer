require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it "signs user in and out" do
    user = create(:confirmed_user)
    sign_in user
    get root_path
    expect(response).to render_template(:index)

    sign_out user
    get root_path
    expect(response).to render_template(:index)
  end
end
