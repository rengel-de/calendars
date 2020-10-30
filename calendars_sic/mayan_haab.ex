defmodule MayanHaab do
  @moduledoc """
  The `MayanHaab` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic calendar
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      month: 1..19,
      day: 1..19
    ]
  ]
end
