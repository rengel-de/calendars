defmodule Calendars.RataDie do
  @moduledoc """
  Documentation for the RataDie calendar (DR4).

  This calendar is based on `fixed` dates. Its implementation
  is trivial. The central functions `date`, `from_fixed` and
  `to_fixed` are simply identity functions.
  (DR4 10ff)
  """
  @typep rd :: number
  @type  t  :: rd

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :fixed

  @doc """
  Returns a RataDie date from its parts.
  """
  def date(rd), do: rd

  @doc """
  Returns the epoch of the RataDie calendar.
  """
  def epoch, do: Calixir.gregorian_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding RataDie date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding RataDie date.
  (This is an identity function given just for completeness.)
  """
  def from_fixed(fixed), do: fixed

  @doc """
  Converts the Julian Day number `jd` into the corresponding RataDie date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd
  end

  @doc """
  Converts `jd_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(jd_date, target_calendar) do
    jd_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `rd_date` into the corresponding `fixed` date.
  (This is an identity function given just for completeness.)
  """
  def to_fixed(rd_date), do: rd_date

  @doc """
  Converts `rd_date` into the corresponding Julian Day number.
  """
  def to_jd(rd_date) do
    rd_date |> Calixir.jd_from_fixed
  end

end
