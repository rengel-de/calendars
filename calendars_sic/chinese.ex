defmodule Chinese do
  @moduledoc """
  The `Chinese` calendar module.
  """
  use Calendars, [
    fields: [
      cycle: integer,
      year: 1..60,
      month: 1..12,
      leap: boolean,
      day: 1..31
    ],

    holidays: [
      chinese_new_year: ["Chinese New Year"],
      qing_ming: ["Qingming"],
      dragon_festival: ["Dragon Festival"]
    ]


#  # === Addendum, not in DR4
#
#  @typep branch :: 1..12           # unsued type, for doc only
#  @typep stem   :: 1..10           # unsued type, for doc only
#  @typep name   :: {stem, branch}  # unsued type, for doc only
#
#  @doc """
#  Chinese Name.
#  Combination is only possible if `stem` and `branch` are equal mod 2.
#  """
#  def chinese_name(stem, branch), do: {stem, branch}
#
#  @doc """
#  Chinese Stem.
#  """
#  def chinese_stem({chinese_stem, _} = _chinese_name), do: chinese_stem
#
#  @doc """
#  Chinese Branch.
#  """
#  def chinese_branch({_, chinese_branch} = _chinese_name), do: chinese_branch

  ]
end
