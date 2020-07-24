defmodule Calendars.AztecXihuitl do
  @moduledoc """
  Documentation for the AxtecXihuitl calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep month :: 1..19
  @typep day   :: 1..20
  @type  t     :: {month, day}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :aztec_xihuitl

  @doc """
  Returns a AxtecXihuitl date from its parts.
  """
  def date(month, day), do: {month, day}

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AxtecXihuitl date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AxtecXihuitl date.
  """
  def from_fixed(fixed), do: Calixir.aztec_xihuitl_from_fixed(fixed)

  @doc """
  Converts the Julian Day number `jd` into the corresponding AxtecXihuitl date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end

