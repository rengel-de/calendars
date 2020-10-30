defmodule Persian do
  @moduledoc """
  The `Persian` calendar module.
  """
  use Calendars, [

    fields: [
      year: :non_zero_integer,
      month: 1..12,
      day: 1..31
    ],

    months: [
      farvardin: [1, "Farvardin", 31],
      ordibehesht: [2, "Ordibehesht", 31],
      khordad: [3, "Khordad", 31],
      tir: [4, "Tir", 31],
      mordad: [5, "Mordad", 31],
      shahrivar: [6, "Shahrivar", 31],
      mehr: [7, "Mehr", 30],
      aban: [8, "Aban", 30],
      azar: [9, "Azar", 30],
      dey: [10, "Dey", 30],
      bahman: [11, "Bahman", 30],
      esfand: [12, "Esfand", 29, :leap_month, 30]
    ],

    calixir_api: [
      persian_epoch: [[], "15.1"],
      tehran: [[], "15.2"],
      midday_in_tehran: [[:fixed], "15.3"],
      persian_new_year_on_or_before: [[:fixed], "15.4"],
      fixed_from_persian: [[:year, :month, :day], "15.5"],
      persian_from_fixed: [[:fixed], "15.6"],
      arithmetic_persian_leap_year?: [[:year], "15.7"],
      fixed_from_arithmetic_persian: [[:year, :month, :day], "15.8"],
      arithmetic_persian_year_from_fixed: [[:fixed], "15.9"],
      arithmetic_persian_from_fixed: [[:fixed], "15.10"],
      nowruz: [[:gregorian_year], :holiday, "Nowruz", "15.11"],
    ]

  ]

end
