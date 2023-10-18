# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/edit', type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before do
    login_user
    @contract = assign(:contract, create(:contract))
  end

  it 'renders the edit contract form' do
    render

    assert_select 'form[action=?][method=?]', contract_path(@contract), 'post' do
    end
  end
end
