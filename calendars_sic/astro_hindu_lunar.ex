defmodule AstroHinduLunar do
  @moduledoc """
  The `AstroHinduLunar` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      leap_month: boolean,
      day: 1..30,
      leap_day: boolean
    ]
  ]
end

