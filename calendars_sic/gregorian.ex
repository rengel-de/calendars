defmodule Gregorian do
  @moduledoc """
  The `Gregorian` calendar module.
  """
  use Calendars, [

    fields: [
      year: integer,
      month: 1..12,
      day: 1..31
    ],

    quarters: [
      i: [1, "I", {:year, 1, 1}, {:year, 3, 31}, [90, 91]],
      ii: [2, "II", {:year, 4, 1}, {:year, 6, 30}, 91],
      iii: [3, "III", {:year, 7, 1}, {:year, 9, 30}, 92],
      iv: [4, "IV", {:year, 10, 1}, {:year, 12, 31}, 92]
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
      saturday: [6, "Saturday", "1.59"]
    ],

    holidays: [
      independence_day: ["U.S. Independence Day", "2.32"],
      labor_day: ["U.S. Labor Day", "2.36"],
      memorial_day: ["U.S. Memorial Day", "2.37"],
      election_day: ["U.S. Election Day", "2.38"],
      daylight_saving_start: ["Daylight Saving Start", "2.39"],
      daylight_saving_end: ["Daylight Saving End", "2.40"],
      christmas: ["Christmas", "2.41"],
      advent: ["Advent Sunday", "2.42"],
      epiphany: ["Epiphany", "2.43"],
      unlucky_fridays: ["Friday the 13th (first)", "2.45"],
      # From Ecclesiastical Calendars
      easter: ["Easter", "9.3"],
      pentecost: ["Pentecost", "9.4"]
    ],

    calixir_api: [ # without months, weekdays, and holidays
      gregorian_epoch: [[], "2.3"],
      gregorian_leap_year?: [[:year], "2.16"],
      fixed_from_gregorian: [[:year, :month, :day], "2.17"],
      gregorian_new_year: [[:year], "2.18"],
      gregorian_year_end: [[:year], "2.19"],
      gregorian_year_range: [[:year], "2.20"],
      gregorian_year_from_fixed: [[:fixed], "2.21"],
      gregorian_from_fixed: [[:fixed], "2.23"],
      gregorian_date_difference: [[:date1, :date2], "2.24"],
      day_number: [[:date], "2.25"],
      days_remaining: [[:date], "2.26"],
      last_day_of_gregorian_month: [[:year, :month], "2.27"],
      # alt_fixed_from_gregorian: [[:year, :month, :day], "2.28"],
      # alt_gregorian_from_fixed: [[:fixed], "2.29"],
      # alt_gregorian_year_from_fixed: [[:fixed], "2.30"],
      nth_kday: [[:n, :k, :date], "2.33"],
      first_kday: [[1, :k, :date], "2.34"],
      last_kday: [[-1, :k, :date], "2.35"],
      unlucky_fridays_in_range: [[:a, :b], "2.44"],
    ],

    # Common functions
    start_of_calendar: fn -> Calixir.fixed_from_gregorian(1582, 10, 15) end,

    # Year functions
    add_years: fn fixed, years -> fixed + years * 365.2425 |> trunc end,
    day_of_year: fn date -> Calixir.day_number(date) end,
    days_in_year: fn y -> Calixir.gregorian_leap_year?(y) && 366 || 365 end,
    days_remaining_in_year: fn date -> Calixir.days_remaining(date) end,
    end_of_year: fn y -> Calixir.fixed_from_gregorian(y, 12, 31) end,
    last_month_of_year: fn _y -> 12 end,
    leap_year?: fn y -> Calixir.gregorian_leap_year?(y) end,
    mean_year: fn -> 365.2425 end,         # Avreage year length
    months_in_year: fn _year -> 12 end,
    new_year: fn y -> Calixir.fixed_from_gregorian(y, 1, 1) end,
    start_of_year: fn y -> Calixir.fixed_from_gregorian(y, 1, 1) end,
    year_end: fn y -> Calixir.fixed_from_gregorian(y, 12, 31) end,

    # Quarter functions
    add_quarters: fn fixed, quarters -> fixed + quarters * 365.2425 / 4 |> trunc end,

    day_of_quarter: fn
      fixed -> (
                 {year, month, _} = Calixir.gregorian_from_fixed(fixed)
                 {y, m, d} = cond do
                   month < 4 -> {year - 1, 12, 31}
                   month < 7 -> {year, 3, 31}
                   month < 10 -> {year, 6, 30}
                   true -> {year, 9, 30}
                 end
                 fixed - Calixir.fixed_from_gregorian(y, m, d))
    end,

    days_in_quarter: fn
      fixed -> (
                 {year, month, _} = Calixir.gregorian_from_fixed(fixed)
                 cond do
                   month < 4 -> Calixir.gregorian_leap_year?(year) && 91 || 90
                   month < 7 -> 91
                   true -> 92
                 end)
    end,

    days_remaining_in_quarter: fn
      fixed -> (
                 {year, month, _} = Calixir.gregorian_from_fixed(fixed)
                 {m, d} = cond do
                   month < 4 -> {3, 31}
                   month < 7 -> {6, 30}
                   month < 10 -> {9, 30}
                   true -> {12, 31}
                 end
                 Calixir.fixed_from_gregorian(year, m, d) - fixed)
    end,

    quarter: fn m -> div(m - 1, 3) + 1 end,

    end_of_quarter: fn
      year, 1 -> Calixir.fixed_from_gregorian(year,  3, 31)
      year, 2 -> Calixir.fixed_from_gregorian(year,  6, 30)
      year, 3 -> Calixir.fixed_from_gregorian(year,  9, 30)
      year, 4 -> Calixir.fixed_from_gregorian(year, 12, 31)
    end,

    mean_quarter: fn -> 365.2425 / 4 end,  # Average quarter length

    start_of_quarter: fn
      year, 1 -> Calixir.fixed_from_gregorian(year,  1, 1)
      year, 2 -> Calixir.fixed_from_gregorian(year,  4, 1)
      year, 3 -> Calixir.fixed_from_gregorian(year,  7, 1)
      year, 4 -> Calixir.fixed_from_gregorian(year, 10, 1)
    end,

    # Month functions
    add_months: fn fixed, months -> fixed + months * 365.2425 / 12 |> trunc end,
    day_of_month: fn fixed -> Calixir.gregorian_from_fixed(fixed) |> elem(2) end,
    days_in_month: fn y, m -> Calixir.last_day_of_gregorian_month(y, m) end,
    days_remaining_in_month: fn {y, m, d} -> Calixir.last_day_of_gregorian_month(y, m) - d end,
    end_of_month: fn y, m -> {y, m, Calixir.last_day_of_gregorian_month(y, m)} end,
    mean_month: fn -> 365.2425 / 12 end,   # Average month length
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
