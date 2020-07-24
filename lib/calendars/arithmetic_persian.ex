defmodule Calendars.ArithmeticPersian do
  @moduledoc """
  Documentation for the ArithmeticPersian calendar (DR4).
  """
  @typep year  :: neg_integer | pos_integer
  @typep month :: 1..12
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :arithmetic_persian

  @doc """
  Returns a ArithmeticPersian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the ArithmeticPersian calendar.
  """
  def epoch, do: Calixir.persian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding ArithmeticPersian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding ArithmeticPersian date.
  """
  def from_fixed(fixed) do
    Calixir.arithmetic_persian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding ArithmeticPersian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `arithmetic_persian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(arithmetic_persian_date, target_calendar) do
    arithmetic_persian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `arithmetic_persian_date` into the corresponding `fixed` date.
  """
  def to_fixed(arithmetic_persian_date) do
    Calixir.fixed_from_arithmetic_persian(arithmetic_persian_date)
  end

  @doc """
  Converts `arithmetic_persian_date` into the corresponding Julian Day number.
  """
  def to_jd(arithmetic_persian_date) do
    arithmetic_persian_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
