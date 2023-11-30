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

    OPTIONS = {
        contract: "Contract",
        grant: "Grant",
        property_lease: "Property Lease",
        ila: "ILA",
        mou_moa: "MOU/MOA",
        letter_of_intent: "Letter of Intent",
        other: "Other"
      }
end
