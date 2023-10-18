# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendors/new', type: :view do
    before do
        assign(:vendor, Vendor.new)
    end

    it 'renders new vendor form' do
        render

        assert_select 'form[action=?][method=?]', vendors_path, 'post' do
        end
    end
end
