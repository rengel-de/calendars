defmodule Calendars.ObservationalHebrew do
  @moduledoc """
  Documentation for the ObservationalHebrew calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :observational_hebrew

  @doc """
  Returns a ObservationalHebrew date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the ObservationalHebrew calendar.
  """
  def epoch, do: Calixir.hebrew_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding ObservationalHebrew date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding ObservationalHebrew date.
  """
  def from_fixed(fixed) do
    Calixir.observational_hebrew_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding ObservationalHebrew date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `observational_hebrew_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(observational_hebrew_date, target_calendar) do
    observational_hebrew_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `observational_hebrew_date` into the corresponding `fixed` date.
  """
  def to_fixed(observational_hebrew_date) do
    Calixir.fixed_from_observational_hebrew(observational_hebrew_date)
  end

  @doc """
  Converts `observational_hebrew_date` into the corresponding Julian Day number.
  """
  def to_jd(observational_hebrew_date) do
    observational_hebrew_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Observ. Hebrew 1 Nisan.
  """
  defdelegate first_of_nisan(g_year), to: Calixir, as: :observational_hebrew_first_of_nisan

  @doc """
  Passover Eve (Classical).
  """
  defdelegate classical_passover_eve(g_year), to: Calixir

end