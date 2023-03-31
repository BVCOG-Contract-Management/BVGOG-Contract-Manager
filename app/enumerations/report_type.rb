class ReportType < EnumerateIt::Base
  associate_values(
    :contracts,
    :users
  )
end
