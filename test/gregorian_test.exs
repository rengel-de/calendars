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

end