defmodule Calendars.Islamic do
  @moduledoc """
  Documentation for the Islamic calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :islamic

  @doc """
  Returns a Islamic date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Islamic calendar.
  """
  def epoch, do: Calixir.islamic_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Islamic date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Islamic date.
  """
  def from_fixed(fixed) do
    Calixir.islamic_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Islamic date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `islamic_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(islamic_date, target_calendar) do
    islamic_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `islamic_date` into the corresponding `fixed` date.
  """
  def to_fixed(islamic_date) do
    Calixir.fixed_from_islamic(islamic_date)
  end

  @doc """
  Converts `islamic_date` into the corresponding Julian Day number.
  """
  def to_jd(islamic_date) do
    islamic_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Mawlid.
  """
  defdelegate mawlid(g_year), to: Calixir

end
