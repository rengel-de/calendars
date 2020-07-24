defmodule Calendars.Coptic do
  @moduledoc """
  Documentation for the Coptic calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..13
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :coptic

  @doc """
  Returns a Coptic date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Coptic calendar.
  """
  def epoch, do: Calixir.coptic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Coptic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Coptic date.
  """
  def from_fixed(fixed) do
    Calixir.coptic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Coptic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `coptic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(coptic_date, target_calendar) do
    coptic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `coptic_date` into the corresponding `fixed` date.
  """
  def to_fixed(coptic_date) do
    Calixir.fixed_from_coptic(coptic_date)
  end

  @doc """
  Converts `coptic_date` into the corresponding Julian Day number.
  """
  def to_jd(coptic_date) do
    coptic_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Christmas (Coptic).
  """
  defdelegate christmas(g_year), to: Calixir, as: :coptic_christmas

end
