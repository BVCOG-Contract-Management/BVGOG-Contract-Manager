require 'rails_helper'

RSpec.describe "users/show", type: :view do
  include FactoryBot::Syntax::Methods
  before(:each) do
    program =  FactoryBot.create(:program) 
    @user = FactoryBot.create(:user, program: program)
  end

  it "renders attributes in <p>" do
    render
  end
end
