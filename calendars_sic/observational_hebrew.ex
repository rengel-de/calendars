defmodule ObservationalHebrew do
  @moduledoc """
  The `ObservationalHebrew` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      day: 1..30
    ],

    holidays: [
      observational_hebrew_first_of_nisan: ["Observ. Hebrew 1 Nisan"],
      classical_passover_eve: ["Passover Eve (Classical)"]
    ]
  ]
end
