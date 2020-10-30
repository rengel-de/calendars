defmodule RataDie do
  @moduledoc """
  The `RataDie` calendar module.
  """
  use Calendars, [

    fields: [
      rd: :integer
    ],

    from_fixed: fn
      fixed -> {fixed}
    end,

    to_fixed: fn
      {rd} -> rd
      rd -> rd
    end
  ]

end
