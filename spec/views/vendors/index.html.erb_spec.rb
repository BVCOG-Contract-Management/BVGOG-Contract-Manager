require 'rails_helper'

RSpec.describe "vendors/index", type: :view do
  before(:each) do
    assign(:vendors, [
      Vendor.create!(),
      Vendor.create!()
    ])
  end

  it "renders a list of vendors" do
    render
  end
end
