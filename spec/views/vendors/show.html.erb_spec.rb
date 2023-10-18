# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'vendors/show', type: :view do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  before do
    login_user
    @vendor = FactoryBot.create(:vendor)
  end

  it 'renders attributes in <p>' do
    render
  end
end
