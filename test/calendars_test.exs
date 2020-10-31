defmodule CalendarsTest do
  use ExUnit.Case

  @moduledoc """
  This module tests the `from_fixed`, `from_date`, and `from_jd`
  functions against the sample dates contained in DR4.
  (Sample dates: DR4, pages 447 - 453)
  """

  alias Calixir.SampleDates, as: Data

  @fixed_dates :jd |> Data.fixed_with |> Enum.map(&(elem(&1, 0)))
  @jd_dates    :jd |> Data.fixed_with |> Enum.map(&(elem(&1, 1)))
  @g_dates     :gregorian |> Data.fixed_with |> Enum.map(&(elem(&1, 1)))

  @monotonic_calendars [
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

  test "monotonic Calendars" do
    for calendar <- @monotonic_calendars do
      keyword = calendar.keyword()
      keyword = keyword == :rata_die && :fixed || keyword
      dates = get_dates(calendar.field_count, keyword)
      test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
      for {fixed, date, jd, gregorian} <- test_dates do
        assert calendar.from_date(gregorian, Gregorian) == date
        assert calendar.from_fixed(fixed) == date
        if calendar != JD do
          assert calendar.from_jd(jd) == date
        end
      end
    end
  end

  test "Cyclical Calendars without Weekday" do
    for calendar <- @cyclical_calendars do
      keyword = calendar.keyword()
      # An ugly hack, because of inconsistent naming in DR4
      keyword = if keyword == :akan_day_name, do: :akan_name, else: keyword
      dates = get_dates(calendar.field_count, keyword)
      test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
      for {fixed, date, jd, gregorian} <- test_dates do
        assert calendar.from_date(gregorian, Gregorian) == date
        assert calendar.from_fixed(fixed) == date
        assert calendar.from_jd(jd) == date
      end
    end
  end

  test "Weekday" do
    days = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
    dates = get_dates(Weekday.field_count, :weekday)
    test_dates = Enum.zip([@fixed_dates, dates, @jd_dates, @g_dates])
    for {fixed, date, jd, gregorian} <- test_dates do
      date = elem(date, 0)
      assert Enum.at(days, elem(Weekday.from_date(gregorian, Gregorian), 0)) == date
      assert Enum.at(days, elem(Weekday.from_fixed(fixed), 0)) == date
      assert Enum.at(days, elem(Weekday.from_jd(jd), 0)) == date
    end
  end

  defp get_dates(1, keyword), do: Data.fixed_with(keyword) |> Enum.map(&({elem(&1, 1)}))
  defp get_dates(_, keyword), do: Data.fixed_with(keyword) |> Enum.map(&(elem(&1, 1)))

end