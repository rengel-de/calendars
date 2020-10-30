defmodule Islamic do
  @moduledoc """
  The `Islamic` calendar module.
  """
  use Calendars, [

    fields: [
      year: integer,
      month: 1..12,
      day: 29..30
    ],

    start_of_day: fn -> :sunset end,
    start_of_calendar: fn -> Calixir.fixed_from_julian(622, 7, 16) end,

    year: [
      # Constants
      mean_year: fn -> 354 + (11 / 30) end, # Average year length
      months_in_year: fn _y -> 12 end,
      # Functions
      add_years: fn fixed, years -> fixed + years * (354 + (11 / 30)) |> trunc end,
      days_in_year: fn y -> Calixir.islamic_leap_year?(y) && 355 || 354 end,
      leap_year?: fn y -> Calixir.islamic_leap_year?(y) end,
    ],

    months: [
      # Constants
      mean_month: fn -> (354 + (11 / 30)) / 12 end,
      # Data (DR4, 106)
      muharram: [1, "Muharram", 30],
      safar: [2, "Safar", 29],
      rabi_i: [3, "Rabi I (Rabi al-Awwal", 30],
      rabi_ii: [4, "Rabi II (Rabi al-Ahir", 29],
      jumada_i: [5, "Jumada I (Jumada al-Ula", 30],
      jumada_ii: [6, "Jumada II (Jumada al-Ahira", 29],
      rajab: [7, "Rajab", 30],
      sha_ban: [8, "Sha'ban", 29],
      ramadan: [9, "Ramadan", 30],
      shawwal: [10, "Shawwal", 29],
      dhu_al_quada: [11, "Dhu al-Qa'da", 30],
      dhi_al_hijja: [12, "Dhu al-Hijja", [29, 30]],

      # Functions
      days_in_month: fn
        y, 12 -> Calixir.islamic_leap_year?(y) && 30 || 29
        _, m -> Enum.at([30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29], m - 1)
      end
    ],

    weekdays: [
      al_ahad: [1, "al-ahad", "Sunday"],
      al_ithnayna: [2, "al-ithnayna", "Monday"],
      ath_thalatha: [3, "ath-thalatha", "Tuesday"],
      al_arba_a: [4, "al-arba_a", "Wednesday"],
      al_hamis: [5, "al-hamis", "Thursday"],
      al_jum_a: [6, "al-jum‘a", "Friday"],
      al_sabt: [7, "as-sabt", "Saturday"]
    ],

    holidays: [
      mawlid: ["Mawlid"]
    ]
  ]

  def date_text({year, month, day} = i_date) do
    weekday = i_date |> to_fixed |> Calixir.day_of_week_from_fixed
    weekday_name = Enum.at(weekdays(), weekday)
    month_name = Enum.at(months(), month - 1)
    "#{day} #{month_name} #{year} AH (yaum #{weekday_name})"
  end

end
