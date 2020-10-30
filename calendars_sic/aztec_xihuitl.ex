defmodule AztecXihuitl do
  @moduledoc """
  The `AxtecXihuitl` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      month: 1..19,
      day: 1..20
    ]
  ]
end
