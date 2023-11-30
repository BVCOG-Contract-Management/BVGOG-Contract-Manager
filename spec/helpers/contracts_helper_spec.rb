# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ContractsHelper. For example:
#
# describe ContractsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
# RSpec.describe ContractsHelper, type: :helper do
#     pending "add some examples to (or delete) #{__FILE__}"
# end

include ContractsHelper

RSpec.describe ContractsHelper, type: :helper do
    describe '#vendor_select_options_json' do
      it 'returns JSON representation of vendor select options' do
        existing_vendors = Vendor.all
        expected_options = existing_vendors.map { |vendor| { 'label' => vendor.name, 'value' => vendor.id } }
        expected_options.push({ 'label' => 'New Vendor', 'value' => 'new' })   
        expect(helper.send(:vendor_select_options_json)).not_to be_empty 
        expect(JSON.parse(helper.send(:vendor_select_options_json))).to eq(expected_options)
      end
    end
  end
