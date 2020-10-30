defmodule OldHinduLunar do
  @moduledoc """
  The `OldHinduLunar` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      leap: boolean,
      day: 1..30
    ]
  ]

end
