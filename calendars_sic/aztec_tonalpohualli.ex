defmodule AztecTonalpohualli do
  @moduledoc """
  The `AztecTonalpohualli` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      tonal_number: 1..20,
      tonal_name: 1..13
    ]
  ]
end
