defmodule Mex do

  defmacro mex( do: block ) do
    block
    |> Macro.expand(__CALLER__)
    |> Macro.to_string
    |> IO.puts
    quote do: :ok
  end

end


