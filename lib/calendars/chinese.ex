defmodule Calendars.Chinese do
  @moduledoc """
  Documentation for the Chinese calendar (DR4).
  """
  @typep cycle :: integer
  @typep year  :: 1..60
  @typep month :: 1..12
  @typep leap  :: boolean
  @typep day   :: 1..31
  @type  t     :: {cycle, year, month, leap, day}

  # === Addendum, not in DR4

  # @typep branch :: 1..12           # unsued type, for doc only
  # @typep stem   :: 1..10           # unsued type, for doc only
  # @typep name   :: {stem, branch}  # unsued type, for doc only

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :chinese

  @doc """
  Returns a Chinese date from its parts.
  """
  def date(cycle, year, month, leap, day) do
    {cycle, year, month, leap, day}
  end

  @doc """
  Returns the epoch of the Chinese calendar.
  """
  def epoch, do: Calixir.chinese_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding Chinese date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding Chinese date.
  """
  def from_fixed(fixed) do
    Calixir.chinese_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding Chinese date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  @doc """
  Converts `chinese_date` into the corresponding date of
  `target_calendar`.
  """
  def to_date(chinese_date, target_calendar) do
    chinese_date |> to_fixed |> target_calendar.from_fixed
  end

  @doc """
  Converts `chinese_date` into the corresponding `fixed` date.
  """
  def to_fixed(chinese_date) do
    Calixir.fixed_from_chinese(chinese_date)
  end

  @doc """
  Converts `chinese_date` into the corresponding Julian Day number.
  """
  def to_jd(chinese_date) do
    chinese_date |> to_fixed |> Calixir.jd_from_fixed
  end

  # === Addendum: not in DR4

  @doc """
  Chinese Name.
  Combination is only possible if `stem` and `branch` are equal mod 2.
  """
  def chinese_name(stem, branch), do: {stem, branch}

  @doc """
  Chinese Stem.
  """
  def chinese_stem({chinese_stem, _} = _chinese_name), do: chinese_stem

  @doc """
  Chinese Branch.
  """
  def chinese_branch({_, chinese_branch} = _chinese_name), do: chinese_branch

  # === Holidays

  @doc """
  Chinese New Year.
  """
  defdelegate new_year(g_year), to: Calixir, as: :chinese_new_year

  @doc """
  Qingming.
  """
  defdelegate qing_ming(g_year), to: Calixir

  @doc """
  Dragon Festival.
  """
  defdelegate dragon_festival(g_year), to: Calixir

end
