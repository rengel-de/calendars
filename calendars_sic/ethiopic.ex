defmodule Ethiopic do
  @moduledoc """
  Documentation for the Ethiopic calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..31
    ]
  ]
end
