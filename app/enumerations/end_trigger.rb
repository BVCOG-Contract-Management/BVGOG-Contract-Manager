# frozen_string_literal: true

class EndTrigger < EnumerateIt::Base
    associate_values(
        :limited_term,
        :upon_completion,
        :continuous
    )
end
