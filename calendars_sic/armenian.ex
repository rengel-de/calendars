defmodule Armenian do
  @moduledoc """
  The `Armenian` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..10
    ]
  ]
end
