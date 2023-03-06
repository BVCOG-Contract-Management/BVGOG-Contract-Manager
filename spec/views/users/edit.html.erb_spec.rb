require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  include FactoryBot::Syntax::Methods
  before(:each) do
    program =  FactoryBot.create(:program) 
    @user = FactoryBot.create(:user, program: program)
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do
    end
  end
end
