defmodule Calendars.ISO do
  @moduledoc """
  Documentation for the ISO calendar (DR4).
  """
  @typep year :: integer
  @typep week :: 1..53
  @typep day  :: 1..7
  @type  t    :: {year, week, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :iso

  @doc """
  Returns a ISO date from its parts.
  """
  def date(year, week, day), do: {year, week, day}

  @doc """
  Returns the epoch of the ISO calendar.
  """
  def epoch, do: Calixir.gregorian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding ISO date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding ISO date.
  """
  def from_fixed(fixed) do
    Calixir.iso_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding ISO date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `iso_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(iso_date, target_calendar) do
    iso_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `iso_date` into the corresponding `fixed` date.
  """
  def to_fixed(iso_date) do
    Calixir.fixed_from_iso(iso_date)
  end

  @doc """
  Converts `iso_date` into the corresponding Julian Day number.
  """
  def to_jd(iso_date) do
    iso_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
