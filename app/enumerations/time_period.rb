class TimePeriod < EnumerateIt::Base
  associate_values(
    :second,
    :minute,
    :hour,
    :day,
    :week,
    :month,
    :year
  )
end
