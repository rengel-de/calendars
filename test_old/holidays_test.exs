defmodule HolidaysTest do
  use ExUnit.Case

  @moduledoc """
  This module tests the holidays contained in DR4.
  (Holidays: DR4, pages 454 - 466)
  """

  alias Calixir.Holidays

  alias Calendars.{
    Bahai,
    BaliPawukon,
    Chinese,
    Coptic,
    Gregorian,
    Hebrew,
    HinduLunar,
    Icelandic,
    Islamic,
    Julian,
    LuniSolar,
    ObservationalHebrew,
    Persian,
    Tibetan,
    }

  test "Advent Sunday - DR4 70 (2.42)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:advent) do
      fixed = Gregorian.advent(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Baha'i New Year - DR4 277 (16.10)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:bahai_new_year) do
      fixed = Bahai.new_year(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Birkath Ha Hama - DR4 131 (8.38)" do
    for date <- Holidays.dates_of_holiday(:birkath_ha_hama) do
      case date do
        {year, 0, 0} ->
          assert Hebrew.birkath_ha_hama(year) == []
        {year, _, _} -> (
          fixed = Hebrew.birkath_ha_hama(year) |> hd
          assert Gregorian.from_fixed(fixed) == date)
      end
    end
  end

  test "Birkath Ha Hama - DR4 132 (8.40)" do
    for date <- Holidays.dates_of_holiday(:birkath_ha_hama) do
      case date do
        {year, 0, 0} ->
          assert Hebrew.alt_birkath_ha_hama(year) == []
        {year, _, _} ->
          fixed = Hebrew.alt_birkath_ha_hama(year) |> hd
          assert Gregorian.from_fixed(fixed) == date
      end
    end
  end

  test "Birth of the Bab - DR4 278 (16.30)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:birth_of_the_bab) do
      fixed = Bahai.birth_of_the_bab(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Birthday of Rama - DR4 369 (20.61)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:rama) do
      fixed = HinduLunar.rama(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Chinese New Year - DR4 322 (19.26)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:chinese_new_year) do
      fixed = Chinese.new_year(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Christmas - DR4 70 (2.41)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:christmas) do
      fixed = Gregorian.christmas(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Christmas (Coptic) - DR4 93 (4.9)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:coptic_christmas) do
      fixed = Coptic.christmas(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Christmas (Orthodox) - DR4 85 (3.25)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:eastern_orthodox_christmas) do
      fixed = Julian.eastern_orthodox_christmas(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Diwali - DR4 368 (20.57)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:diwali) do
      fixed = HinduLunar.diwali(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Dragon Festival - DR4 324 (19.27)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:dragon_festival) do
      fixed = Chinese.dragon_festival(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Easter - DR4 148 (9.3)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:easter) do
      fixed = Gregorian.easter(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Easter (Astronomical) - DR4 292 (18.9)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:astronomical_easter) do
      fixed = LuniSolar.easter(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Easter (Orthodox) - DR4 146 (9.1)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:orthodox_easter) do
      fixed = Julian.orthodox_easter(year)
      assert Gregorian.from_fixed(fixed) == date
      fixed1 = Julian.alt_orthodox_easter(year)
      assert Gregorian.from_fixed(fixed1) == date
    end
  end

  test "Epiphany - DR4 71 (2.43)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:epiphany) do
      fixed = Gregorian.epiphany(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Feast of Naw-Ruz - DR4 277 (16.11.)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:naw_ruz) do
      fixed = Bahai.naw_ruz(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Feast of Ridvan - DR4 277 (16.12)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:feast_of_ridvan) do
      fixed = Bahai.feast_of_ridvan(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Friday the 13th (first) - DR4 71 (2.45)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:unlucky_fridays) do
      fixed = Gregorian.unlucky_fridays(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Great Night of Shiva - DR4 369 (20.60)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:shiva) do
      fixed = HinduLunar.shiva(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Hanukkah - DR4 134 (8.43)" do
    for {year, _month, _} = date <- Holidays.dates_of_holiday(:hanukkah) do
      fixed = Hebrew.hanukkah(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Hindu Lunar New Year - DR4 365 (20.53)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:hindu_lunar_new_year) do
      fixed = HinduLunar.hindu_lunar_new_year(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Icelandic Summer - DR4 100 (6.2)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:icelandic_summer) do
      fixed = Icelandic.icelandic_summer(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Icelandic Winter - DR4 100 (6.3)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:icelandic_winter) do
      fixed = Icelandic.icelandic_winter(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Kajeng Keliwon (first) - DR4 190 (12.16)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:kajeng_keliwon) do
      fixed = BaliPawukon.kajeng_keliwon(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Losar (Tibetan New Year) - DR4 381 (21.9)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:tibetan_new_year) do
      fixed = Tibetan.new_year(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Mawlid - DR4 109 (7.6)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:mawlid) do
      fixed = Islamic.mawlid(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Mesha Samkranti - DR4 364 (20.51)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:mesha_samkranti) do
      fixed = HinduLunar.mesha_samkranti(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Nowruz - DR4 265 (15.11)" do
    for {year, _, _} = date <- Holidays.dates_of_holiday(:nowruz) do
      fixed = Persian.nowruz(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Observ. Hebrew 1 Nisan - DR4 297 (18.22)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:observational_hebrew_first_of_nisan) do
      fixed = ObservationalHebrew.first_of_nisan(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Passover - DR4 129 (8.31)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:passover) do
      fixed = Hebrew.passover(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Passover Eve (Classical) - DR4 298 (18.25)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:classical_passover_eve) do
      fixed = ObservationalHebrew.classical_passover_eve(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Pentecost - DR4 152 (9.4)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:pentecost) do
      fixed = Gregorian.pentecost(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Purim - DR4 129 (8.33)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:purim) do
      fixed = Hebrew.purim(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Qingming - DR4 324 (19.28)" do  # passed
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:qing_ming) do
      fixed = Chinese.qing_ming(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Sacred Wednesday (first) - DR4 370 (20.65)" do
    for date <- Holidays.dates_of_holiday(:sacred_wednesdays) do
      case date do
        {year, 0, 0} ->
          assert HinduLunar.sacred_wednesdays(year) == []
        {year, _, _} -> (
          fixed = HinduLunar.sacred_wednesdays(year) |> hd
          assert Gregorian.from_fixed(fixed) == date)
      end
    end
  end

  test "Sh'ela - DR4 131 (8.37)" do
    for {year, _month, _} = date <- Holidays.dates_of_holiday(:sh_ela) do
      fixed = Hebrew.sh_ela(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Ta'anit Esther - DR4 130 (8.34)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:ta_anit_esther) do
      fixed = Hebrew.ta_anit_esther(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Tishah be-Av - DR4 130 (8.35)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:tishah_be_av) do
      fixed = Hebrew.tishah_be_av(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Tumpek (first) - DR4 190 (12.17)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:tumpek) do
      fixed = BaliPawukon.tumpek(year) |> hd
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Daylight Saving End - DR4 70 (2.40)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:daylight_saving_end) do
      fixed = Gregorian.daylight_saving_end(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Daylight Saving Start - DR4 70 (2.39)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:daylight_saving_start) do
      fixed = Gregorian.daylight_saving_start(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Election Day - DR4 70 (2.38)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:election_day) do
      fixed = Gregorian.election_day(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Independence - DR4 69 (2.32)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:independence_day) do
      fixed = Gregorian.independence_day(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Labor Day - DR4 69 (2.36.)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:labor_day) do
      fixed = Gregorian.labor_day(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "U.S. Memorial Day - DR4 70 (2.37)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:memorial_day) do
      fixed = Gregorian.memorial_day(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Yom ha Zikkaron - DR4 131 (8.36)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:yom_ha_zikkaron) do
      fixed = Hebrew.yom_ha_zikkaron(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

  test "Yom Kippur - DR4 128 (8.30)" do
    for {year, _month, _day } = date <- Holidays.dates_of_holiday(:yom_kippur) do
      fixed = Hebrew.yom_kippur(year)
      assert Gregorian.from_fixed(fixed) == date
    end
  end

end
