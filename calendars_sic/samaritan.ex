defmodule Samaritan do
  @moduledoc """
  The `Samaritan` calendar module.
  """
  use Calendars, [

    fields: [
      year: :integer,
      month: 1..12,
      day: 1..30
    ]

  ]

end
