defmodule Calendars.AztecXiuhmolpilli do
  @moduledoc """
  Documentation for the AztecXiuhmolpilli calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep xiuhmol_number :: 1..13
  @typep xiuhmol_name   :: 1|8|13|18
  @type  t              :: {xiuhmol_number, xiuhmol_name}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :aztec_xiuhmolpilli

  @doc """
  Returns a AztecXiuhmolpilli date from its parts.
  """
  def date(xiuhmol_number, xiuhmol_name), do: {xiuhmol_number, xiuhmol_name}

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AztecXiuhmolpilli date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AztecXiuhmolpilli date.
  """
  def from_fixed(fixed) do
    Calixir.aztec_xiuhmolpilli_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding AztecXiuhmolpilli date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
