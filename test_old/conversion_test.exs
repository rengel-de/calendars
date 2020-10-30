defmodule ConversionTest do
  use ExUnit.Case

  @moduledoc """
  This module tests the pipelining of date conversions with the functions
  `from_date` and `to_date` as well as the relations

  ```
  assert date == date |> <calendar>.to_fixed |> <calendar>.from_fixed
  assert date == date |> <calendar>.to_jd |> <calendar>.from_jd
  ```

  for each monotonic calendar against the sample dates contained in DR4.

  To watch some or all intermediate results of the pipelines,
  remove the comment characters of the calendar(s) in question.
  You can track all the dates using the Sample Data in DR4, pp 447 - 453.
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

  test "to_date, pipeline with intermediate values" do

    for fixed <- @fixed_dates do

      assert (
               fixed
                 # |> IO.inspect(label: "fixed               ")
               |> ArithmeticFrench.from_fixed()
                 # |> IO.inspect(label: "ArithmeticFrench    ")
               |> ArithmeticFrench.to_date(ArithmeticPersian)
                 # |> IO.inspect(label: "ArithmeticPersian   ")
               |> ArithmeticPersian.to_date(Armenian)
                 # |> IO.inspect(label: "Armenian            ")
               |> Armenian.to_date(AstroHinduLunar)
                 # |> IO.inspect(label: "AstroHinduLunar     ")
               |> AstroHinduLunar.to_date(AstroHinduSolar)
                 # |> IO.inspect(label: "AstroHinduSolar     ")
               |> AstroHinduSolar.to_date(Babylonian)
                 # |> IO.inspect(label: "Babylonian          ")
               |> Babylonian.to_date(Bahai)
                 # |> IO.inspect(label: "Bahai               ")
               |> Bahai.to_date(Chinese)
                 # |> IO.inspect(label: "Chinese             ")
               |> Chinese.to_date(Coptic)
                 # |> IO.inspect(label: "Coptic              ")
               |> Coptic.to_date(Egyptian)
                 # |> IO.inspect(label: "Egyptian            ")
               |> Egyptian.to_date(Ethiopic)
                 # |> IO.inspect(label: "Ethiopic            ")
               |> Ethiopic.to_date(French)
                 # |> IO.inspect(label: "French              ")
               |> French.to_date(Gregorian)
                 # |> IO.inspect(label: "Gregorian           ")
               |> Gregorian.to_date(Hebrew)
                 # |> IO.inspect(label: "Hebrew              ")
               |> Hebrew.to_date(HinduLunar)
                 # |> IO.inspect(label: "HinduLunar          ")
               |> HinduLunar.to_date(HinduSolar)
                 # |> IO.inspect(label: "HinduSolar          ")
               |> HinduSolar.to_date(Icelandic)
                 # |> IO.inspect(label: "Icelandic           ")
               |> Icelandic.to_date(Islamic)
                 # |> IO.inspect(label: "Islamic             ")
               |> Islamic.to_date(ISO)
                 # |> IO.inspect(label: "ISO                 ")
               |> ISO.to_date(JD)
                 # |> IO.inspect(label: "JD                  ")
               |> JD.to_date(Julian)
                 # |> IO.inspect(label: "Julian              ")
               |> Julian.to_date(MayanLongCount)
                 # |> IO.inspect(label: "MayanLongCount      ")
               |> MayanLongCount.to_date(MJD)
                 # |> IO.inspect(label: "MJD                 ")
               |> MJD.to_date(ObservationalHebrew)
                 # |> IO.inspect(label: "ObservationalHebrew ")
               |> ObservationalHebrew.to_date(ObservationalIslamic)
                 # |> IO.inspect(label: "ObservationalIslamic")
               |> ObservationalIslamic.to_date(OldHinduLunar)
                 # |> IO.inspect(label: "OldHinduLunar       ")
               |> OldHinduLunar.to_date(OldHinduSolar)
                 # |> IO.inspect(label: "OldHinduSolar       ")
               |> OldHinduSolar.to_date(Persian)
                 # |> IO.inspect(label: "Persian             ")
               |> Persian.to_date(RataDie)
                 # |> IO.inspect(label: "RataDie             ")
               |> RataDie.to_date(Roman)
                 # |> IO.inspect(label: "Roman               ")
               |> Roman.to_date(Samaritan)
                 # |> IO.inspect(label: "Samaritan           ")
               |> Samaritan.to_date(SaudiIslamic)
                 # |> IO.inspect(label: "SaudiIslamic        ")
               |> SaudiIslamic.to_date(Tibetan)
                 # |> IO.inspect(label: "Tibetan             ")
               |> Tibetan.to_date(Unix)
                 # |> IO.inspect(label: "Unix                ")
               |> Unix.to_fixed()
               ) == fixed

    end
    
  end

  test "from_date, pipeline with intermediate values" do

    for fixed <- @fixed_dates do

      assert (
               fixed
                 # |> IO.inspect(label: "fixed               ")
               |> Unix.from_fixed()
                 # |> IO.inspect(label: "Unix                ")
               |> Tibetan.from_date(Unix)
                 # |> IO.inspect(label: "Tibetan             ")
               |> SaudiIslamic.from_date(Tibetan)
                 # |> IO.inspect(label: "SaudiIslamic        ")
               |> Samaritan.from_date(SaudiIslamic)
                 # |> IO.inspect(label: "Samaritan           ")
               |> Roman.from_date(Samaritan)
                 # |> IO.inspect(label: "Roman               ")
               |> RataDie.from_date(Roman)
                 # |> IO.inspect(label: "RataDie             ")
               |> Persian.from_date(RataDie)
                 # |> IO.inspect(label: "Persian             ")
               |> OldHinduSolar.from_date(Persian)
                 # |> IO.inspect(label: "OldHinduSolar       ")
               |> OldHinduLunar.from_date(OldHinduSolar)
                 # |> IO.inspect(label: "OldHinduLunar       ")
               |> ObservationalIslamic.from_date(OldHinduLunar)
                 # |> IO.inspect(label: "ObservationalIslamic")
               |> ObservationalHebrew.from_date(ObservationalIslamic)
                 # |> IO.inspect(label: "ObservationalHebrew ")
               |> MJD.from_date(ObservationalHebrew)
                 # |> IO.inspect(label: "MJD                 ")
               |> MayanLongCount.from_date(MJD)
                 # |> IO.inspect(label: "MayanLongCount      ")
               |> Julian.from_date(MayanLongCount)
                 # |> IO.inspect(label: "Julian              ")
               |> JD.from_date(Julian)
                 # |> IO.inspect(label: "JD                  ")
               |> ISO.from_date(JD)
                 # |> IO.inspect(label: "ISO                 ")
               |> Islamic.from_date(ISO)
                 # |> IO.inspect(label: "Islamic             ")
               |> Icelandic.from_date(Islamic)
                 # |> IO.inspect(label: "Icelandic           ")
               |> HinduSolar.from_date(Icelandic)
                 # |> IO.inspect(label: "HinduSolar          ")
               |> HinduLunar.from_date(HinduSolar)
                 # |> IO.inspect(label: "HinduLunar          ")
               |> Hebrew.from_date(HinduLunar)
                 # |> IO.inspect(label: "Hebrew              ")
               |> Gregorian.from_date(Hebrew)
                 # |> IO.inspect(label: "Gregorian           ")
               |> French.from_date(Gregorian)
                 # |> IO.inspect(label: "French              ")
               |> Ethiopic.from_date(French)
                 # |> IO.inspect(label: "Ethiopic            ")
               |> Egyptian.from_date(Ethiopic)
                 # |> IO.inspect(label: "Egyptian            ")
               |> Coptic.from_date(Egyptian)
                 # |> IO.inspect(label: "Coptic              ")
               |> Chinese.from_date(Coptic)
                 # |> IO.inspect(label: "Chinese             ")
               |> Bahai.from_date(Chinese)
                 # |> IO.inspect(label: "Bahai               ")
               |> Babylonian.from_date(Bahai)
                 # |> IO.inspect(label: "Babylonian          ")
               |> AstroHinduSolar.from_date(Babylonian)
                 # |> IO.inspect(label: "AstroHinduSolar     ")
               |> AstroHinduLunar.from_date(AstroHinduSolar)
                 # |> IO.inspect(label: "AstroHinduLunar     ")
               |> Armenian.from_date(AstroHinduLunar)
                 # |> IO.inspect(label: "Armenian            ")
               |> ArithmeticPersian.from_date(Armenian)
                 # |> IO.inspect(label: "ArithmeticPersian   ")
               |> ArithmeticFrench.from_date(ArithmeticPersian)
                 # |> IO.inspect(label: "ArithmeticFrench    ")
               |> ArithmeticFrench.to_fixed()
               ) == fixed

    end

  end

  test "from_fixed, to_fixed" do
    for fixed <- @fixed_dates do
      for cal <- @monotonous_calendars do
        assert fixed |> cal.from_fixed |> cal.to_fixed == fixed
      end
    end
  end

  test "from_jd, to_jd" do
    for fixed <- @fixed_dates do
      jd = JD.from_fixed(fixed)
      for cal <- @monotonous_calendars do
        assert jd |> cal.from_jd |> cal.to_jd == jd
      end
    end
  end

end