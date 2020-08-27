defmodule GregorianTest do
  use ExUnit.Case

  alias Calendars.Gregorian

  test "is_leap?" do
    assert Gregorian.is_leap?(1900) == false
    assert Gregorian.is_leap?(2000) == true
    assert Gregorian.is_leap?(2010) == false
    assert Gregorian.is_leap?(2020) == true
  end

  test "days_in_month" do
    assert Gregorian.days_in_month({2000, 1, 1}) == 31
    assert Gregorian.days_in_month({1900, 2, 1}) == 28
    assert Gregorian.days_in_month({2000, 2, 1}) == 29
    assert Gregorian.days_in_month({2020, 2, 1}) == 29
    assert Gregorian.days_in_month({2000, 3, 1}) == 31
    assert Gregorian.days_in_month({2000, 4, 1}) == 30
    assert Gregorian.days_in_month({2000, 5, 1}) == 31
    assert Gregorian.days_in_month({2000, 6, 1}) == 30
    assert Gregorian.days_in_month({2000, 7, 1}) == 31
    assert Gregorian.days_in_month({2000, 8, 1}) == 31
    assert Gregorian.days_in_month({2000, 9, 1}) == 30
    assert Gregorian.days_in_month({2000, 10, 1}) == 31
    assert Gregorian.days_in_month({2000, 11, 1}) == 30
    assert Gregorian.days_in_month({2000, 12, 1}) == 31
  end

  test "start_of_year, end_of_year" do
    assert Gregorian.start_of_year_as_date({2020, 8, 27}) == {2020, 1, 1}
    assert Gregorian.end_of_year_as_date({2020, 8, 27}) == {2020, 12, 31}
  end

  test "start_of_month, end_of_month" do
    assert Gregorian.start_of_month_as_date({2019, 2, 20}) == {2019, 2, 1}
    assert Gregorian.end_of_month_as_date({2019, 2, 20}) == {2019, 2, 28}

    assert Gregorian.start_of_month_as_date({2020, 2, 20}) == {2020, 2, 1}
    assert Gregorian.end_of_month_as_date({2020, 2, 20}) == {2020, 2, 29}

    assert Gregorian.start_of_month_as_date({2020, 8, 27}) == {2020, 8, 1}
    assert Gregorian.end_of_month_as_date({2020, 8, 27}) == {2020, 8, 31}

    assert Gregorian.start_of_month_as_date({2020, 9, 27}) == {2020, 9, 1}
    assert Gregorian.end_of_month_as_date({2020, 9, 27}) == {2020, 9, 30}
  end

  test "start_of_week, end_of_week" do
    assert Gregorian.start_of_week_as_date({2020, 8, 23}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 23}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 24}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 24}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 25}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 25}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 26}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 26}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 27}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 27}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 28}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 28}) == {2020, 8, 29}

    assert Gregorian.start_of_week_as_date({2020, 8, 29}) == {2020, 8, 23}
    assert Gregorian.end_of_week_as_date({2020, 8, 29}) == {2020, 8, 29}
  end

  test "holidays" do
    h1 = Gregorian.christmas({2020, 8, 27})
    h2 = Gregorian.christmas(2020)
    assert h1 == h2
  end

end