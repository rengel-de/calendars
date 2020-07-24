defmodule Calendars.Persian do
  @moduledoc """
  Documentation for the Persian calendar (DR4).
  """
  @typep year  :: neg_integer | pos_integer
  @typep month :: 1..12
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :persian

  @doc """
  Returns a Persian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Persian calendar.
  """
  def epoch, do: Calixir.persian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Persian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Persian date.
  """
  def from_fixed(fixed) do
    Calixir.persian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Persian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `persian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(persian_date, target_calendar) do
    persian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `persian_date` into the corresponding `fixed` date.
  """
  def to_fixed(persian_date) do
    Calixir.fixed_from_persian(persian_date)
  end

  @doc """
  Converts `persian_date` into the corresponding Julian Day number.
  """
  def to_jd(persian_date) do
    persian_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Nowruz.
  """
  defdelegate nowruz(g_year), to: Calixir

end
