defmodule AztecXiuhmolpilli do
  @moduledoc """
  The `AztecXiuhmolpilli` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      xiuhmol_number: 1..13,
      xiuhmol_name: 1 | 8 | 13 | 18
    ]
  ]
end
