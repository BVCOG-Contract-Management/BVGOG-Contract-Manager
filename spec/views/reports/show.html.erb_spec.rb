# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'reports/show', type: :view do
  before(:each) do
    @report = assign(:report, Report.create!)
  end

  pending 'renders attributes in <p>' do
    render
  end
end
