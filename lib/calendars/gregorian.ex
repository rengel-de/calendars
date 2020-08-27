defmodule Calendars.Gregorian do
  @moduledoc """
  Documentation for the Gregorian calendar (DR4).
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
  def keyword, do: :gregorian

  @doc """
  Returns a Gregorian date from its parts.
  """
  def date(year, month, day), do: {year, month, day}

  @doc """
  Returns the epoch of the Gregorian calendar.
  """
  def epoch, do: Calixir.gregorian_epoch()

  @doc """
  Returns the number of days in the month of `_gregorian_date`.
  """
  def days_in_month({year, 2, _day} = _gregorian_date), do: is_leap?(year) && 29 || 28
  def days_in_month({_year, 4, _day} = _gregorian_date), do: 30
  def days_in_month({_year, 6, _day} = _gregorian_date), do: 30
  def days_in_month({_year, 9, _day} = _gregorian_date), do: 30
  def days_in_month({_year, 11, _day} = _gregorian_date), do: 30
  def days_in_month({_year, _, _day} = _gregorian_date), do: 31

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Gregorian date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Gregorian date.
  """
  def from_fixed(fixed) do
    Calixir.gregorian_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Gregorian date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Returns true if the year of `_gregorian_date` is a Gregorian leap year.
  """
  def is_leap?({year, _month, _day}= _gregorian_date) do
    Calixir.gregorian_leap_year?(year)
  end

  @doc """
  Returns true is the given `year` is a Gregorian leap year.
  """
  def is_leap?(year) do
    Calixir.gregorian_leap_year?(year)
  end

  @doc """
  Converts `gregorian_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(gregorian_date, target_calendar) do
    gregorian_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `gregorian_date` into the corresponding `fixed` date.
  """
  def to_fixed(gregorian_date) do
    Calixir.fixed_from_gregorian(gregorian_date)
  end

  @doc """
  Converts `gregorian_date` into the corresponding Julian Day number.
  """
  def to_jd(gregorian_date) do
    gregorian_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Advent Sunday.
  """
  defdelegate advent(g_year), to: Calixir

  @doc """
  Christmas.
  """
  defdelegate christmas(g_year), to: Calixir

  @doc """
  Easter.
  """
  defdelegate easter(g_year), to: Calixir

  @doc """
  Epiphany.
  """
  defdelegate epiphany(g_year), to: Calixir

  @doc """
  Friday the 13th (first).
  """
  defdelegate unlucky_fridays(g_year), to: Calixir

  @doc """
  Daylight Saving End.
  """
  defdelegate daylight_saving_end(g_year), to: Calixir

  @doc """
  Daylight Saving Start.
  """
  defdelegate daylight_saving_start(g_year), to: Calixir

  @doc """
  Pentecost.
  """
  defdelegate pentecost(g_year), to: Calixir

  @doc """
  U.S. Election Day.
  """
  defdelegate election_day(g_year), to: Calixir

  @doc """
  U.S. Independence Day.
  """
  defdelegate independence_day(g_year), to: Calixir

  @doc """
  U.S. Labor Day.
  """
  defdelegate labor_day(g_year), to: Calixir

  @doc """
  U.S. Memorial Day.
  """
  defdelegate memorial_day(g_year), to: Calixir

  # === Additional Functions

  @doc """
  Returns end of the current year as a Gregorian date.
  """
  def end_of_month_as_date({year, month, day} = g_date) do
    days = days_in_month_of_date(g_date)
    {year, month, days}
  end

  @doc """
  Returns end of the current week as a Gregorian date.
  """
  def end_of_week_as_date({year, month, day} = g_date) do
    fixed = to_fixed(g_date)
    day_of_week = Calixir.day_of_week_from_fixed(fixed)
    from_fixed(fixed + 6 - day_of_week)
  end

  @doc """
  Returns end of the current year as a Gregorian date.
  """
  def end_of_year_as_date({year, month, day} = g_date) do
    {year, 12, 31}
  end

  @doc """
  Returns start of the current year as a Gregorian date.
  """
  def start_of_month_as_date({year, month, day} = g_date) do
    {year, month, 1}
  end

  @doc """
  Returns start of the current week as a Gregorian date.
  """
  def start_of_week_as_date({year, month, day} = g_date) do
    fixed = to_fixed(g_date)
    day_of_week = Calixir.day_of_week_from_fixed(fixed)
    from_fixed(fixed - day_of_week)
  end

  @doc """
  Returns start of the current year as a Gregorian date.
  """
  def start_of_year_as_date({year, month, day} = g_date) do
    {year, 1, 1}
  end

  @doc """
  Returns the date of today.
  """
  def today_as_date(), do: Date.utc_today() |> Date.to_erl()

  @doc """
  Returns true, if `g_year` is a leap year.
  """
  defdelegate leap_year?(g_year), to: Calixir, as: :gregorian_leap_year?

  @doc """
  Returns the name of the month from the Gregorian date `_g_date`.
  """
  def name_of_month_from_date({_year, month, _day} = _g_date) do
    case month do
      1 -> :january
      2 -> :february
      3 -> :march
      4 -> :april
      5 -> :may
      6 -> :june
      7 -> :july
      8 -> :august
      9 -> :september
      10 -> :october
      11 -> :november
      12 -> :december
    end
  end

  @doc """
  Returns the name of the month from the `fixed` date.
  """
  def name_of_month_from_fixed(fixed) do
    fixed |> from_fixed |> name_of_month_from_date
  end

  @doc """
  Returns the quarter of the year from the Gregorian date `_g_date`.
  """
  def quarter_from_date({_year, month, _day} = _g_date) do
    cond do
      month < 4 -> 1
      month < 7 -> 2
      month < 10 -> 3
      true -> 4
    end
  end

  @doc """
  Returns the quarter of the year from the `fixed` date.
  """
  def quarter_from_fixed(fixed) do
    fixed |> from_fixed |> quarter_from_date
  end

  @doc """
  Returns the number of days in the month of `_g_date`.
  """
  def days_in_month_of_date({year, month, _day} = _g_date) do
    case month do
      1 -> 31
      2 -> leap_year?(year) && 29 || 28
      3 -> 31
      4 -> 30
      5 -> 31
      6 -> 30
      7 -> 31
      8 -> 31
      9 -> 30
      10 -> 31
      11 -> 30
      12 -> 31
    end
  end

  @doc """
  Returns the number of days in the month of `fixed` date.
  """
  def days_in_month_of_fixed(fixed) do
    fixed |> from_fixed |> days_in_month_of_date
  end

  @doc """
  Returns the number of days in the quarter of `g_date`.
  """
  def days_in_quarter_of_date({year, _month, _day} = g_date) do
    case quarter_from_date(g_date) do
      1 -> leap_year?(year) && 91 || 90
      2 -> 91
      3 -> 92
      4 -> 92
    end
  end

  @doc """
  Returns the number of days in the quarter of `fixed` date.
  """
  def days_in_quarter_of_fixed(fixed) do
    fixed |> from_fixed |> days_in_quarter_of_date
  end

  @doc """
  Returns the English names of the months as list.
  """
  def month_names_as_list(), do: @months

  @doc """
  Returns the English names of the weekdays as list.
  """
  def day_names_as_list(), do: @weekdays

end
