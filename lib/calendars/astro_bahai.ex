defmodule Calendars.AstroBahai do
  @moduledoc """
  Documentation for the AstroBahai calendar (DR4).
  """
  @typep major :: integer
  @typep cycle :: 1..19
  @typep year  :: 1..19
  @typep month :: 0..19
  @typep day   :: 1..19
  @type  t     :: {major, cycle, year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :astro_bahai

  @doc """
  Returns a AstroBahai date from its parts.
  """
  def date(major, cycle, year, month, day) do
    {major, cycle, year, month, day}
  end

  @doc """
  Returns the epoch of the AstroBahai calendar.
  """
  def epoch, do: Calixir.bahai_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AstroBahai date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AstroBahai date.
  """
  def from_fixed(fixed) do
    Calixir.astro_bahai_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding AstroBahai date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `astro_bahai_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(astro_bahai_date, target_calendar) do
    astro_bahai_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `astro_bahai_date` into the corresponding `fixed` date.
  """
  def to_fixed(astro_bahai_date) do
    Calixir.fixed_from_astro_bahai(astro_bahai_date)
  end

  @doc """
  Converts `astro_bahai_date` into the corresponding Julian Day number.
  """
  def to_jd(astro_bahai_date) do
    astro_bahai_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
