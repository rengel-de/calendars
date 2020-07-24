defmodule ConversionTest do
  use ExUnit.Case

  @moduledoc """
  This module contains a brute-force conversion test.
  The test converts all the sample dates of each of the
  monotonus calenders and into each other.
  (Sample dates: DR4, pages 447 - 453)
  Be careful: This can take up to 30 minutes.
  """

  alias Calixir.SampleDates, as: Data

  alias Calendars.{
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
    }

  @fixed_dates :jd |> Data.fixed_with |> Enum.map(&(elem(&1, 0)))

  @monotonous_calendars [ # 34 monotonous calendars
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

  @tag timeout: :infinity

  test "brute force conversion test" do

    # 34 x 34 x 33 x 2 = 76296 conversion tests

    for fixed <- @fixed_dates do  # 33 fixed_dates

      IO.puts(fixed)

      for cal1 <- @monotonous_calendars, cal2 <- @monotonous_calendars do
        date1 = cal1.from_fixed(fixed) # |> IO.inspect(label: "date1")
        date2 = cal2.from_fixed(fixed) # |> IO.inspect(label: "date2")

        assert cal1.to_date(date1, cal2) == date2
        assert cal1.from_date(date2, cal2) == date1

      end

    end

  end

end