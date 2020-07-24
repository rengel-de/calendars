defmodule CalendarsTest do
  use ExUnit.Case

  @moduledoc """
  This module tests the `from_fixed`, `from_date`, and `from_jd`
  functions against the sample dates contained in DR4.
  (Sample dates: DR4, pages 447 - 453)
  """

  alias Calixir.SampleDates, as: Data

  alias Calendars.{
    AkanDayName,
    ArithmeticFrench,
    ArithmeticPersian,
    Armenian,
    AstroHinduLunar,
    AstroHinduSolar,
    AztecTonalpohualli,
    AztecXihuitl,
    Babylonian,
    Bahai,
    BaliPawukon,
    Chinese,
    Coptic,
    DayOfWeek,
    Egyptian,
    Ethiopic,
    French,
    Gregorian,
    Hebrew,
    HinduLunar,
    HinduSolar,
    Icelandic,
    Islamic,
    ISO,
    JD,
    Julian,
    MayanHaab,
    MayanLongCount,
    MayanTzolkin,
    MJD,
    ObservationalHebrew,
    ObservationalIslamic,
    OldHinduLunar,
    OldHinduSolar,
    Olympiad,
    Persian,
    RataDie,
    Roman,
    Samaritan,
    SaudiIslamic,
    Tibetan,
    Unix
  }

  @fixed_dates :jd |> Data.fixed_with |> Enum.map(&(elem(&1, 0)))
  @jd_dates    :jd |> Data.fixed_with |> Enum.map(&(elem(&1, 1)))
  @g_dates     :gregorian |> Data.fixed_with |> Enum.map(&(elem(&1, 1)))

  @monotonous_calendars [
    ArithmeticFrench,
    ArithmeticPersian,
    Armenian,
    AstroHinduLunar,
    AstroHinduSolar,
    Babylonian,
    Bahai,
    Chinese,
    Coptic,
    Egyptian,
    Ethiopic,
    French,
    Gregorian,
    Hebrew,
    HinduLunar,
    HinduSolar,
    Icelandic,
    Islamic,
    ISO,
    JD,
    Julian,
    MayanLongCount,
    MJD,
    ObservationalHebrew,
    ObservationalIslamic,
    OldHinduLunar,
    OldHinduSolar,
    Persian,
    RataDie,
    Roman,
    Samaritan,
    SaudiIslamic,
    Tibetan,
    Unix
  ]

  @cyclical_calendars [
    AkanDayName,
    AztecTonalpohualli,
    AztecXihuitl,
    # AztecXiuhmolpilli,  # No DR4 SampleData!
    BaliPawukon,
    MayanHaab,
    MayanTzolkin,
    Olympiad
  ]

  test "Monotonous Calendars" do
    for calendar <- @monotonous_calendars do
      keyword = calendar.keyword()
      dates = Data.fixed_with(keyword) |> Enum.map(&(elem(&1, 1)))
      test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
      for {fixed, date, jd, gregorian} <- test_dates do
        assert calendar.from_date(gregorian, Gregorian) == date
        assert calendar.from_fixed(fixed) == date
        assert calendar.from_jd(jd) == date
      end
    end
  end

  test "Cyclical Calendars without DayOfWeek" do
    for calendar <- @cyclical_calendars do
      keyword = calendar.keyword()
      dates = Data.fixed_with(keyword) |> Enum.map(&(elem(&1, 1)))
      test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
      for {fixed, date, jd, gregorian} <- test_dates do
        assert calendar.from_date(gregorian, Gregorian) == date
        assert calendar.from_fixed(fixed) == date
        assert calendar.from_jd(jd) == date
      end
    end
  end

  test "DayOfWeek" do
    days = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
    dates = Data.fixed_with(:weekday) |> Enum.map(&(elem(&1, 1)))
    test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
    for {fixed, date, jd, gregorian} <- test_dates do
      assert Enum.at(days, DayOfWeek.from_date(gregorian, Gregorian)) == date
      assert Enum.at(days, DayOfWeek.from_fixed(fixed)) == date
      assert Enum.at(days, DayOfWeek.from_jd(jd)) == date
    end
  end

end