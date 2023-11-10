# frozen_string_literal: true

class ReportType < EnumerateIt::Base
    associate_values(
        :contracts,
        :users
    )
end
