defmodule Unix do
  @moduledoc """
  The `Unix` calendar module.
  """
  use Calendars, [
    fields: [
      seconds: :integer
    ],

    from_fixed: fn fixed ->
      {fixed |> Calixir.unix_from_moment |> trunc}
    end,

    to_fixed: fn
      {seconds} -> seconds |> Calixir.moment_from_unix |> trunc
      seconds -> seconds |> Calixir.moment_from_unix |> trunc
    end
  ]
end
