# frozen_string_literal: true

class ContractDocumentType < EnumerateIt::Base
  associate_values(
    :other,
    :contract,
    :cost_analysis,
    :debarment,
    :procurement,
    :insurance
  )
end
