defmodule Calendars.Roman do
  @moduledoc """
  Documentation for the Roman calendar (DR4).
  """
  @typep year  :: neg_integer | pos_integer
  @typep month :: 1..12
  @typep event :: 1..3
  @typep count :: 1..19
  @typep leap  :: boolean
  @type  t     :: {year, month, event, count, leap}

  # @typep ides  :: 13 | 15  # unsued type, for doc only

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :roman

  @doc """
  Returns a Roman date from its parts.
  """
  def date(year, month, event, count, leap) do
    {year, month, event, count, leap}
  end

  @doc """
  Returns the epoch of the Roman calendar.
  """
  def epoch, do: Calixir.julian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Roman date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Roman date.
  """
  def from_fixed(fixed) do
    Calixir.roman_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Roman date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `roman_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(roman_date, target_calendar) do
    roman_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `roman_date` into the corresponding `fixed` date.
  """
  def to_fixed(roman_date) do
    Calixir.fixed_from_roman(roman_date)
  end

  @doc """
  Converts `roman_date` into the corresponding Julian Day number.
  """
  def to_jd(roman_date) do
    roman_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
