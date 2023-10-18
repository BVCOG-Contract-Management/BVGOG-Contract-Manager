# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'vendors/index', type: :view do
    include Devise::Test::IntegrationHelpers
    include Devise::Test::ControllerHelpers
    include FactoryBot::Syntax::Methods

    before do
        login_user
        vendors = []
        (1..15).each do |_i|
            vendors << create(:vendor)
        end
        @vendors = Kaminari.paginate_array(vendors).page(1).per(10)
    end

    it 'renders a list of users' do
        render
        assert_select 'tbody>tr', count: 10
    end
end
