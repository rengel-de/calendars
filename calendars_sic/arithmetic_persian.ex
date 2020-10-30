defmodule ArithmeticPersian do
  @moduledoc """
  Documentation for the ArithmeticPersian calendar module.
  """
  use Calendars, [
    fields: [
      year: neg_integer | pos_integer,
      month: 1..12,
      day: 1..31
    ]
  ]
end
