defmodule CalendarDocs do
  @moduledoc false
  _ = """
  The `CalendarDocs` module supplements the generation of
  function docs and doctests.
  """
  def gen_doc(txt, module, function, io, type_text \\ nil) do
    if is_nil(type_text) do
      """
      #{txt}
      #{gen_test_header(io)}
      #{gen_test_block(module, function, io)}
      """
    else
      """
      #{txt}
      #{gen_type_text(Module.split(module) |> List.last)}
      #{gen_test_header(io)}
      #{gen_test_block(module, function, io)}
      """
    end
  end

  def gen_type_text(name) do
    """

    The `type` parameter determines the type of the returned value:
    - `:fixed` returns a fixed day (*default*),
    - `:date` returns a #{name} date.
    """
  end

  def gen_doc_tests(module, function, io, type_text \\ nil) do
    if is_nil(type_text) do
      """
      #{gen_test_header(io)}
      #{gen_test_block(module, function, io)}
      """
    else
      """
      #{gen_type_text(Module.split(module) |> List.last)}
      #{gen_test_header(io)}
      #{gen_test_block(module, function, io)}
      """
    end
  end

  defp gen_test_header(io) do
    """

    #{length(io) > 2 && "## Examples" || "## Example"}
    """
  end

  defp gen_test_block(module, function, io) do
    """
    #{gen_tests(module, function, io)}
    """
  end

  defp gen_tests(module, function, io) do
    io
    |> Enum.chunk_every(2)
    |> Enum.map(fn
          [nil, nil] -> ""
          [input, output] -> gen_test(module, function, input, output)
        end)
    |> Enum.join("\n")
  end

  defp gen_test(module, function, input, output) do
    "      iex>#{module}.#{function}(#{gen_value(input)})\n" <>
    "      #{gen_value(output)}"
  end

  defp gen_value({:raw, value}), do: value

  defp gen_value(nil), do: ""

  defp gen_value(a..b = _value), do: ~s|#{a}..#{b}|

  defp gen_value(value) when is_binary(value) do
    if String.starts_with?(value, "%{"),
      do: ~s|#{value}|,
      else: ~s|"#{value}"|
  end

  defp gen_value(value) when is_boolean(value), do: "#{value}"

  defp gen_value(value) when is_atom(value) do
    val_string = ":#{value}"
    cond do
      String.ends_with?(val_string, "Date") -> value
      String.ends_with?(val_string, "Calendar") -> value
      true -> val_string
    end
  end

  defp gen_value(value) when is_number(value), do: value

  defp gen_value({value}) when is_number(value), do: "{#{value}}"

  defp gen_value({_, _, value}) when is_list(value), do: gen_value(value)

  defp gen_value(value) when is_tuple(value) do
    "{#{value |> Tuple.to_list |> Enum.join(", ")}}"
  end

  # Needed for to_date and from_date tests!
  defp gen_value([arg, :gregorian] = _value) do
    "#{gen_value(arg)}, Gregorian"
  end

  defp gen_value([:fields | fields] = _value) do
    # Convert the list into an equivalent string without quotation marks.
    fields
    |> Enum.map(fn field -> gen_value(field) end)
    |> Enum.join(", ")
  end

  defp gen_value(value) when is_list(value) do
    # Convert the list into an equivalent string keeping quotation marks.
    Macro.to_string(value)
  end

  defp gen_value(_), do: raise "*** error: Unable to generate doctests."

  def gen_sample_dates(_keyword, field_atoms, from_fixed) do
    # IO.puts("gen_sample_dates: #{keyword}")

    fixed = 730739
    fixed_minus = fixed - 100
    fixed_plus = fixed + 100

    g_date = Calixir.gregorian_from_fixed(fixed)
    g_date_minus = Calixir.gregorian_from_fixed(fixed_minus)
    g_date_plus = Calixir.gregorian_from_fixed(fixed_plus)
    g_fields = Tuple.to_list(g_date)
    {g_year, g_month, g_day} = g_date

    date = from_fixed.(fixed)
    date_minus = from_fixed.(fixed_minus)
    date_plus = from_fixed.(fixed_plus)
    fields = Tuple.to_list(date)

    field_atoms
    |> Enum.zip(fields)
    |> Enum.into(%{})
    |> Map.put(:fixed, fixed)
    |> Map.put(:fixed_minus, fixed_minus)
    |> Map.put(:fixed_plus, fixed_plus)
    |> Map.put(:g_date, g_date)
    |> Map.put(:g_date_minus, g_date_minus)
    |> Map.put(:g_date_plus, g_date_plus)
    |> Map.put(:g_fields, g_fields)
    |> Map.put(:g_day, g_day)
    |> Map.put(:g_month, g_month)
    |> Map.put(:g_year, g_year)
    |> Map.put(:date, date)
    |> Map.put(:date_minus, date_minus)
    |> Map.put(:date_plus, date_plus)
    |> Map.put(:fields, fields)
    # |> IO.inspect(label: "sample")
  end

end