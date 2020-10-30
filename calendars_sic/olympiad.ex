defmodule Olympiad do

  @moduledoc """
  The `Olympiad` calendar module.

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonic
  or another cyclical calendar.
  """
  use Calendars, [
    fields: [
      cycle: :integer,
      year: 1..4
    ],

    from_fixed: fn fixed ->
      fixed
      |> Calixir.julian_from_fixed
      |> elem(0)
      |> Calixir.olympiad_from_julian_year
    end,

    start_of_calendar: fn -> Calixir.bce(776) end
  ]

  @doc """
  Converts a Julian year into its Olympiad equivalent.
  #{CalendarDocs.gen_doc_tests(__MODULE__, :from_julian_year, [
    -776, Calixir.olympiad_from_julian_year(-776),
    2020, Calixir.olympiad_from_julian_year(2020)
  ])}
  """
  @spec from_julian_year(integer) :: olympiad_date
  def from_julian_year(julian_year) do
    Calixir.olympiad_from_julian_year(julian_year)
  end

  @doc """
  Converts a Olympiad into the equivalent Julian year.
  #{CalendarDocs.gen_doc_tests(__MODULE__, :to_julian_year, [
    {1, 1}, Calixir.julian_year_from_olympiad({1, 1}),
    {2020, 2}, Calixir.julian_year_from_olympiad({2020, 2})
  ])}
  """
  @spec to_julian_year(olympiad_date) :: integer
  def to_julian_year({cycle, year}) do
    Calixir.julian_year_from_olympiad({cycle, year})
  end

end
