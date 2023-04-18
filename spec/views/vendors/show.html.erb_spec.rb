require 'rails_helper'

RSpec.describe "vendors/show", type: :view do
  before(:each) do
    @vendor = assign(:vendor, Vendor.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
