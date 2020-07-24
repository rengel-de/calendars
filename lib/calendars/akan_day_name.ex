defmodule Calendars.AkanDayName do
  @moduledoc """
  Documentation for the AkanDayName calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep prefix :: 1..6
  @typep stem   :: 1..7
  @type  t      :: {prefix, stem}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :akan_name

  @doc """
  Returns a AkanDayName date from its parts.
  """
  def date(prefix, stem), do: {prefix, stem}

  @doc """
  Returns the epoch of the AkanDayName calendar.
  """
  def epoch, do: Calixir.akan_day_name_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AkanDayName date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AkanDayName date.
  """
  def from_fixed(fixed) do
    Calixir.akan_day_name_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding AkanDayName date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
