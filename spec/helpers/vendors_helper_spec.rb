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
RSpec.describe VendorsHelper, type: :helper do
  describe '#average_rating_stars' do
    let(:vendor) { FactoryBot.create(:vendor) }
    let(:vendor_review1) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
    let(:vendor_review2) { FactoryBot.create(:vendor_review, vendor:, rating: 2) }

    context 'when the vendor has no reviews' do
      it 'returns 0 stars' do
        expect(average_rating_stars(vendor)).to eq(stars_html(0))
      end
    end

    context 'when the vendor has reviews' do
      before do
        vendor_review1
        vendor_review2
      end

      it 'returns the correct average rating in stars' do
        expect(average_rating_stars(vendor)).to eq(stars_html(3))
      end
    end
  end

  describe '#stars_html' do
    it 'returns the correct HTML for a rating with full, half, and empty stars' do
      expect(stars_html(3.5)).to eq('<span class="icon"><i class=\'fas fa-star has-text-warning\'></i></span>' \
                                    '<span class="icon"><i class=\'fas fa-star has-text-warning\'></i></span>' \
                                    '<span class="icon"><i class=\'fas fa-star has-text-warning\'></i></span>' \
                                    '<span class="icon"><i class=\'fas fa-star-half-alt has-text-warning\'></i></span>' \
                                    '<span class="icon"><i class=\'far fa-star\'></i></span>')
    end

    it 'returns the correct HTML for a rating with only full stars' do
      expect(stars_html(2)).to eq('<span class="icon"><i class=\'fas fa-star has-text-warning\'></i></span>' \
                                  '<span class="icon"><i class=\'fas fa-star has-text-warning\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>')
    end

    it 'returns the correct HTML for a rating with only empty stars' do
      expect(stars_html(0)).to eq('<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>' \
                                  '<span class="icon"><i class=\'far fa-star\'></i></span>')
    end
  end

  describe '#bar_chart_reviews_html' do
    let(:vendor) { FactoryBot.create(:vendor) }

    context 'when there are reviews' do
      let!(:review1) { FactoryBot.create(:vendor_review, vendor:, rating: 5) }
      let!(:review2) { FactoryBot.create(:vendor_review, vendor:, rating: 5) }
      let!(:review3) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
      let!(:review4) { FactoryBot.create(:vendor_review, vendor:, rating: 3) }
      let!(:review5) { FactoryBot.create(:vendor_review, vendor:, rating: 2) }

      context 'when all reviews have the same rating' do
        let!(:review1) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
        let!(:review2) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
        let!(:review3) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
        let!(:review4) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }
        let!(:review5) { FactoryBot.create(:vendor_review, vendor:, rating: 4) }

        it 'returns a chart with 100% for the rating' do
          chart_html = helper.bar_chart_reviews_html(vendor)

          expect(chart_html).to include('4 star')
          expect(chart_html).to include('100%')
        end
      end
    end
  end
end
