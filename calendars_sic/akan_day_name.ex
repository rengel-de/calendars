defmodule AkanName do
  @moduledoc """
  The `AkanName` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      prefix: 1..6,
      stem: 1..7
    ],

    from_fixed: fn fixed -> Calixir.akan_name_from_fixed(fixed) end
  ]
end
