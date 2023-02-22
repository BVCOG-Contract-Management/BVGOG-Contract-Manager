class ContractType < EnumerateIt::Base
  associate_values(
    :contract,
    :grant,
    :property_lease,
    :ILA,
    :MOU_MOA,
    :letter_of_intent
  )
end
