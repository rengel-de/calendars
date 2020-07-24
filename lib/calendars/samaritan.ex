defmodule Calendars.Samaritan do
  @moduledoc """
  Documentation for the Samaritan calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :samaritan

  @doc """
  Returns a Samaritan date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the Samaritan calendar.
  """
  def epoch, do: Calixir.samaritan_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Samaritan date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Samaritan date.
  """
  def from_fixed(fixed) do
    Calixir.samaritan_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Samaritan date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `samaritan_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(samaritan_date, target_calendar) do
    samaritan_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `samaritan_date` into the corresponding `fixed` date.
  """
  def to_fixed(samaritan_date) do
    Calixir.fixed_from_samaritan(samaritan_date)
  end

  @doc """
  Converts `samaritan_date` into the corresponding Julian Day number.
  """
  def to_jd(samaritan_date) do
    samaritan_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
