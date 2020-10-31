defmodule Coptic do
  @moduledoc """
  Documentation for the Coptic calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..31
    ],

    holidays: [
      coptic_christmas: ["Coptic Christmas"]
    ]
  ]
end
