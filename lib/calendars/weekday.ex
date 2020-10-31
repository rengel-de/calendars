defmodule Weekday do
  @moduledoc """
  The `Weekday` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      day: 0..6
    ],

    from_fixed: fn fixed -> {Calixir.day_of_week_from_fixed(fixed)}  end,

    weekdays: [
      sunday: [0, "Sunday", "1.53"],
      monday: [1, "Monday", "1.54"],
      tuesday: [2, "Tuesday", "1.55"],
      wednesday: [3, "Wednesday", "1.56"],
      thursday: [4, "Thursday", "1.57"],
      friday: [5, "Friday", "1.58"],
      saturday: [6, "Saturday", "1.59"],
    ]
  ]
end