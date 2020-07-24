defmodule Calendars.Hebrew do
  @moduledoc """
  Documentation for the Hebrew calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :hebrew

  @doc """
  Returns a Hebrew date from its parts.
  """
  def date(year, month, day) do
    {year, month, day}
  end

  @doc """
  Returns the epoch of the Hebrew calendar.
  """
  def epoch, do: Calixir.hebrew_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Hebrew date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Hebrew date.
  """
  def from_fixed(fixed) do
    Calixir.hebrew_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Hebrew date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `hebrew_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(hebrew_date, target_calendar) do
    hebrew_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `hebrew_date` into the corresponding `fixed` date.
  """
  def to_fixed(hebrew_date) do
    Calixir.fixed_from_hebrew(hebrew_date)
  end

  @doc """
  Converts `hebrew_date` into the corresponding Julian Day number.
  """
  def to_jd(hebrew_date) do
    hebrew_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Birkath Ha Hama.
  """
  defdelegate birkath_ha_hama(g_year), to: Calixir

  @doc """
  Birkath Ha Hama (Alt).
  """
  defdelegate alt_birkath_ha_hama(g_year), to: Calixir

  @doc """
  Hanukkah.
  """
  defdelegate hanukkah(g_year), to: Calixir

  @doc """
  Passover.
  """
  defdelegate passover(g_year), to: Calixir

  @doc """
  Purim.
  """
  defdelegate purim(g_year), to: Calixir

  @doc """
  Sh'ela.
  """
  defdelegate sh_ela(g_year), to: Calixir

  @doc """
  Ta'anit Esther.
  """
  defdelegate ta_anit_esther(g_year), to: Calixir

  @doc """
  Tisha be-Av.
  """
  defdelegate tishah_be_av(g_year), to: Calixir

  @doc """
  Yom ha Zikkaron.
  """
  defdelegate yom_ha_zikkaron(g_year), to: Calixir

  @doc """
  Yom Kippur.
  """
  defdelegate yom_kippur(g_year), to: Calixir

end