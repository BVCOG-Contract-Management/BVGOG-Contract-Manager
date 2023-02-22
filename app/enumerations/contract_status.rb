class ContractStatus < EnumerateIt::Base
  associate_values(
    :approved,
    :in_progress
  )
end
