require 'rails_helper'

RSpec.describe "users/show", type: :view do
  include FactoryBot::Syntax::Methods
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  it "renders attributes in <p>" do
    render
  end

end
