# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the VendorsHelper. For example:
#
# describe VendorsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
#
RSpec.describe VendorsHelper, type: :helper do
    let(:vendor) { create(:vendor) } # assuming you're using FactoryBot

    describe '#average_rating_stars' do
        it 'returns 0 stars when there are no reviews' do
            expect(helper.average_rating_stars(vendor)).to eq("<span class=\"icon\"><i class='far fa-star'></i></span>" * 5)
        end

        it 'returns the correct number of full, half, and empty stars' do
            create(:vendor_review, vendor:, rating: 3.5)
            expect(helper.average_rating_stars(vendor)).to include("<span class=\"icon\"><i class='fas fa-star has-text-warning'></i></span>" * 3)
            expect(helper.average_rating_stars(vendor)).to include("<span class=\"icon\"><i class='fas fa-star-half-alt has-text-warning'></i></span>")
            expect(helper.average_rating_stars(vendor)).to include("<span class=\"icon\"><i class='far fa-star'></i></span>")
        end
    end

    describe '#bar_chart_reviews_html' do
        it 'returns empty bar chart when there are no reviews' do
            expect(helper.bar_chart_reviews_html(vendor)).to include('width: 0%')
        end

        it 'returns correct percentage bar chart when there are reviews' do
            create(:vendor_review, vendor:, rating: 5)
            create(:vendor_review, vendor:, rating: 4)
            create(:vendor_review, vendor:, rating: 4)
            create(:vendor_review, vendor:, rating: 3)
            expect(helper.bar_chart_reviews_html(vendor)).to include('5 star')
            expect(helper.bar_chart_reviews_html(vendor)).to include('width: 25%')
            expect(helper.bar_chart_reviews_html(vendor)).to include('4 star')
            expect(helper.bar_chart_reviews_html(vendor)).to include('width: 50%')
            expect(helper.bar_chart_reviews_html(vendor)).to include('3 star')
            expect(helper.bar_chart_reviews_html(vendor)).to include('width: 25%')
        end
    end
end
