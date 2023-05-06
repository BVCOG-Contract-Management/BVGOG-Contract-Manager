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

    def bar_chart_reviews_html(vendor)
        # Creates an amazon-like bar chart of reviews
        # ex. 
        # 5 star |******** | 70%
        # 4 star |*****    | 20%
        # 3 star |**       | 10%
        # 2 star |         | 0%
        # 1 star |         | 0%
        # ----------------------

        # Get all reviews for vendor
        vendor_reviews = vendor.vendor_reviews
        # Get total number of reviews
        total_reviews = vendor_reviews.count
        # Get number of reviews for each rating
        reviews_by_rating = {}
        vendor_reviews.each do |review|
            review_rating = review.rating.to_i
            reviews_by_rating[review_rating] = reviews_by_rating[review_rating] ? reviews_by_rating[review_rating] + 1 : 1
        end
        # Create a hash of ratings with the number of reviews for each rating
        ratings = {}
        (1..5).each do |rating|
          ratings[rating] = reviews_by_rating[rating] || 0
        end

        # Create a hash of ratings with the percentage of reviews for each rating
        ratings_percentages = {}
        ratings.each do |rating, count|
            if vendor_reviews.empty?
                ratings_percentages[rating] = 0
                next
            end
            ratings_percentages[rating] = (count.to_f / total_reviews * 100).round
        end

        print ratings_percentages
        
        # Create html for bar chart
        bar_chart_html = ""
        (1..5).reverse_each do |rating|
            bar_chart_html += """
            <div class=\"columns is-1 is-variable review-percentage-container\">
                <div class=\"column is-3 review-percentage-star-count\">
                    <span><strong>#{rating} star</strong></span>
                </div>
                <div class=\"column is-7\">
                    <div class=\"review-percentage-bar\">
                        <div class=\"review-percentage-fill\" style=\"width: #{ratings_percentages[rating]}%\"></div>
                    </div>
                </div>
                <div class=\"column is-2 review-percentage-percent\">
                    <span>#{ratings_percentages[rating]}%</span>
                </div>
            </div>
            """
        end
        bar_chart_html.html_safe
    end
end
