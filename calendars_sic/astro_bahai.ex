defmodule AstroBahai do
  @moduledoc """
  The `AstroBahai` calendar module.
  """
  use Calendars, [
    fields: [
      major: integer,
      cycle: 1..19,
      year: 1..19,
      month: 0..19,
      day: 1..19,
    ]
  ]
end
