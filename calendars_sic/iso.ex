defmodule ISO do
  @moduledoc """
  The `ISO` calendar module.
  """
  use Calendars, [

    fields: [
      year: integer,
      week: 1..53,
      day: 1..7
    ],

    epoch: fn -> Calixir.gregorian_epoch() end,

  ]

  @doc """
  Returns `true` if the given ISO `year` has 53 weeks, otherwise false.

  ## Examples

      iex>#{__MODULE__}.long_year?(2020)
      true
      iex>#{__MODULE__}.long_year?(2021)
      false
  """
  @spec long_year?(iso_year) :: boolean
  def long_year?(year), do: Calixir.iso_long_year?(year)

  @doc """
  Returns the number of weeks in the given ISO `year`.

  *The ISO calendar has "short"(52-week) and "long" (53-week) years...
  An ISO year is long if and only if January 1 and December 31 is a
  Thursday.* (DR4, 96f)

  ## Examples

      iex>#{__MODULE__}.weeks_in_year(2020)
      53
      iex>#{__MODULE__}.weeks_in_year(2021)
      52
  """
  @spec weeks_in_year(iso_year) :: 52..53
  def weeks_in_year(year) do
    if Calixir.iso_long_year?(year), do: 53, else: 52
  end

end


