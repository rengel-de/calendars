defmodule MayanTzolkin do
  @moduledoc """
  The `MayanTzolkin` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic calendar
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      tzolkin_name: 1..20,
      tzolkin_number: 1..13
    ]
  ]

end
