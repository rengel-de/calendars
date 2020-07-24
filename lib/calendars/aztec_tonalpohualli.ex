defmodule Calendars.AztecTonalpohualli do
  @moduledoc """
  Documentation for the AztecTonalpohualli calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep tonal_number :: 1..20
  @typep tonal_name   :: 1..13
  @type  t            :: {tonal_number, tonal_name}

 @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :aztec_tonalpohualli

  @doc """
  Returns a AztecTonalpohualli date from its parts.
  """
  def date(tonal_number, tonal_name), do: {tonal_number, tonal_name}

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding AztecTonalpohualli date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding AztecTonalpohualli date.
  """
  def from_fixed(fixed) do
    Calixir.aztec_tonalpohualli_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding AztecTonalpohualli date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

end
