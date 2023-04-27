module VendorsHelper
    def average_rating_stars(vendor)
        vendor_reviews = vendor.vendor_reviews
        if vendor_reviews.empty?
            average_rating = 0
        else
            average_rating = vendor_reviews.average(:rating)
        end
        # Round to nearest 0.5
        average_rating = (average_rating * 2).round / 2.0
        stars_html(average_rating)
      end

    def stars_html(rating)
        stars = ""
        # Add full stars while possible, then add half star if needed
        rating.floor.times { stars += "<span class=\"icon\"><i class='fas fa-star has-text-warning'></i></span>" }
        if rating % 1 != 0
          stars += "<span class=\"icon\"><i class='fas fa-star-half-alt has-text-warning'></i></span>"
        end
        # Add empty stars until 5 stars
        (5 - rating.ceil).times { stars += "<span class=\"icon\"><i class='far fa-star'></i></span>" }
        stars.html_safe
    end
end
