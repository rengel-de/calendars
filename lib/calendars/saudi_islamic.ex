defmodule Calendars.SaudiIslamic do
  @moduledoc """
  Documentation for the SaudiIslamic calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :saudi_islamic

  @doc """
  Returns a SaudiIslamic date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the SaudiIslamic calendar.
  """
  def epoch, do: Calixir.islamic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding SaudiIslamic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding SaudiIslamic date.
  """
  def from_fixed(fixed) do
    Calixir.saudi_islamic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding SaudiIslamic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `saudi_islamic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(saudi_islamic_date, target_calendar) do
    saudi_islamic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `saudi_islamic_date` into the corresponding `fixed` date.
  """
  def to_fixed(saudi_islamic_date) do
    Calixir.fixed_from_saudi_islamic(saudi_islamic_date)
  end

  @doc """
  Converts `saudi_islamic_date` into the corresponding Julian Day number.
  """
  def to_jd(saudi_islamic_date) do
    saudi_islamic_date |> to_fixed |> Calixir.jd_from_fixed
  end

end