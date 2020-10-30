defmodule MayanLongCount do
  @moduledoc """
  The `MayanLongCount` calendar module.
  """
  use Calendars, [
    fields: [
      baktun: integer,
      katun: 0..19,
      tun: 0..17,
      uinal: 0..19,
      kin: 1..19
    ]
  ]
end
