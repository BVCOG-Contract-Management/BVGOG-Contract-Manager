# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/show', type: :view do
    include Devise::Test::IntegrationHelpers
    include Devise::Test::ControllerHelpers
    include FactoryBot::Syntax::Methods

    before do
        login_user
        @contract = assign(:contract, create(:contract))
    end

    it 'renders attributes in <p>' do
        render
    end
end
