defmodule MJD do
  @moduledoc """
  The `MJD` calendar module.
  """
  use Calendars, [
    fields: [
      day: integer
    ],

    from_fixed: fn
      fixed -> {Calixir.mjd_from_fixed(fixed) |> trunc}
    end,

    to_fixed: fn
      {day} -> Calixir.fixed_from_mjd(day)
      day -> Calixir.fixed_from_mjd(day)
    end
  ]

end
