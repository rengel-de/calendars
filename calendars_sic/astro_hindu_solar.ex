defmodule AstroHinduSolar do
  @moduledoc """
  The `AstroHinduSolar` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      day: 1..32
    ]
  ]
end
