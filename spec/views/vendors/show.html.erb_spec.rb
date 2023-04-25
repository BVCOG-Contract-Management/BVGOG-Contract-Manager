require 'rails_helper'

RSpec.describe "vendors/show", type: :view do
  before(:each) do
    @vendor = FactoryBot.create(:vendor)
  end

  pending it "renders attributes in <p>" do
    render
  end
end
