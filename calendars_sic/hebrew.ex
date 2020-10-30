defmodule Hebrew do
  @moduledoc """
  The `Hebrew` calendar module.
  """
  use Calendars, [
    fields: [
      year: :integer,
      month: 1..13,
      day: 1..30
    ],

    months: [
      nisan: [1, "Nisan", 30, "8.1"],
      iyyar: [2, "Iyyar", 29, "8.2"],
      sivan: [3, "Sivan", 30, "8.3"],
      tammuz: [4, "Tammuz", 29, "8.4"],
      av: [5, "Av", 30, "8.5"],
      elul: [6, "Elul", 29, "8.6"],
      tishri: [7, "Tishri", 30, "8.7"],
      marshevan: [8, "Kheshvan", [29, 30], "8.8"],
      kislev: [9, "Kislev", [29, 30], "8.9"],
      tevet: [10, "Tevet", 29, "8.10"],
      shevat: [11, "Shevat", 30, "8.11"],
      adar: [12, "Adar", 30, "8.12"],
      adarii: [13, "Adar II", 29, "8.13"],
    ],

    weekdays: [
      yom_rishon: [0, "Yom Rishon"],
      yom_sheni: [1, "Yom Sheni"],
      yom_shelishi: [2, "Yom Shlishi"],
      yom_revii: [3, "Yom Revi-ee"],
      yom_hamishi: [4, "Yom Chamishi"],
      yom_shishi: [5, "Yom Shishi"],
      yom_shabbat: [6, "Shabbat"],
    ],

    holidays: [
      yom_kippur: ["Yom Kippur", "8.30"],
      passover: ["Passover", "8.31"],
      ta_anit_esther: ["Ta'anit Esther", "8.34"],
      tishah_be_av: ["Tisha be-Av", "8.35"],
      yom_ha_zikkaron: ["Yom ha Zikkaron", "8.36"],
      sh_ela: ["Sh'ela", "8.37"],
      birkath_ha_hama: ["Birkath Ha Hama", "8.38"],
      alt_birkath_ha_hama: ["Birkath Ha Hama", "8.40"],
      hanukkah: ["Hanukkah", "8.43"]
    ],

    calixir_api: [
      hebrew_leap_year?: [[:year], "8.14"],
      last_month_of_hebrew_year: [[:year], "8.15"],
      hebrew_sabbatical_year?: [[:year], "8.16"],
      hebrew_epoch: [[], "8.17"],
      molad: [[:year, :month], "8.19"],
      hebrew_calendar_elapsed_days: [[:year], "8.20"],
      hebrew_year_length_correction: [[:year], "8.21"],
      hebrew_new_year: [[:year], "8.22"],
      last_day_of_hebrew_month: [[:year, :month], "8.23"],
      long_marhesvan?: [[:year], "8.24"],
      short_kislev?: [[:year], "8.25"],
      days_in_hebrew_year: [[:year], "8.26"],
      fixed_from_hebrew: [[:year, :month, :day], "8.27"],
      hebrew_from_fixed: [[:fixed], "8.28"],
      fixed_from_molad: [[:moon], "8.29"],
      omer: [[:fixed], "8.32"],
      samuel_season_in_gregorian: [[:season, :gregorian_year], "8.39"],
      adda_season_in_gregorian: [[:season, :gregorian_year], "8.41"],
      hebrew_in_gregorian: [[:month, :day, :gregorian_year], "8.42"],
      # hebrew_birthday: [[:birth_year, :birth_month, :birth_day, :year], "8.44"],
      # hebrew_birthday_in_gregorian: [[:birthdate, :gregorian_year], "8.45"],
      # yahrzeit: [[:death_year, :death_month, :death_day, :year], "8.46"],
      # yahrzeit_in_gregorian: [[:detadate, :gregorian_year], "8.47"],
      # shift_days: [[:l, :delta], "8.49"],
      # possible_hebrew_days: [[:month, :day], "8.50"],
    ],

    # Year functions
    days_in_year: fn y -> Calixir.days_in_hebrew_year(y) end,
    last_month_of_year: fn y -> Calixir.last_month_of_hebrew_year(y) end,
    leap_year?: fn y -> Calixir.hebrew_leap_year?(y) end,
    months_in_year: fn y -> Calixir.last_month_of_hebrew_year(y) end,
    new_year: fn y -> Calixir.hebrew_new_year(y) end,
    year_end: fn y -> Calixir.hebrew_new_year(y + 1) - 1 end,

    # Month functions
    days_in_month: fn y, m -> Calixir.last_day_of_hebrew_month(y, m) end,
    days_remaining_in_month: fn {y, m, d} -> Calixir.last_day_of_hebrew_month(y, m) - d end,
    end_of_month: fn y, m -> {y, m, Calixir.last_day_of_hebrew_month(y, m)} end,
    start_of_month: fn y, m -> {y, m, 1} end,

    # Weekday functions
    days_in_week: fn -> 7 end,

  ]

  @doc false
  def date_text({year, month, day} = date) do
    day_of_week = weekday_number(date)
    weekday_name = Enum.at(weekdays(), day_of_week)
    month_name = Enum.at(months(), month - 1)
    "#{weekday_name}, #{month_name} #{day}, #{year}"
  end

end