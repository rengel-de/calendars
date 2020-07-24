defmodule Calendars.Bahai do
  @moduledoc """
  Documentation for the Bahai calendar (DR4).
  """
  @typep major :: integer
  @typep cycle :: 1..19
  @typep year  :: 1..19
  @typep month :: 0..19
  @typep day   :: 1..19
  @type  t     :: {major, cycle, year, month, day}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :bahai

  @doc """
  Returns a Bahai date from its parts.
  """
  def date(major, cycle, year, month, day) do
    {major, cycle, year, month, day}
  end

  @doc """
  Returns the epoch of the Bahai calendar.
  """
  def epoch, do: Calixir.bahai_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Bahai date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Bahai date.
  """
  def from_fixed(fixed) do
    Calixir.bahai_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Bahai date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `bahai_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(bahai_date, target_calendar) do
    bahai_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `bahai_date` into the corresponding `fixed` date.
  """
  def to_fixed(bahai_date) do
    Calixir.fixed_from_bahai(bahai_date)
  end

  @doc """
  Converts `bahai_date` into the corresponding Julian Day number.
  """
  def to_jd(bahai_date) do
    bahai_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Holidays

  @doc """
  Baha'i New Year.
  """
  defdelegate new_year(g_year), to: Calixir, as: :bahai_new_year

  @doc """
  Birth of the Bab.
  """
  defdelegate birth_of_the_bab(g_year), to: Calixir

  @doc """
  Feast of Naw-Ruz.
  """
  defdelegate naw_ruz(g_year), to: Calixir

  @doc """
  Feast of Ridvan.
  """
  defdelegate feast_of_ridvan(g_year), to: Calixir

end
