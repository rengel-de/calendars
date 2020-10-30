defmodule Egyptian do
  @moduledoc """
  The `Egyptian` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..13,
      day: 1..10
    ]
  ]
end
