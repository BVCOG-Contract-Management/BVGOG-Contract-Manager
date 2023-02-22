require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  before(:each) do
    assign(:contracts, [
      Contract.create!(),
      Contract.create!()
    ])
  end

  it "renders a list of contracts" do
    render
  end
end
