defmodule Calendars.Julian do
  @moduledoc """
  Documentation for the Julian calendar (DR4).
  """
  @typep year  :: integer
  @typep month :: 1..12
  @typep day   :: 1..31
  @type  t     :: {year, month, day}

  @months [
    "January", "February", "March", "April", "May", "June", "Juli", "August",
    "September", "October", "November", "December"
  ]

  @weekdays [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ]

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :julian

  @doc """
  Returns a Julian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Julian calendar.
  """
  def epoch, do: Calixir.julian_epoch()

  @doc """
  Returns the number of days in the month of `_julian_date`.
  """
  def days_in_month({year, 2, _day} = _julian_date), do: is_leap?(year) && 29 || 28
  def days_in_month({_year, 4, _day} = _julian_date), do: 30
  def days_in_month({_year, 6, _day} = _julian_date), do: 30
  def days_in_month({_year, 9, _day} = _julian_date), do: 30
  def days_in_month({_year, 11, _day} = _julian_date), do: 30
  def days_in_month({_year, _, _day} = _julian_date), do: 31

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Julian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Julian date.
  """
  def from_fixed(fixed) do
    Calixir.julian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Julian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Returns true if the year of `_julian_date` is a Julian leap year.
  """
  def is_leap?({year, _month, _day}= _julian_date) do
    Calixir.gregorian_leap_year?(year)
  end

  @doc """
  Returns true if the given `year` is a Julian leap year.
  """
  def is_leap?(year) do
    Calixir.julian_leap_year?(year)
  end

  @doc """
  Converts `julian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(julian_date, target_calendar) do
    julian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `julian_date` into the corresponding `fixed` date.
  """
  def to_fixed(julian_date) do
    Calixir.fixed_from_julian(julian_date)
  end

  @doc """
  Converts `julian_date` into the corresponding Julian Day number.
  """
  def to_jd(julian_date) do
    julian_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Christmas (Orthodox).
  """
  defdelegate eastern_orthodox_christmas(g_year), to: Calixir

  @doc """
  Easter (Orthodox).
  """
  defdelegate orthodox_easter(g_year), to: Calixir

  @doc """
  Easter (Orthodox) Alt.
  """
  defdelegate alt_orthodox_easter(g_year), to: Calixir

  # === Additional Functions

  @doc """
  Returns true, if `j_year` is a leap year.
  """
  defdelegate leap_year?(j_year), to: Calixir, as: :julian_leap_year?

  @doc """
  Returns the given `fixed` date or Julian `j_date` as text.
  """
  def date_text(fixed) when is_number(fixed) do
    fixed |> from_fixed |> date_text
  end

  def date_text({year, month, day} = j_date) do
    day_of_week = j_date |> to_fixed |> Calendars.DayOfWeek.from_fixed
    weekday_name = Enum.at(@weekdays, day_of_week)
    month_name = Enum.at(@months, month - 1)
    "#{weekday_name}, #{month_name} #{day}, #{year}"
  end

end
