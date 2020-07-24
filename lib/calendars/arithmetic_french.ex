defmodule Calendars.ArithmeticFrench do
  @moduledoc """
  Documentation for the ArithmeticFrench calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..13
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :arithmetic_french

  @doc """
  Returns a ArithmeticFrench date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the ArithmeticFrench calendar.
  """
  def epoch, do: Calixir.french_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding ArithmeticFrench date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding ArithmeticFrench date.
  """
  def from_fixed(fixed) do
    Calixir.arithmetic_french_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding ArithmeticFrench date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `arithmetic_french_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(arithmetic_french_date, target_calendar) do
    arithmetic_french_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `arithmetic_french_date` into the corresponding `fixed` date.
  """
  def to_fixed(arithmetic_french_date) do
    Calixir.fixed_from_arithmetic_french(arithmetic_french_date)
  end

  @doc """
  Converts `arithmetic_french_date` into the corresponding Julian Day number.
  """
  def to_jd(arithmetic_french_date) do
    arithmetic_french_date |> to_fixed |> Calixir.jd_from_fixed
  end

end