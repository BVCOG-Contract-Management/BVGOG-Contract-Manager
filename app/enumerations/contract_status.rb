# frozen_string_literal: true

# A enum of valid contract satuses
class ContractStatus < EnumerateIt::Base
    associate_values(
        :created,
        :in_progress,
        :in_review,
        :approved,
        :rejected
    )
end
