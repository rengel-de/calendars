defmodule Calendars.Icelandic do
  @moduledoc """
  Documentation for the Icelandic calendar (DR4).
  """
  @typep year    :: integer
  @typep season  :: 0..360
  @typep week    :: 1..27
  @typep weekday :: 0|1|2|3|4|5|6
  @type  t       :: {year, season, week, weekday}

  # @typep month :: 1..6   # unsued type, for doc only

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :icelandic

  @doc """
  Returns a Icelandic date from its parts.
  """
  def date(year, season, week, weekday) do
    {year, season, week, weekday}
  end

  @doc """
  Returns the epoch of the Icelandic calendar.
  """
  def epoch, do: Calixir.icelandic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Icelandic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Icelandic date.
  """
  def from_fixed(fixed) do
    Calixir.icelandic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Icelandic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `icelandic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(icelandic_date, target_calendar) do
    icelandic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `icelandic_date` into the corresponding `fixed` date.
  """
  def to_fixed(icelandic_date) do
    Calixir.fixed_from_icelandic(icelandic_date)
  end

  @doc """
  Converts `icelandic_date` into the corresponding Julian Day number.
  """
  def to_jd(icelandic_date) do
    icelandic_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Icelandic Summer.
  """
  defdelegate icelandic_summer(g_year), to: Calixir

  @doc """
  Icelandic Winter.
  """
  defdelegate icelandic_winter(g_year), to: Calixir

end
