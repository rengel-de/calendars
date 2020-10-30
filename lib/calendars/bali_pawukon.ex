defmodule BaliPawukon do
  @moduledoc """
  The `BaliPawukon` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      luang: boolean,
      dwiwara: integer,
      triwara: integer,
      caturwara: integer,
      pancawara: integer,
      sadwara: integer,
      saptawara: integer,
      asatawara: integer,
      sangawara: integer,
      dasawara: integer
     ],

  holidays: [
    # kajeng_keliwon: ["Kajeng Keliwon (first)"],
    # tumpek: ["Tumpek (first)"]
    ]
  ]
end
