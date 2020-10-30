defmodule HinduLunar do
  @moduledoc """
  The `HinduLunar` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      leap_month: boolean,
      day: 1..30,
      leap_day: boolean
    ],

    holidays: [
      rama: ["Birthday of Rama"],
      diwali: ["Diwali"],
      shiva: ["Great Night of Shiva"],
      hindu_lunar_new_year: ["Hindu Lunar New Year"],
      mesha_samkranti: ["Mesha Samkranti"],
      sacred_wednesdays: ["Sacred Wednesday (first)"],
    ]
  ]
end

