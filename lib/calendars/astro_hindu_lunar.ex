defmodule Calendars.AstroHinduLunar do
  @moduledoc """
  Documentation for the AstroHinduLunar calendar (DR4).
  """
  @typep year       :: integer
  @typep month      :: 1..12
  @typep leap_month :: boolean
  @typep day        :: 1..30
  @typep leap_day   :: boolean
  @type  t          :: {year, month, leap_month, day, leap_day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :astro_hindu_lunar

  @doc """
  Returns a AstroHinduLunar date from its parts.
  """
  def date(year, month, leap_month, day, leap_day) do
    {year, month, leap_month, day, leap_day}
  end

  @doc """
  Returns the epoch of the AstroHinduLunar calendar.
  """
  def epoch, do: Calixir.hindu_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AstroHinduLunar date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AstroHinduLunar date.
  """
  def from_fixed(fixed) do
    Calixir.astro_hindu_lunar_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding AstroHinduLunar date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `astro_hindu_lunar_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(astro_hindu_lunar_date, target_calendar) do
    astro_hindu_lunar_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `astro_hindu_lunar_date` into the corresponding `fixed` date.
  """
  def to_fixed(astro_hindu_lunar_date) do
    Calixir.fixed_from_astro_hindu_lunar(astro_hindu_lunar_date)
  end

  @doc """
  Converts `astro_hindu_lunar_date` into the corresponding Julian Day number.
  """
  def to_jd(astro_hindu_lunar_date) do
    astro_hindu_lunar_date |> to_fixed |> Calixir.jd_from_fixed
  end

end

