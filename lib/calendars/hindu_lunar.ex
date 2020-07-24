defmodule Calendars.HinduLunar do
  @moduledoc """
  Documentation for the HinduLunar calendar (DR4).
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
  def keyword, do: :hindu_lunar

  @doc """
  Returns a HinduLunar date from its parts.
  """
  def date(year, month, leap_month, day, leap_day) do
    {year, month, leap_month, day, leap_day}
  end

  @doc """
  Returns the epoch of the HinduLunar calendar.
  """
  def epoch, do: Calixir.hindu_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding HinduLunar date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding HinduLunar date.
  """
  def from_fixed(fixed) do
    Calixir.hindu_lunar_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding HinduLunar date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `hindu_lunar_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(hindu_lunar_date, target_calendar) do
    hindu_lunar_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `hindu_lunar_date` into the corresponding `fixed` date.
  """
  def to_fixed(hindu_lunar_date) do
    Calixir.fixed_from_hindu_lunar(hindu_lunar_date)
  end

  @doc """
  Converts `hindu_lunar_date` into the corresponding Julian Day number.
  """
  def to_jd(hindu_lunar_date) do
    hindu_lunar_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Birthday of Rama.
  """
  defdelegate rama(g_year), to: Calixir

  @doc """
  Diwali.
  """
  defdelegate diwali(g_year), to: Calixir

  @doc """
  Great Night of Shiva.
  """
  defdelegate shiva(g_year), to: Calixir

  @doc """
  Hindu Lunar New Year.
  """
  defdelegate hindu_lunar_new_year(g_year), to: Calixir

  @doc """
  Mesha Samkranti.
  """
  defdelegate mesha_samkranti(g_year), to: Calixir

  @doc """
  Sacred Wednesday (first).
  """
  defdelegate sacred_wednesdays(g_year), to: Calixir

end

