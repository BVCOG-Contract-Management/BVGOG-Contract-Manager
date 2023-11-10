# frozen_string_literal: true

class UserLevel < EnumerateIt::Base
    associate_values(
        :zero,
        :one,
        :two,
        :three
    )
end
