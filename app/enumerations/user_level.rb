class UserLevel < EnumerateIt::Base
  associate_values(
    :zero,
    :one,
    :two,
    :three
  )
end
