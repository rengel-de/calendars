defmodule Calendars.MayanHaab do
  @moduledoc """
  Documentation for the MayanHaab calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep month :: 1..19
  @typep day   :: 1..19
  @type  t     :: {month, day}

  def keyword, do: :mayan_haab

  @doc """
  Returns a MayanHaab date from its parts.
  """
  def date(month, day) do
    {month, day}
  end

  @doc """
  Returns the epoch of the MayanHaab calendar.
  """
  def epoch, do: Calixir.mayan_haab_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding MayanHaab date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding MayanHaab date.
  """
  def from_fixed(fixed) do
    Calixir.mayan_haab_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding MayanHaab date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
