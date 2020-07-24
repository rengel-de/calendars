defmodule Calendars.Unix do
  @moduledoc """
  Documentation for the Unix calendar (DR4).
  """
  @typep unix :: number
  @type  t    :: unix

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :unix

  @doc """
  Returns a Unix date from its parts.
  """
  def date(unix), do: unix

  @doc """
  Returns the epoch of the Unix calendar.
  """
  def epoch, do: Calixir.unix_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Unix date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Unix date.
  """
  def from_fixed(fixed) do
    Calixir.unix_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Unix date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `unix_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(unix_date, target_calendar) do
    unix_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `unix_date` into the corresponding `fixed` date.
  """
  def to_fixed(unix_date) do
    Calixir.fixed_from_unix(unix_date)
  end

  @doc """
  Converts `unix_date` into the corresponding Julian Day number.
  """
  def to_jd(unix_date) do
    unix_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
