# frozen_string_literal: true

class TimePeriod < EnumerateIt::Base
    associate_values(
        :day,
        :week,
        :month,
        :year
    )
end
