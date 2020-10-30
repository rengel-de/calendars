defmodule Bahai do
  @moduledoc """
  The `Bahai` calendar module.
  """
  use Calendars, [

    fields: [
      major: integer,
      cycle: 1..19,
      year: 1..19,
      month: 0..19,
      day: 1..19
    ],

    holidays: [
      bahai_new_year: ["Baha'i New Year"],
      birth_of_the_bab: ["Birth of the Bab"],
      naw_ruz: ["Feast of Naw-Ruz"],
      feast_of_ridvan: ["Feast of Ridvan"]
    ]
  ]
end
