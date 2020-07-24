defmodule Calendars.Tibetan do
  @moduledoc """
  Documentation for the Tibetan calendar (DR4).
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
  def keyword, do: :tibetan

  @doc """
  Returns a Tibetan date from its parts.
  """
  def date(year, month, leap_month, day, leap_day) do
    {year, month, leap_month, day, leap_day}
  end

  @doc """
  Returns the epoch of the Tibetan calendar.
  """
  def epoch, do: Calixir.tibetan_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Tibetan date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Tibetan date.
  """
  def from_fixed(fixed) do
    Calixir.tibetan_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Tibetan date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `tibetan_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(tibetan_date, target_calendar) do
    tibetan_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `tibetan_date` into the corresponding `fixed` date.
  """
  def to_fixed(tibetan_date) do
    Calixir.fixed_from_tibetan(tibetan_date)
  end

  @doc """
  Converts `tibetan_date` into the corresponding Julian Day number.
  """
  def to_jd(tibetan_date) do
    tibetan_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Losar (Tibetan New Year).
  """
  defdelegate new_year(g_year), to: Calixir, as: :tibetan_new_year

end
