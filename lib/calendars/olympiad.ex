defmodule Calendars.Olympiad do
  @moduledoc """
  Documentation for the Olympiad calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep cycle :: integer
  @typep year  :: 1..4
  @type  t     :: {cycle, year}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :olympiad

  @doc """
  Returns a Olymiad date from its parts.
  """
  def date(cycle, year), do: {cycle, year}

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Olympiad date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Olympiad date.
  """
  def from_fixed(fixed) do
    fixed
    |> Calixir.julian_from_fixed
    |> Calixir.olympiad_from_julian_year
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Olympiad date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
