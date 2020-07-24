defmodule Calendars.MayanLongCount do
  @moduledoc """
  Documentation for the MayanLongCount calendar (DR4).
  """
  @typep baktun :: integer
  @typep katun  :: 0..19
  @type  tun    :: 0..17
  @typep uinal  :: 0..19
  @typep kin    :: 1..19
  @type  t      :: {baktun, katun, tun, uinal, kin}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :mayan_long_count

  @doc """
  Returns a MayanLongCount date from its parts.
  """
  def date(baktun, katun, tun, uinal, kin) do
    {baktun, katun, tun, uinal, kin}
  end

  @doc """
  Returns the epoch of the MayanLongCount calendar.
  """
  def epoch, do: Calixir.mayan_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding MayanLongCount date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding MayanLongCount date.
  """
  def from_fixed(fixed) do
    Calixir.mayan_long_count_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding MayanLongCount date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `mayan_long_count_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(mayan_long_count_date, target_calendar) do
    mayan_long_count_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `mayan_long_count_date` into the corresponding `fixed` date.
  """
  def to_fixed(mayan_long_count_date) do
    Calixir.fixed_from_mayan_long_count(mayan_long_count_date)
  end

  @doc """
  Converts `mayan_long_count_date` into the corresponding Julian Day number.
  """
  def to_jd(mayan_long_count_date) do
    mayan_long_count_date |> to_fixed |> Calixir.jd_from_fixed
  end

end
