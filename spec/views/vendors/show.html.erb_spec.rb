require 'rails_helper'
require 'auth_helper'

RSpec.describe "vendors/show", type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before(:each) do
    login_user
    @vendor = FactoryBot.create(:vendor)
  end

  it "renders attributes in <p>" do
    render
  end
end
