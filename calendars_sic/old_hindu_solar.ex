defmodule OldHinduSolar do
  @moduledoc """
  The `OldHinduSolar` calendar module.
  """
  use Calendars, [

    fields: [
      year: integer,
      month: 1..12,
      day: 1..30
    ]

  ]

end
