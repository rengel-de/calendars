defmodule JD do
  @moduledoc """
  The `JD` calendar module.
  """
  use Calendars, [
    fields: [
      day: number
    ],

    from_fixed: fn
      fixed -> {Calixir.jd_from_moment(fixed)}
    end,

    to_fixed: fn
      {day} -> Calixir.moment_from_jd(day) |> trunc
      day -> Calixir.moment_from_jd(day) |> trunc
    end,

    start_of_day: fn -> :noon end
  ]

end
