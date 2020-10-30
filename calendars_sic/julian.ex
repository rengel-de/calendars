defmodule Julian do
  @moduledoc """
  The `Julian` calendar module.
  """
  use Calendars, [
    fields: [
      year: integer,
      month: 1..12,
      day: 1..31
    ],

    months: [
      january: [1, "January", 31, "2.4"],
      february: [2, "February", [28, 29], "2.5"],
      march: [3, "March", 31, "2.6"],
      april: [4, "April", 30, "2.7"],
      may: [5, "May", 31, "2.8"],
      june: [6, "June", 30, "2.9"],
      july: [7, "July", 31, "2.10"],
      august: [8, "August", 31, "2.11"],
      september: [9, "September", 30, "2.12"],
      october: [10, "October", 31, "2.13"],
      november: [11, "November", 30, "2.14"],
      december: [12, "December", 31, "2.15"],
    ],

    weekdays: [
      sunday: [0, "Sunday", "1.53"],
      monday: [1, "Monday", "1.54"],
      tuesday: [2, "Tuesday", "1.55"],
      wednesday: [3, "Wednesday", "1.56"],
      thursday: [4, "Thursday", "1.57"],
      friday: [5, "Friday", "1.58"],
      saturday: [6, "Saturday", "1.59"],
    ],

    holidays: [
      eastern_orthodox_christmas: ["Christmas (Orthodox)"],
      orthodox_easter: ["Easter (Orthodox)"],
      alt_orthodox_easter: ["Easter (Orthodox) Alt"]
    ],

    start_of_calendar: fn -> Calixir.fixed_from_julian(Calixir.bce(46), 1, 1) end,

    # Year functions
    mean_year: fn -> 365.25 end, # Average year length
    months_in_year: fn _y -> 12 end,
    add_years: fn fixed, years -> fixed + years * 365.25 |> trunc end,
    day_of_year: fn date -> Calixir.day_number(date) end,
    days_in_year: fn y -> Calixir.julian_leap_year?(y) && 366 || 365 end,
    days_remaining_in_year: fn date -> Calixir.days_remaining(date) end,
    end_of_year: fn y -> Calixir.fixed_from_julian(y, 12, 31) end,
    leap_year?: fn y -> Calixir.julian_leap_year?(y) end,
    start_of_year: fn y -> Calixir.fixed_from_julian(y, 1, 1) end,

    # Month functions
    day_of_month: fn fixed -> Calixir.julian_from_fixed(fixed) |> elem(2) end,
    days_in_month: fn
      y, 2 -> Calixir.julian_leap_year?(y) && 29 || 28
      _, m -> Enum.at([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], m - 1)
    end,
    days_remaining_in_month: fn {y, m, d} -> Calixir.last_day_of_gregorian_month(y, m) - d end,
    end_of_month: fn y, m -> {y, m, Calixir.last_day_of_gregorian_month(y, m)} end,
    start_of_month: fn y, m -> {y, m, 1} end,

    # Weekday functions
    add_weeks: fn fixed, weeks -> fixed + weeks * 7 end,
    day_of_week: fn fixed -> Calixir.day_of_week_from_fixed(fixed) end,
    days_in_week: fn -> 7 end,
    end_of_week: fn fixed -> fixed + 6 - Calixir.day_of_week_from_fixed(fixed) end,
    start_of_week: fn fixed -> fixed - Calixir.day_of_week_from_fixed(fixed) end,
    weekday: fn fixed -> Calixir.day_of_week_from_fixed(fixed) end,

  ]

  @doc false
  def date_text({year, _, day} = date) do
    weekday_name = weekday(date, :name)
    month_name = month(date, :name)
    "#{weekday_name}, #{month_name} #{day}, #{year}"
  end

end
