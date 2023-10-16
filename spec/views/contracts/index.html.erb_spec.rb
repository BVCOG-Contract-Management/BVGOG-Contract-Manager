# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/index', type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before(:each) do
    login_user
    contracts = []
    # This test was failing because contracts were being created elsewhere, and the unique_id check was failing. Please advise.
    (100..115).each do |i|
      contracts << create(:contract, id: i, entity: create(:entity, id: i), program: create(:program, id: i),
                                     point_of_contact: create(:user, id: i), vendor: create(:vendor, id: i))
    end
    @contracts = Kaminari.paginate_array(contracts).page(1).per(10)
    # This assigns a Kaminari.paginate_array object to @contracts,
    # with the first page of 10 contracts.
  end

  it 'renders a list of contracts' do
    render
    # This checks that the rendered output contains 10 contracts,
    # which is the number of contracts per page.
    assert_select 'tbody>tr', count: 10
  end
end
