defmodule Calendars.Egyptian do
  @moduledoc """
  Documentation for the Egyptian calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..13
  @typep day   :: 1..10
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :egyptian

  @doc """
  Returns a Egyptian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Egyptian calendar.
  """
  def epoch, do: Calixir.egyptian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Egyptian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Egyptian date.
  """
  def from_fixed(fixed) do
    Calixir.egyptian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Egyptian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `egyptian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(egyptian_date, target_calendar) do
    egyptian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `egyptian_date` into the corresponding `fixed` date.
  """
  def to_fixed(egyptian_date) do
    Calixir.fixed_from_egyptian(egyptian_date)
  end

  @doc """
  Converts `egyptian_date` into the corresponding Julian Day number.
  """
  def to_jd(egyptian_date) do
    egyptian_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
