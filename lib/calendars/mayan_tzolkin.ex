defmodule Calendars.MayanTzolkin do
  @moduledoc """
  Documentation for the MayanTzolkin calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep tzolkin_name   :: 1..20
  @typep tzolkin_number :: 1..13
  @type  t              :: {tzolkin_name, tzolkin_number}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :mayan_tzolkin

  @doc """
  Returns a MayanTzolkin date from its parts.
  """
  def date(tzolkin_name, tzolkin_number) do
    {tzolkin_name, tzolkin_number}
  end

  @doc """
  Returns the epoch of the MayanTzolkin calendar.
  """
  def epoch, do: Calixir.mayan_tzolkin_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding MayanTzolkin date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding MayanTzolkin date.
  """
  def from_fixed(fixed) do
    Calixir.mayan_tzolkin_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding MayanTzolkin date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
