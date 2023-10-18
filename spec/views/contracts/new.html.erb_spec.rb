# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/new', type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before do
    login_user
    assign(:contract, Contract.new)
  end

  it 'renders new contract form' do
    render

    assert_select 'form[action=?][method=?]', contracts_path, 'post' do
    end
  end
end
