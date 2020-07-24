defmodule Calendars.DayOfWeek do
  @moduledoc """
  Documentation for the DayOfWeek calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep day_of_week :: 0..6
  @type  t :: day_of_week

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :weekday

  @doc """
  Returns a DayOfWeek date from its parts.
  """
  def date(weekday), do: weekday

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding DayOfWeek date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date into the corresponding DayOfWeek.
  """
  def from_fixed(fixed) do
    Calixir.day_of_week_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding DayOfWeek.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end