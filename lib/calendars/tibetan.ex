defmodule Tibetan do
  @moduledoc """
  The `Tibetan` calendar module.
  """
  use Calendars, [

    fields: [
      year: :integer,
      month: 1..12,
      leap_month: :boolean,
      day: 1..30,
      leap_day: :boolean
    ],

    holidays: [
      tibetan_new_year: ["Losar", "21.9"]
    ],

    calixir_api: [
      tibetan_epoch: [[], "21.1"],
      tibetan_sun_equation: [[:alpha], "21.2"],
      tibetan_moon_equation: [[:alpha], "21.3"],
      fixed_from_tibetan: [[:year, :month, :leap_month, :day, :leap_day], "21.4"],
      tibetan_from_fixed: [[:fixed], "21.5"],
      tibetan_leap_month?: [[:year, :month], "21.6"],
      tibetan_leap_day?: [[:year, :month, :day], "21.7"],
      tibetan_new_year: [[:gregorian_year], "21.9"]
    ]

  ]

end
