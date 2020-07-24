defmodule Calendars.JD do
  @moduledoc """
  Documentation for the JD calendar (DR4).
  """
  @typep jd :: number
  @type  t  :: jd

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :jd

  @doc """
  Returns a JD date from its parts.
  """
  def date(jd), do: jd

  @doc """
  Returns the epoch of the JD calendar.
  """
  def epoch, do: Calixir.jd_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding JD date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding JD date.
  """
  def from_fixed(fixed) do
    Calixir.jd_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding JD date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `jd_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(jd_date, target_calendar) do
    jd_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `jd_date` into the corresponding `fixed` date.
  """
  def to_fixed(jd_date) do
    Calixir.fixed_from_jd(jd_date)
  end

  @doc """
  Converts `jd_date` into the corresponding Julian Day number.
  """
  def to_jd(jd_date) do
    jd_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
