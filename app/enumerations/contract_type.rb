# frozen_string_literal: true

# Type of contract
class ContractType < EnumerateIt::Base
    associate_values(
        :contract,
        :grant,
        :property_lease,
        :ila,
        :mou_moa,
        :letter_of_intent,
        :other
    )
end
