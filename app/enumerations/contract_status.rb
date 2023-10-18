# frozen_string_literal: true

class ContractStatus < EnumerateIt::Base
    associate_values(
        :approved,
        :in_progress
    )
end
