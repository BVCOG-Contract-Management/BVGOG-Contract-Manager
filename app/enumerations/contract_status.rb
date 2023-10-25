# frozen_string_literal: true

# A enum of valid contract satuses
class ContractStatus < EnumerateIt::Base
    associate_values(
        :approved,
        :in_progress,
        :rejected
    )
end
