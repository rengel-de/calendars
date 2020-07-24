defmodule Calendars.OldHinduSolar do
  @moduledoc """
  Documentation for the OldHinduSolar calendar (DR4).
  """
  @typep year       :: integer
  @typep month      :: 1..12
  @typep day        :: 1..30
  @type  t          :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :old_hindu_solar

  @doc """
  Returns a OldHinduSolar date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the OldHinduSolar calendar.
  """
  def epoch, do: Calixir.hindu_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding OldHinduSolar date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding OldHinduSolar date.
  """
  def from_fixed(fixed) do
    Calixir.old_hindu_solar_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding OldHinduSolar date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `old_hindu_solar_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(old_hindu_solar_date, target_calendar) do
    old_hindu_solar_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `old_hindu_solar_date` into the corresponding `fixed` date.
  """
  def to_fixed(old_hindu_solar_date) do
    Calixir.fixed_from_old_hindu_solar(old_hindu_solar_date)
  end

  @doc """
  Converts `old_hindu_solar_date` into the corresponding Julian Day number.
  """
  def to_jd(old_hindu_solar_date) do
    old_hindu_solar_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
