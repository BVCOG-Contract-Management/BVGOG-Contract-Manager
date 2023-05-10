class TimePeriod < EnumerateIt::Base
  associate_values(
    :day,
    :week,
    :month,
    :year
  )
end
