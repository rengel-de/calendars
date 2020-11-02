defmodule Astronomical do
  @moduledoc """
  The `Astronomical` calendar module.

  From [Wikipedia, 2020-07-24](https://en.wikipedia.org/wiki/Astronomical_year_numbering):

  Astronomical year numbering is based on AD/CE year numbering,
  but follows normal decimal integer numbering more strictly.
  Thus, it has a year 0; the years before that are designated
  with negative numbers and the years after that are designated
  with positive numbers. Astronomers use the Julian calendar for
  years before 1582, including the year 0, and the Gregorian calendar
  for years after 1582, as exemplified by Jacques Cassini (1740),
  Simon Newcomb (1898) and Fred Espenak (2007).
  """
  use Calendars, [

    fields: [
      year: integer,
      month: 1..12,
      day: 1..31
    ],

    epoch: fn -> Calixir.gregorian_epoch() end,

    from_fixed: fn fixed ->
      if fixed < 577736,
        do: Calixir.julian_from_fixed(fixed),
        else: Calixir.gregorian_from_fixed(fixed)
    end,

    to_fixed: fn
      {y, m, d} when y < 1582 -> Calixir.fixed_from_julian(y, m, d)
      {y, m, d} when y > 1582 -> Calixir.fixed_from_gregorian(y, m, d)
      {y, m, d} when m < 10 -> Calixir.fixed_from_julian(y, m, d)
      {y, m, d} when m > 10 -> Calixir.fixed_from_gregorian(y, m, d)
      {y, m, d} when d < 15 -> Calixir.fixed_from_julian(y, m, d)
      {y, m, d} when d > 14 -> Calixir.fixed_from_gregorian(y, m, d)
    end,

    leap_year?: fn
      year when year < 1582 -> Calixir.julian_leap_year?(year)
      year when year > 1582 -> Calixir.gregorian_leap_year?(year)
      _year -> false
    end
  ]

  @doc """
  Returns the switch over date from the Julian to the Gregorian calendar
  as a fixed day.

  ## Example

      iex>#{__MODULE__}.switch_over()
      577736
  """
  @spec switch_over :: fixed
  def switch_over() do
    Calixir.fixed_from_gregorian(1582, 10, 15)
  end

end