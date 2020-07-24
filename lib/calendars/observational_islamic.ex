defmodule Calendars.ObservationalIslamic do
  @moduledoc """
  Documentation for the ObservationalIslamic.
  DR4 293ff
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :observational_islamic

  @doc """
  Returns a ObservationalIslamic date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the ObservationalIslamic calendar.
  """
  def epoch, do: Calixir.islamic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding ObservationalIslamic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding ObservationalIslamic date.
  """
  def from_fixed(fixed) do
    Calixir.observational_islamic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding ObservationalIslamic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `observational_islamic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(observational_islamic_date, target_calendar) do
    observational_islamic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `observational_islamic_date` into the corresponding `fixed` date.
  """
  def to_fixed(observational_islamic_date) do
    Calixir.fixed_from_observational_islamic(observational_islamic_date)
  end

  @doc """
  Converts `observational_islamic_date` into the corresponding Julian Day number.
  """
  def to_jd(observational_islamic_date) do
    observational_islamic_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
