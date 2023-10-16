# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendors/edit', type: :view do
  before(:each) do
    @vendor = FactoryBot.create(:vendor)
  end

  it 'renders the edit vendor form' do
    render

    assert_select 'form[action=?][method=?]', vendor_path(@vendor), 'post' do
    end
  end
end
