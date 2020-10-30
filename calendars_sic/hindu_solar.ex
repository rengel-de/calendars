defmodule HinduSolar do
  @moduledoc """
  The `HinduSolar` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      day: 1..32
    ]
  ]
end
