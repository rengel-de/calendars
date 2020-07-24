defmodule Calendars.Armenian do
  @moduledoc """
  Documentation for the Armenian calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..13
  @typep day   :: 1..10
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :armenian

  @doc """
  Returns a Armenian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Armenian calendar.
  """
  def epoch, do: Calixir.armenian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Armenian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Armenian date.
  """
  def from_fixed(fixed) do
    Calixir.armenian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Armenian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `armenian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(armenian_date, target_calendar) do
    armenian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `armenian_date` into the corresponding `fixed` date.
  """
  def to_fixed(armenian_date) do
    Calixir.fixed_from_armenian(armenian_date)
  end

  @doc """
  Converts `armenian_date` into the corresponding Julian Day number.
  """
  def to_jd(armenian_date) do
    armenian_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
