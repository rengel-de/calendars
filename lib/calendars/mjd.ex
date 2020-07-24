defmodule Calendars.MJD do
  @moduledoc """
  Documentation for the MJD calnedar,
  the Modified Julian Day Number (MJD).
  """
  @typep mjd :: integer
  @type  t   :: mjd

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :mjd

  @doc """
  Returns a MJD date from its parts.
  """
  def date(mjd), do: mjd

  @doc """
  Returns the epoch of the MJD calendar.
  """
  def epoch, do: Calixir.mjd_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding MJD date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding MJD date.
  """
  def from_fixed(fixed) do
    Calixir.mjd_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding MJD date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `mjd_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(mjd_date, target_calendar) do
    mjd_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `mjd_date` into the corresponding `fixed` date.
  """
  def to_fixed(mjd_date) do
    Calixir.fixed_from_mjd(mjd_date)
  end

  @doc """
  Converts `mjd_date` into the corresponding Julian Day number.
  """
  def to_jd(mjd_date) do
    mjd_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
