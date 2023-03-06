require 'rails_helper'

RSpec.describe "users/index", type: :view do
  include FactoryBot::Syntax::Methods
  before(:each) do
    program =  FactoryBot.create(:program) 
    user1 = create(:user, program: program)
    user2 = create(:user, program: program)
    assign(:users, [
      user1,
      user2
    ])
  end

  it "renders a list of users" do
    render
  end
end
