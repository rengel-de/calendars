defmodule Calendars.Hebrew do
  @moduledoc """
  Documentation for the Hebrew calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..30
  @type  t     :: {year, month, day}

  # Source: http://www.yashanet.com/library/hebrew-days-and-months.html
  @months [
    "Nisan",
    "Iyyar",
    "Sivan",
    "Tammuz",
    "Av",
    "Elul",
    "Tishri",
    "Kheshvan",
    "Kislev",
    "Tevet",
    "Shevat",
    "Adar",
    "Adar II"]

  # Source: http://www.israelhebrew.com/days-of-the-week-in-hebrew/
  @weekdays [
    "Yom Rishon", "Yom Sheni", "Yom Shlishi", "Yom Rvi-ee",
    "Yom Chamishi", "Yom Shishi", "Shabbat"]

  # Source: http://www.yashanet.com/library/hebrew-days-and-months.html
  @weekdays_alt [
    "Yom Reeshone", "Yom Shaynee", "Yom Shlee´shee", "Yom Revee´ee",
    "Yom Khah´mee´shee", "Yom Shee´shee", "Shabbat"]

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
  def birkath_ha_hama(g_year, _,  _), do: birkath_ha_hama(g_year)
  defdelegate birkath_ha_hama(g_year), to: Calixir

  @doc """
  Birkath Ha Hama (Alt).
  """
  def alt_birkath_ha_hama(g_year, _,  _), do: alt_birkath_ha_hama(g_year)
  defdelegate alt_birkath_ha_hama(g_year), to: Calixir

  @doc """
  Hanukkah.
  """
  def hanukkah(g_year, _,  _), do: hanukkah(g_year)
  defdelegate hanukkah(g_year), to: Calixir

  @doc """
  Passover.
  """
  def passover(g_year, _,  _), do: passover(g_year)
  defdelegate passover(g_year), to: Calixir

  @doc """
  Purim.
  """
  def purim(g_year, _,  _), do: purim(g_year)
  defdelegate purim(g_year), to: Calixir

  @doc """
  Sh'ela.
  """
  def sh_ela(g_year, _,  _), do: sh_ela(g_year)
  defdelegate sh_ela(g_year), to: Calixir

  @doc """
  Ta'anit Esther.
  """
  def ta_anit_esther(g_year, _,  _), do: ta_anit_esther(g_year)
  defdelegate ta_anit_esther(g_year), to: Calixir

  @doc """
  Tisha be-Av.
  """
  def tishah_be_av(g_year, _,  _), do: tishah_be_av(g_year)
  defdelegate tishah_be_av(g_year), to: Calixir

  @doc """
  Yom ha Zikkaron.
  """
  def yom_ha_zikkaron(g_year, _,  _), do: yom_ha_zikkaron(g_year)
  defdelegate yom_ha_zikkaron(g_year), to: Calixir

  @doc """
  Yom Kippur.
  """
  def yom_kippur(g_year, _,  _), do: yom_kippur(g_year)
  defdelegate yom_kippur(g_year), to: Calixir

  @doc """
  Returns the names of the Hebrew months as list.
  """
  def month_names_as_list(), do: @months

  @doc """
  Returns the names of the Hebrew weekdays as list.
  """
  def day_names_as_list(), do: @weekdays

  @doc """
  Returns the given `fixed` date or Hebrew `h_date` as text.
  """
  def date_text(fixed) when is_number(fixed) do
    fixed |> from_fixed |> date_text
  end

  def date_text({year, month, day} = h_date) do
    day_of_week = h_date |> to_fixed |> Calendars.DayOfWeek.from_fixed
    weekday_name = Enum.at(@weekdays, day_of_week)
    month_name = Enum.at(@months, month - 1)
    "#{weekday_name}, #{month_name} #{day}, #{year}"
  end

end