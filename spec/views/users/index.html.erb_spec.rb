require 'rails_helper'
require 'auth_helper'

RSpec.describe "users/index", type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before(:each) do
    login_user
    users = []
    program =  FactoryBot.create(:program)
    for i in 1..15
      users << create(:user, program: program)
    end
    @users = Kaminari.paginate_array(users).page(1).per(10)
  end

  it "renders a list of users" do
    render
    assert_select "tbody>tr", count: 10
  end
end
