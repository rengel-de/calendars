defmodule French do
  @moduledoc """
  Documentation for the `French` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..30
    ]
  ]
end
