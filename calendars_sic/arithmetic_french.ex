defmodule ArithmeticFrench do
  @moduledoc """
  Documentation for the `ArithmeticFrench` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..30
    ]
  ]
end