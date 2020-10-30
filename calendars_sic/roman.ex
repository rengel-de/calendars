defmodule Roman do
  @moduledoc """
  The `Roman` calendar module.
  """
  use Calendars, [

    fields: [
      year: :non_zero_integer,
      month: 1..12,
      event: 1..3,
      count: 1..19,
      leap: :boolean
    ]

  ]

end
