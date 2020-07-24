defmodule Calendars.Ethiopic do
  @moduledoc """
  Documentation for the Ethiopic calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..13
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :ethiopic

  @doc """
  Returns a Ethiopic date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Ethiopic calendar.
  """
  def epoch, do: Calixir.ethiopic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Ethiopic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Ethiopic date.
  """
  def from_fixed(fixed) do
    Calixir.ethiopic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Ethiopic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `ethiopic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(ethiopic_date, target_calendar) do
    ethiopic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `ethiopic_date` into the corresponding `fixed` date.
  """
  def to_fixed(ethiopic_date) do
    Calixir.fixed_from_ethiopic(ethiopic_date)
  end

  @doc """
  Converts `ethiopic_date` into the corresponding Julian Day number.
  """
  def to_jd(ethiopic_date) do
    ethiopic_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
