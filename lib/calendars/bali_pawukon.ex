defmodule Calendars.BaliPawukon do
  @moduledoc """
  Documentation for the BaliPawukon calendar (DR4).

  This is a cyclical calendar. So it is not possible to convert a 'date'
  of this calendar into a corresponding date of a monotonous
  or another cyclical calendar.
  """
  @typep luang     :: boolean
  @typep dwiwara   :: integer
  @typep triwara   :: integer
  @typep caturwara :: integer
  @typep pancawara :: integer
  @typep sadwara   :: integer
  @typep saptawara :: integer
  @typep asatawara :: integer
  @typep sangawara :: integer
  @typep dasawara  :: integer
  @type  t         :: {luang, dwiwara, triwara, caturwara, pancawara,
                       sadwara, saptawara, asatawara, sangawara, dasawara}

  @doc """
  Returns the keyword used to access data in the DR4 sample data.
  """
  def keyword, do: :bali_pawukon

  @doc """
  Returns a BaliPawukon date from its parts.
  """
  def date(
        luang, dwiwara, triwara, caturwara, pancawara,
        sadwara, saptawara, asatawara, sangawara, dasawara) do
    {luang, dwiwara, triwara, caturwara, pancawara,
      sadwara, saptawara, asatawara, sangawara, dasawara}
  end

  @doc """
  Returns the epoch of the BaliPawukon calendar.
  """
  @spec epoch() :: number
  def epoch, do: Calixir.bali_pawukon_epoch()

  @doc """
  Converts `source_calendar_date` of the `source_calendar` into the
  corresponding BaliPawukon date.
  """
  def from_date(source_calendar_date, source_calendar) do
    source_calendar_date |> source_calendar.to_fixed |> from_fixed
  end

  @doc """
  Converts the `fixed` date in to the corresponding BaliPawukon date.
  """
  def from_fixed(fixed) do
    Calixir.bali_pawukon_from_fixed(fixed)
  end

  @doc """
  Converts the Julian Day number `jd` into the corresponding BaliPawukon date.
  """
  def from_jd(jd) do
    jd |> Calixir.fixed_from_jd |> from_fixed
  end

  # === Holidays

  @doc """
  Kajeng Keliwon (first).
  """
  defdelegate kajeng_keliwon(g_year), to: Calixir

  @doc """
  Tumpek (first).
  """
  defdelegate tumpek(g_year), to: Calixir

end
