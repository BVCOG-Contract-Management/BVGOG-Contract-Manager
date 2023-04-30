class ContractType < EnumerateIt::Base
  associate_values(
    :contract,
    :grant,
    :property_lease,
    :ila,
    :mou_moa,
    :letter_of_intent
  )
end
