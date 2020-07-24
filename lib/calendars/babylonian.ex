defmodule Calendars.Babylonian do
  @moduledoc """
  Documentation for the Babylonian calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep leap  :: boolean
  @typep day   :: 1..30
  @type  t     :: {year, month, leap, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :babylonian

  @doc """
  Returns a Babylonian date from its parts.
  """
  def date(year, month, leap, day) do
    {year, month, leap, day}
  end

  @doc """
  Returns the epoch of the Babylonian calendar.
  """
  def epoch, do: Calixir.babylonian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Babylonian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Babylonian date.
  """
  def from_fixed(fixed) do
    Calixir.babylonian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Babylonian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `babylonian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(babylonian_date, target_calendar) do
    babylonian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `babylonian_date` into the corresponding `fixed` date.
  """
  def to_fixed(babylonian_date) do
    Calixir.fixed_from_babylonian(babylonian_date)
  end

  @doc """
  Converts `babylonian_date` into the corresponding Julian Day number.
  """
  def to_jd(babylonian_date) do
    babylonian_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
