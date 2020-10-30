defmodule Icelandic do
  @moduledoc """
  The `Icelandic` calendar module.
  """
  use Calendars, [

    fields: [
      year: integer,
      season: 0..360,
      week: 1..27,
      weekday: 0..6
    ],

    months: [
      januar: [1, "Janúar"],
      februar: [2, "Febrúar"],
      mar: [3, "Mars"],
      april: [4, "Apríl"],
      mai: [5, "Maí"],
      juni: [6, "Júní"],
      juli: [7, "Júlí"],
      agust: [8, "Ágúst"],
      september: [9, "September"],
      oktober: [10, "Október"],
      november: [11, "Nóvember"],
      desember: [12, "Desember"]
    ],

#    old_icelandic_months: [
#      [1, "Harpa", "Thursday", "Summer"],
#      [2, "Skerpla", "Saturday", "Summer"],
#      [3, "Sólmánuður", "Monday", "Summer"],
#      ["Leap", "Sumarauki", "Wednesday"],
#      [4, "Heyannir", "Sunday", "Summer"],
#      [5, "Tvímánuður", "Tuesday", "Summer"],
#      [6, "Haustmánuður", "Thursday", "Summer"],
#      [1, "Gormánuður", "Saturday", "Winter"],
#      [2, "Ýlir", "Monday", "Winter"],
#      [3, "Mörsugur", "Wednesday", "Winter"],
#      [4, "Þorri", "Friday", "Winter"],
#      [5, "Góa", "Sunday", "Winter"],
#      [6, "Einmánuður", "Tuesday", "Winter"]
#    ],

    weekdays: [
      monday: [1, "Mánudagur", "Monday"],
      tuesday: [2, "Þriðjudagur", "Tuesday"],
      wednesday: [3, "Miðvikudagur", "Wednesday"],
      thursady: [4, "Fimmtudagur", "Thursday"],
      friday: [5, "Föstudagur", "Friday"],
      saturday: [6, "Laugardagur", "Saturday"],
      sunday: [7, "Sunnudagur", "Sunday"]
    ],

#    seasons: [
#      ["Vetur", "Winter"],
#      ["Vor", "Spring"],
#      ["Sumar", "Summer"],
#      ["Haust", "Autumn"],
#    ],

    # Year functions
    leap_year?: fn year -> Calixir.icelandic_leap_year?(year) end,

  ]

  @doc """
  Returns the month of the given `icelandic_date`.

  ## Example

      iex>#{__MODULE__}.month({2001, 90, 21, 2})
      5
  """
  @spec month(icelandic_date) :: integer
  def month({_year, _season, _week, _weekday} = icelandic_date) do
    Calixir.icelandic_month(icelandic_date)
  end

  @doc """
  Returns the start of summer in the given `icelandic_year`.

  ## Example

      iex>#{__MODULE__}.icelandic_summer(2001)
      730594
  """
  @spec icelandic_summer(icelandic_year) :: fixed
  def icelandic_summer(icelandic_year) do
    Calixir.icelandic_summer(icelandic_year)
  end

  @doc """
  Returns the start of winter in the given `icelandic_year`.

  ## Example

      iex>#{__MODULE__}.icelandic_winter(2001)
      730785
  """
  @spec icelandic_winter(icelandic_year) :: fixed
  def icelandic_winter(icelandic_year) do
    Calixir.icelandic_winter(icelandic_year)
  end


end
