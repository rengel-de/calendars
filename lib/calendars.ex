#TODO article "Polymorphism without inheritance and behaviours".
#TODO article "Documentation - Macros to the Rescue"
#TODO era, bce ce
#TODO Doc for single quarters
#TODO Quarter calendar
#TODO Moment als Kalender einrichten, epoch: RataDie.epoch, unit: second
#TODO What about the smallest Unit?, :day, :olympiad, :second, :nano_second
#TODO: start_of_day, :midnight, :sunrise, :sunset
#TODO: compatible?, equal start_of_day and equal unit
#TODO duration, diff of same units
#TODO: to_date bei MayanTzolkin darf nicht sein!
#TODO Logarithmic Calendar, Fibonacci Calendar
#TODO AnyPeriod Calendar: Arbitrary number of days as base
#TODO Indiction Calendar: Arbitrary number of days as base
#TODO Metonic Calendar: Arbitrary number of days as base
#TODO Add Zeller's congruence



defmodule Calendars do
  @moduledoc false
  _ = """
  Documentation for Calendars.

  This module generates functions common to all calendars.

  All of the calendars have a common set of functions that
  contain either metainformation about the calendar or make
  it easier to access and to convert calenders.

  Metainformation about the Gregorian calendar.
  - `name` - display of the calendar in user interfaces
  - `keyword` - access data in the DR4 sample data
  - `epoch` - the epoch of the calendar, `nil` if cyclical
  - `fields` - type, min, and max of the date components
  - `field_atoms` - the names of the calendar's fields in order
  """
  import CalendarDocs

  defmacro __using__(opts \\ []) do

    Code.ensure_loaded(Calixir)

    spec = generate_spec(opts, __CALLER__.module)

    functions = Enum.map(opts, fn
      # Exclude predefined functions
      {:epoch, _} -> nil
      {:to_fixed, _} -> nil
      {:from_fixed, _} -> nil
      {:start_of_calendar, _} -> nil
      {:start_of_day, _} -> nil
      # Generate undefined functions
      {k, _} -> gen_fun(k, spec)
    end)

    quote do
      @type fixed :: integer

      # Common functions
      unquote(gen_fun(:type_defs, spec))
      unquote(gen_fun(:module, spec))
      unquote(gen_fun(:name, spec))
      unquote(gen_fun(:keyword, spec))
      unquote(gen_fun(:epoch, spec))

      # Converters
      unquote(gen_fun(:from_fixed, spec))
      unquote(gen_fun(:to_fixed, spec))

      unquote(gen_fun(:as_date, spec))
      unquote(gen_fun(:as_fixed, spec))
      unquote(gen_fun(:as_type, spec))

      unquote(gen_fun(:from_date, spec))
      unquote(gen_fun(:to_date, spec))

      unquote(gen_fun(:from_jd, spec))
      unquote(gen_fun(:to_jd, spec))

      unquote(gen_fun(:from_unix, spec))
      unquote(gen_fun(:to_unix, spec))

      unquote(gen_fun(:from_rata_die, spec))
      unquote(gen_fun(:to_rata_die, spec))

      # Calendar-specific functions
      unquote_splicing(functions)

      unquote(gen_fun(:calculations, spec))

      unquote(gen_fun(:comparisons, spec))
    end

  end


  ##########################################################
  # Generate the Calendar Specification
  ##########################################################

  defp generate_spec(opts, module) do
    name = Module.split(module) |> List.last
    keyword = atomize(name)

    %{}
    |> Map.put(:opts, Enum.into(opts, %{}))
    |> Map.put(:module, module)
    |> Map.put(:name, name)
    |> Map.put(:keyword, keyword)
    |> add_spec(:epoch)
    |> add_spec(:start_of_day)
    |> add_spec(:start_of_calendar)
    |> add_spec(:field_data)
    |> add_spec(:field_type_data)
    |> add_spec(:type_data)
    |> add_spec(:from_fixed_function)
    |> add_spec(:to_fixed_function)
    |> add_spec(:sample_data)
    # |> IO.inspect(label: "spec")
  end

  defp add_spec(%{opts: %{epoch: {{_, _, _}, _, _} = epoch}} = spec, :epoch) do
    epoch = epoch |> Code.eval_quoted |> elem(0)
    Map.put(spec, :epoch, epoch)
  end

  defp add_spec(%{opts: %{epoch: {:fn, _, _} = epoch}} = spec, :epoch) do
    epoch = get_f(epoch).()
    Map.put(spec, :epoch, epoch)
  end

  defp add_spec(%{opts: %{epoch: epoch}} = spec, :epoch) do
    epoch = epoch |> Code.eval_quoted |> elem(0)
    Map.put(spec, :epoch, epoch)
  end

  defp add_spec(%{keyword: keyword} = spec, :epoch) do
    function = :"#{keyword}_epoch"
    if function_exported?(Calixir, function, 0) do
      epoch = (
        quote do
          Calixir.unquote(function)()
        end |> Code.eval_quoted |> elem(0))
      Map.put(spec, :epoch, epoch)
    else
      Map.put(spec, :epoch, nil)
    end
  end

  defp add_spec(%{opts: %{start_of_day: start_of_day}} = spec, :start_of_day) do
    start_of_day = start_of_day |> Code.eval_quoted |> elem(0)
    start_of_day = if is_function(start_of_day),
        do: start_of_day.(),
        else: start_of_day
    Map.put(spec, :start_of_day, start_of_day)
  end

  defp add_spec(spec, :start_of_day) do
    Map.put(spec, :start_of_day, :midnight)
  end

  defp add_spec(%{opts: opts} = spec, :start_of_calendar) do
    Map.put(spec, :start_of_calendar, Map.get(opts, :start_of_calendar))
  end

  defp add_spec(%{opts: %{fields: fields}} = spec, :field_data) do
    field_count = length(fields)
    field_atoms = Keyword.keys(fields)
    field_numbers = Enum.to_list(0..(field_count - 1))
    field_indices = Enum.with_index(field_atoms)
    field_strings = Enum.map(field_atoms, fn e -> "#{e}" end)
    field_string = Enum.join(field_strings, ", ")
    field_names = Enum.map(field_strings, fn e -> String.capitalize(e) end)
    field_params = Enum.join(field_strings, ", ")
    field_asts = Enum.map(field_atoms, fn e -> Macro.var(e, nil) end)
    spec
    |> Map.put(:field_count, field_count)
    |> Map.put(:field_atoms, field_atoms)
    |> Map.put(:field_numbers, field_numbers)
    |> Map.put(:field_indices, field_indices)
    |> Map.put(:field_names, field_names)
    |> Map.put(:field_params, field_params)
    |> Map.put(:field_asts, field_asts)
    |> Map.put(:field_string, field_string)
  end

  defp add_spec(%{keyword: keyword,opts: %{fields: fields}} = spec, :field_type_data) do
    field_types = Enum.map(fields, fn {field_name, type_value} ->
      {field_name, :"#{keyword}_#{field_name}", type_value}
    end) # |> IO.inspect(label: "field_types")

    field_type_asts = Enum.map(field_types, fn {field_name, type_name, value} ->
      {field_name, Macro.var(type_name, nil), value}
    end) # |> IO.inspect(label: "field_type_asts")

    field_type_defs = Enum.map(field_type_asts, fn {field_name, type_name_ast, value} ->
      {field_name, quote(do: @type unquote(type_name_ast) :: unquote(value))}
    end) # |> IO.inspect(label: "field_type_defs")

    spec
    |> Map.put(:field_types, field_types)
    |> Map.put(:field_type_asts, field_type_asts)
    |> Map.put(:field_type_defs, field_type_defs)
  end

  defp add_spec(%{opts: %{from_fixed: from_fixed}} = spec, :from_fixed_function) do
    Map.put(spec, :from_fixed, from_fixed)
  end

  defp add_spec(%{keyword: keyword} = spec, :from_fixed_function) do
    f_name = :"#{keyword}_from_fixed"
    if not function_exported?(Calixir, f_name, 1),
       do:   Map.put(spec, :from_fixed, nil),
       else: Map.put(spec, :from_fixed,
         quote do
           fn (fixed) -> Calixir.unquote(f_name)(fixed) end
         end)
  end

  defp add_spec(%{opts: %{to_fixed: to_fixed}} = spec, :to_fixed_function) do
    Map.put(spec, :to_fixed, to_fixed)
  end

  defp add_spec(%{keyword: keyword, field_asts: args} = spec, :to_fixed_function) do
    f_name = :"fixed_from_#{keyword}"
    if not function_exported?(Calixir, f_name, spec.field_count),
       do:   Map.put(spec, :to_fixed, nil),
       else: Map.put(spec, :to_fixed,
         quote do
           fn ({unquote_splicing(args)}) ->
             Calixir.unquote(f_name)(unquote_splicing(args))
           end
         end)
  end

  defp add_spec(%{keyword: keyword, field_atoms: field_atoms} = spec, :sample_data) do
    f = get_f(spec.from_fixed)
    Map.put(spec, :sample, gen_sample_dates(keyword, field_atoms, f))
  end

  defp add_spec(%{keyword: keyword} = spec, :type_data) do
    date_name = :"#{keyword}_date"
    date_ast = Macro.var(date_name, nil)
    fixed_ast = Macro.var(:fixed, __MODULE__)
    type_asts = Enum.map(spec.field_type_asts, fn {_, ast, _} -> ast end)
    type_spec_asts = Enum.map(spec.field_type_asts, fn
      {name, ast, _} -> {name, ast}
    end) # |> IO.inspect(label: "type_spec_asts")

    # Use this map to generate the typedefs
    type_defs = spec.field_type_defs ++ [
      {date_name, quote(do: @type unquote(date_ast) :: {unquote_splicing(type_asts)})},
      {:t, quote(do: @type t :: unquote(date_ast))}
    ] # |> IO.inspect(label: "type_defs")

    # Use this map to generate @spec declarations
    types = type_spec_asts ++ [
      {:date, date_ast},
      {:cal_date, {:|, [], [fixed_ast, date_ast]}},
      {:asts, type_asts}
    ] |> Enum.into(%{}) # |> IO.inspect(label: "types")

    spec
    |> Map.put(:type_defs, type_defs)
    |> Map.put(:types, types)
  end

  defp add_spec(spec, _), do: spec    # Catch-all function


  ##########################################################
  # Generate Functions
  ##########################################################

  # Common functions

  defp gen_fun(:type_defs, %{type_defs: type_defs}) do
    Enum.map(type_defs, &(quote(do: unquote(&1))))
  end

  defp gen_fun(:module, %{module: module, name: name}) do
    txt = "Returns the module of the #{name} calendar."
    io = [nil, {:raw, Module.split(module) |> List.last}]
    doc = gen_doc(txt, module, :module, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec module :: module
      def module, do: unquote(module)
    end
  end

  defp gen_fun(:name, %{module: module, name: name}) do
    txt = "Returns the internal name of the #{name} calendar."
    io = [nil, name]
    doc = gen_doc(txt, module, :name, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec name :: atom
      def name, do: unquote(name)
    end
  end

  defp gen_fun(:keyword, %{module: module, name: name, keyword: keyword}) do
    txt = "Returns the internal keyword of the #{name} calendar."
    io = [nil, keyword]
    doc = gen_doc(txt, module, :keyword, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec keyword :: atom
      def keyword, do: unquote(keyword)
    end
  end

  defp gen_fun(:epoch, %{epoch: nil}), do: nil
  defp gen_fun(:epoch, %{name: name} = spec) do
    txt = "Returns the epoch of the #{name} calendar."
    io = [nil, spec.epoch]
    doc = gen_doc(txt, spec.module, :epoch, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec epoch :: number
      def epoch, do: unquote(spec.epoch)
    end
  end

  # Converters

  defp gen_fun(:from_fixed, %{name: name, sample: sample} = spec) do
    txt = "Converts a fixed day to a `#{name}` date."
    io = [sample.fixed, sample.date]
    doc = gen_doc(txt, spec.module, :from_fixed, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec from_fixed(fixed) :: unquote(spec.types.date)
      def from_fixed(fixed) do
        unquote(spec.from_fixed).(fixed)
      end
    end
  end

  defp gen_fun(:to_fixed, %{to_fixed: nil}), do: nil
  defp gen_fun(:to_fixed, %{name: name, sample: sample} = spec) do
    txt1 = "Converts a #{name} date tuple into a fixed day."
    io1 = [sample.date, sample.fixed]
    doc1 = gen_doc(txt1, spec.module, :to_fixed, io1)

    txt2 = "Converts a #{name} date given by `#{spec.field_string}` into a fixed day."
    io2 = [[:fields] ++ sample.fields, sample.fixed]
    doc2 = gen_doc(txt2, spec.module, :to_fixed, io2)

    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec to_fixed(unquote(spec.types.date)) :: fixed
      def to_fixed({unquote_splicing(spec.field_asts)} = _date)  do
        unquote(spec.to_fixed).({unquote_splicing(spec.field_asts)}) |> trunc
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec to_fixed(unquote_splicing(spec.types.asts)) :: fixed
      def to_fixed(unquote_splicing(spec.field_asts)) do
        unquote(spec.to_fixed).({unquote_splicing(spec.field_asts)}) |> trunc
      end
    end
  end

  defp gen_fun(:as_date, %{name: name, sample: sample} = spec) do
    txt = """
    Returns a fixed day or #{name} date as a #{name} date.

    This is a convenience function to simplify certain function calls.
    """
    io = [sample.fixed, sample.date, sample.date, sample.date]
    doc = gen_doc(txt, spec.module, :as_date, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec as_date(unquote(spec.types.cal_date)) :: unquote(spec.types.date)
      def as_date(cal_date) when is_tuple(cal_date), do: cal_date
      def as_date(cal_date), do: from_fixed(cal_date)
    end
  end

  defp gen_fun(:as_fixed, %{to_fixed: nil}), do: nil
  defp gen_fun(:as_fixed, %{name: name, sample: sample} = spec) do
    txt = """
    Returns a fixed day or #{name} date as a fixed day.

    This is a convenience function to simplify certain function calls.
    """
    if spec.keyword == :mayan_tzolkin do
      IO.puts("mayan")
    end

    io = [sample.fixed, sample.fixed, sample.date, sample.fixed]
    doc = gen_doc(txt, spec.module, :as_fixed, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec as_fixed(unquote(spec.types.cal_date)) :: fixed
      def as_fixed(cal_date) when is_integer(cal_date), do: cal_date
      def as_fixed(cal_date), do: to_fixed(cal_date)
    end
  end

  defp gen_fun(:as_type, %{to_fixed: nil}), do: nil
  defp gen_fun(:as_type, %{name: name, sample: sample} = spec) do
    txt = "Returns a fixed day or #{name} date either as a fixed day or a #{name} date."
    io = [
      sample.fixed, sample.fixed,
      [:fields, sample.fixed, :fixed], sample.fixed,
      [:fields, sample.fixed, :date], sample.date,
      sample.date, sample.fixed,
      [:fields, sample.date, :fixed], sample.fixed,
      [:fields, sample.date, :date], sample.date
    ]
    doc = gen_doc(txt, spec.module, :as_type, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec as_type(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def as_type(cal_date, type \\ :fixed)
      def as_type(cal_date, :fixed) when is_integer(cal_date), do: cal_date
      def as_type(cal_date, :fixed), do: to_fixed(cal_date)
      def as_type(cal_date, :date) when is_tuple(cal_date), do: cal_date
      def as_type(cal_date, :date), do: from_fixed(cal_date)
    end
  end

  defp gen_fun(:from_date, %{name: name, sample: sample} = spec) do
    txt = "Converts the `other_date` of the `other_calendar` into the equivalent date of the #{name} calendar."
    io = [[sample.g_date, :gregorian], sample.date]
    doc = gen_doc(txt, spec.module, :from_date, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec from_date(tuple, module) :: unquote(spec.types.date)
      @spec from_date(tuple, module) :: {:error, String.t}
      def from_date(other_date, other_calendar) do
        other_calendar.to_date(other_date, unquote(spec.module))
      end
    end
  end

  defp gen_fun(:to_date, %{to_fixed: nil}), do: nil
  defp gen_fun(:to_date, %{name: name, sample: sample, to_fixed: _} = spec) do
    txt = """
    Converts a #{name} `date` into the equivalent date
    of the `other_calendar`.

    For the following example to work the Gregorian calendar must be available.
    """
    io = [[sample.date, :gregorian], sample.g_date]
    doc = gen_doc(txt, spec.module, :to_date, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec to_date(unquote(spec.types.date), module) :: tuple
      def to_date(date, other_calendar) do
        date |> to_fixed |> other_calendar.from_fixed
      end
    end
  end

  defp gen_fun(:from_jd, %{keyword: keyword}) when keyword == :jd, do: nil
  defp gen_fun(:from_jd, %{name: name, sample: sample} = spec) do
    txt = """
    Converts a Julian Day into the equivalent #{name} date.

    The Julian Day can be given as a tuple or by a Julian `day`.
    """
    jd = Calixir.jd_from_fixed(sample.fixed)
    io = [{jd}, sample.date, jd, sample.date]
    doc = gen_doc(txt, spec.module, :from_jd, io) # |> IO.puts
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec from_jd(tuple | number) :: unquote(spec.types.date)
      def from_jd({day}),
          do: from_jd(day)
      def from_jd(day),
          do: day |> Calixir.moment_from_jd |> trunc |> from_fixed
    end
  end

  defp gen_fun(:to_jd, %{keyword: :jd}), do: nil
  defp gen_fun(:to_jd, %{to_fixed: nil}), do: nil
  defp gen_fun(:to_jd, %{name: name, sample: sample, to_fixed: _} = spec) do
    jd = Calixir.jd_from_fixed(sample.fixed)

    txt1 = "Converts a #{name} date into the equivalent Julian Day."
    io1 = [sample.date, {jd}]
    doc1 = gen_doc(txt1, spec.module, :to_jd, io1)

    txt2 = "Converts a #{name} date given by `#{spec.field_string}` into the equivalent Julian Day."
    io2 = [[:fields] ++ sample.fields, {jd}]
    doc2 = gen_doc(txt2, spec.module, :to_jd, io2)

    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec to_jd(unquote(spec.types.date)) :: {number}
      def to_jd(cal_date) when is_tuple(cal_date) do
        {cal_date |> to_fixed |> Calixir.jd_from_fixed}
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec to_jd(unquote_splicing(spec.types.asts)) :: {number}
      def to_jd(unquote_splicing(spec.field_asts)) do
        to_jd({unquote_splicing(spec.field_asts)})
      end
    end
  end

  defp gen_fun(:from_rata_die, %{keyword: :rata_die}), do: nil
  defp gen_fun(:from_rata_die, %{name: name, sample: sample} = spec) do
    rata_die = sample.fixed
    txt = """
    Converts a RataDie date into the equivalent #{name} date.

    The RataDie date can be given as a tuple or by a RataDie `rd`.
    """
    io = [{rata_die}, sample.date, rata_die, sample.date]
    doc = gen_doc(txt, spec.module, :from_rata_die, io) # |> IO.puts
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec from_rata_die(tuple | integer) :: unquote(spec.types.date)
      def from_rata_die({rd}), do: rd |> from_fixed
      def from_rata_die(rd), do: rd |> from_fixed
    end
  end

  defp gen_fun(:to_rata_die, %{keyword: :rata_die}), do: nil
  defp gen_fun(:to_rata_die, %{to_fixed: nil}), do: nil
  defp gen_fun(:to_rata_die, %{name: name, sample: sample} = spec) do
    rata_die = sample.fixed

    txt1 = "Converts a #{name} date into the equivalent RataDie date."
    io1 = [sample.date, {rata_die}]
    doc1 = gen_doc(txt1, spec.module, :to_rata_die, io1)

    txt2 = "Converts a #{name} date given by `#{spec.field_string}` into the equivalent RataDie date."
    io2 = [[:fields] ++ sample.fields, {rata_die}]
    doc2 = gen_doc(txt2, spec.module, :to_rata_die, io2)
    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec to_rata_die(unquote(spec.types.date)) :: {integer}
      def to_rata_die(date) when is_tuple(date),
          do: {date |> to_fixed}

      @doc """
      #{unquote(doc2)}
      """
      @spec to_rata_die(unquote_splicing(spec.types.asts)) :: {integer}
      def to_rata_die(unquote_splicing(spec.field_asts)) do
        to_rata_die({unquote_splicing(spec.field_asts)})
      end
    end
  end

  defp gen_fun(:from_unix, %{keyword: :unix}), do: nil
  defp gen_fun(:from_unix, %{name: name, sample: sample} = spec) do
    unix = Calixir.unix_from_moment(sample.fixed) |> trunc
    txt = """
    Converts a Unix date into the equivalent #{name} date.

    The Unix date can be given as a tuple or by Unix `seconds`.
    """
    io = [{unix}, sample.date, unix, sample.date]
    doc = gen_doc(txt, spec.module, :from_unix, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec from_unix(tuple | integer) ::  unquote(spec.types.date)
      def from_unix({seconds} = unix_date),
          do: from_unix(seconds)
      def from_unix(seconds = unix_date),
          do: seconds |> Calixir.moment_from_unix |> trunc |> from_fixed
    end
  end

  defp gen_fun(:to_unix, %{keyword: :unix}), do: nil
  defp gen_fun(:to_unix, %{to_fixed: nil}), do: nil
  defp gen_fun(:to_unix, %{name: name, sample: sample} = spec) do
    unix = Calixir.unix_from_moment(sample.fixed) |> trunc
    txt1 = "Converts a #{name} date into the equivalent Unix date."
    io1 = [sample.date, {unix}]
    txt2 = "Converts a #{name} date given by `#{spec.field_string}` into the equivalent Unix date."
    io2 = [[:fields] ++ sample.fields, {unix}]
    doc1 = gen_doc(txt1, spec.module, :to_unix, io1)
    doc2 = gen_doc(txt2, spec.module, :to_unix, io2)
    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec to_unix(unquote(spec.types.date)) :: {integer}
      def to_unix(cal_date) when is_tuple(cal_date),
          do: {cal_date |> to_fixed |> Calixir.unix_from_moment |> trunc}

      @doc """
      #{unquote(doc2)}
      """
      @spec to_unix(unquote_splicing(spec.types.asts)) :: {integer}
      def to_unix(unquote_splicing(spec.field_asts)),
          do: to_unix({unquote_splicing(spec.field_asts)})
    end
  end


  # Date and Field Functions

  defp gen_fun(:fields, spec) do
    quote do
      unquote(gen_fun(:date, spec))
      unquote(gen_fun(:field_count, spec))
      unquote(gen_fun(:field_index, spec))
      unquote(gen_fun(:field_atom, spec))
      unquote(gen_fun(:field_atoms, spec))
      unquote(gen_fun(:single_fields, spec))
    end
  end

  defp gen_fun(:date, %{name: name, field_asts: args, sample: sample} = spec) do
    # Add [:fields] to sample.field_value in order to create
    # a unique list for gen_value pattern matching.
    txt = "Returns a #{name} date from its fields `#{spec.field_string}`."
    io = [[:fields] ++ sample.fields, sample.date]
    doc = gen_doc(txt, spec.module, :date, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec date(unquote_splicing(spec.types.asts)) :: t
      def date(unquote_splicing(args)), do: {unquote_splicing(args)}
    end
  end

  defp gen_fun(:field_atom, %{name: name, field_indices: field_indices, field_atoms: field_atoms} = spec) do
    txt = "Returns the name of the field atom in a #{name} date at `field_index`."
    io = Enum.map(field_indices, fn {k, v} -> [v, k] end) |> List.flatten
    doc = gen_doc(txt, spec.module, :field_atom, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec field_atom(integer) :: atom
      def field_atom(field_index) do
        Enum.at(unquote(field_atoms), field_index)
      end
    end
  end

  defp gen_fun(:field_atoms, %{name: name, field_atoms: field_atoms} = spec) do
    txt = "Returns a list of the field atoms (names) of a #{name} date."
    io = [nil, field_atoms]
    doc = gen_doc(txt, spec.module, :field_atoms, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec field_atoms :: [ atom ]
      def field_atoms, do: unquote(field_atoms)
    end
  end

  defp gen_fun(:field_count, %{name: name, field_count: field_count} = spec) do
    txt = "Returns the number of fields in a #{name} date"
    io = [nil, field_count]
    doc = gen_doc(txt, spec.module, :field_count, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec field_count :: integer
      def field_count, do: unquote(field_count)
    end
  end

  defp gen_fun(:field_index, %{name: name, field_indices: field_indices} = spec) do
    txt = "Returns the index (= position) of the `field_atom` in a #{name} date."
    io = Enum.map(field_indices, fn {k, v} -> [k, v] end) |> List.flatten
    doc = gen_doc(txt, spec.module, :field_index, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec field_index(atom) :: integer
      def field_index(field_atom) do
        unquote(field_indices)[field_atom]
      end
    end
  end

  defp gen_fun(:single_fields, %{name: name, sample: sample} = spec) do
    for {field, index} <- Enum.with_index(spec.field_atoms) do
      field_atom = Enum.at(spec.field_atoms, index)
      field_name = Enum.at(spec.field_names, index)
      field_value = elem(sample.date, index)
      txt = """
      Returns the `#{field}` field of a #{name} date.

      The `type` parameter determines the type of the returned #{field}:
      - `:atom` returns the internal name of #{field},
      - `:index` returns the position of the #{field} field within the date,
      - `:name` returns the common name of the #{field},
      - `:value` returns the value of the #{field} (*default*).
      """
      io = [
        sample.fixed, field_value,
        [:fields, sample.fixed, :atom], field_atom,
        [:fields, sample.fixed, :index], index,
        [:fields, sample.fixed, :name], field_name,
        [:fields, sample.fixed, :value], field_value,
        nil, nil,
        sample.date, field_value,
        [:fields, sample.date, :atom], field_atom,
        [:fields, sample.date, :index], index,
        [:fields, sample.date, :name], field_name,
        [:fields, sample.date, :value], field_value,
      ]
      doc = gen_doc(txt, spec.module, field, io)
      quote do
        @doc """
        #{unquote(doc)}
        """
        @spec unquote(field)(unquote(spec.types.cal_date), :atom | :index | :name | :value) ::
                :atom | integer | String.t | number
        def unquote(field)(cal_date, type \\ :value)
        def unquote(field)(cal_date, :atom),
            do: Enum.at(unquote(spec.field_atoms), unquote(index))
        def unquote(field)(cal_date, :index),
            do: unquote(index)
        def unquote(field)(cal_date, :name),
            do: Enum.at(unquote(spec.field_names), unquote(index))
        def unquote(field)(cal_date, :value),
            do: cal_date |> as_date |> elem(unquote(index))
      end
    end
  end


  # Year functions

  defp gen_fun(:add_years = f, %{name: name} = spec) do
    txt = """
    Adds the number of `years` to a fixed year or #{name} date.

    Because of the different lengths of years the result is calculated
    using the average length of a year; so the result will not always
    have the same day of the month as the base date.

    If `years` is negative, the years will be subtracted.
    """
    diff = 3
    io = gen_doctest_io(spec, spec.opts[f], diff)
    doc = gen_doc(txt, spec.module, :add_years, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec add_years(unquote(spec.types.cal_date), integer, :fixed | :date) :: unquote(spec.types.cal_date)
      def add_years(cal_date, years, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).(years) |> as_type(type)
      end
    end
  end

  defp gen_fun(:day_of_year = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the ordinal day number of the fixed day or #{name} date in the equivalent #{name} year."
    day_of_year = get_f(spec.opts[f]).(sample.date)
    io = [sample.fixed, day_of_year, sample.date, day_of_year]
    doc = gen_doc(txt, spec.module, :day_of_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec day_of_year(unquote(spec.types.cal_date)) :: integer
      def day_of_year(cal_date) do
        cal_date |> as_date |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_in_year = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the number of days in the #{name} year."
    days_minus = get_f(spec.opts[f]).(sample.year - 1)
    days = get_f(spec.opts[f]).(sample.year)
    io = [
      sample.year - 1, days_minus,
      sample.year, days
    ]
    doc = gen_doc(txt, spec.module, :days_in_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_in_year(unquote(spec.types.year)) :: integer
      def days_in_year(year) do
        year |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_remaining_in_year = f, %{name: name, sample: sample} = spec) do
    txt = """
    Returns the number of days remaing after a fixed day
    or a #{name} date in the equivalent #{name} year.
    """
    days_remaning = get_f(spec.opts[f]).(sample.date)
    io = [sample.fixed, days_remaning, sample.date, days_remaning]
    doc = gen_doc(txt, spec.module, :days_remaining_in_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_remaining_in_year(unquote(spec.types.cal_date)) :: integer
      def days_remaining_in_year(cal_date) do
        cal_date |> as_date |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:end_of_year = f, %{name: name, sample: sample} = spec) do
    txt = """
    Returns the last day of the #{name} `year` given by a fixed day
    or a #{name} date.
    """
    end_fixed = get_f(spec.opts[f]).(sample.year)
    end_date = get_f(spec.from_fixed).(end_fixed)
    io = [
      sample.fixed, end_fixed,
      [:fields, sample.fixed, :fixed], end_fixed,
      [:fields, sample.fixed, :date], end_date
    ]
    doc = gen_doc(txt, spec.module, :end_of_year, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec end_of_year(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_year(cal_date, type \\ :fixed) do
        {year, _, _} = as_date(cal_date)
        unquote(spec.opts[f]).(year) |> as_type(type)
      end
    end
  end

  defp gen_fun(:last_month_of_year = f, %{name: name, sample: sample, opts: %{months: months}} = spec) do
    txt = """
    Returns the last month of the #{name} `year` given by
    a fixed day or a #{name} date.

    The `type` parameter determines the type of the returned month:
    - `:atom` returns the internal name of the month,
    - `:integer` returns the number of the month (*default*),
    - `:name` returns the common name of the month.
    """
    n = get_f(spec.opts[f]).(sample.year)
    {end_atom, [end_number, end_name | _]} = Enum.at(months, n - 1)
    io = [
      sample.fixed, end_number,
      [:fields, sample.fixed, :atom], end_atom,
      [:fields, sample.fixed, :integer], end_number,
      [:fields, sample.fixed, :name], end_name,
      nil, nil,
      sample.date, end_number,
      [:fields, sample.date, :atom], end_atom,
      [:fields, sample.date, :integer], end_number,
      [:fields, sample.date, :name], end_name
    ]
    doc = gen_doc(txt, spec.module, :last_month_of_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec last_month_of_year(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def last_month_of_year(cal_date, type \\ :integer) do
        {year, _, _} = as_date(cal_date)
        n = unquote(spec.opts[f]).(year)
        {end_atom, [end_number, end_name | _]} = Enum.at(unquote(months), n - 1)
        case type do
          :atom -> end_atom
          :integer -> end_number
          :name -> end_name
        end
      end
    end
  end

  defp gen_fun(:leap_year? = f, %{name: name, sample: sample} = spec) do
    txt = "Returns `true` if the #{name} `year` is a leap year, otherwise `false`."
    io = [
      sample.year - 1, get_f(spec.opts[f]).(sample.year - 1),
      sample.year,     get_f(spec.opts[f]).(sample.year),
      sample.year + 1, get_f(spec.opts[f]).(sample.year + 1),
      sample.year + 2, get_f(spec.opts[f]).(sample.year + 2),
    ]
    doc = gen_doc(txt, spec.module, :leap_year?, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec leap_year?(unquote(spec.types.year)) :: boolean
      def leap_year?(year) do
        unquote(spec.opts[f]).(year)
      end
    end
  end

  defp gen_fun(:mean_year = f, %{name: name} = spec) do
    txt = "Returns the average length of a #{name} year."
    len = get_f(spec.opts[f]).()
    io = [nil, len]
    doc = gen_doc(txt, spec.module, :mean_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec mean_year :: number
      def mean_year, do: unquote(spec.opts[f]).()
    end
  end

  defp gen_fun(:months_in_year = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the number of months in the #{name} `year`."
    months = get_f(spec.opts[f]).(sample.year)
    io = [sample.fixed, months]
    doc = gen_doc(txt, spec.module, :months_in_year, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec months_in_year(unquote(spec.types.year)) :: integer
      def months_in_year(year) do
        unquote(spec.opts[f]).(year)
      end
    end
  end

  defp gen_fun(:new_year = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the first date of the #{name} `year`."
    fixed_new_year = get_f(spec.opts[f]).(sample.year)
    io = [
      sample.year, fixed_new_year,
      [:fields, sample.year, :fixed], fixed_new_year,
      [:fields, sample.year, :date], get_f(spec.from_fixed).(fixed_new_year)
    ]
    doc = gen_doc(txt, spec.module, :new_year, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec new_year(unquote(spec.types.year), :fixed | :date) :: unquote(spec.types.cal_date)
      def new_year(year, type \\ :fixed) do
        year |> unquote(spec.opts[f]).() |> as_type(type)
      end
    end
  end

  defp gen_fun(:start_of_year = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the first day of the #{name} `year` given by a fixed day or a #{name} date."
    start_fixed = get_f(spec.opts[f]).(sample.year)
    start_date = get_f(spec.from_fixed).(start_fixed)
    io = [
      sample.fixed, start_fixed,
      [:fields, sample.fixed, :fixed], start_fixed,
      [:fields, sample.fixed, :date], start_date
    ]
    doc = gen_doc(txt, spec.module, :start_of_year, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec start_of_year(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_year(cal_date, type \\ :fixed) do
        {year, _, _} = as_date(cal_date)
        unquote(spec.opts[f]).(year) |> as_type(type)
      end
    end
  end

  defp gen_fun(:year_end = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the last date of the #{name} `year`."
    year_end_fixed = get_f(spec.opts[f]).(sample.year + 1) - 1
    year_end_date = get_f(spec.from_fixed).(year_end_fixed)
    io = [
      sample.year, year_end_fixed,
      [:fields, sample.year, :fixed], year_end_fixed,
      [:fields, sample.year, :date], year_end_date
    ]
    doc = gen_doc(txt, spec.module, :year_end, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec year_end(unquote(spec.types.year), :fixed | :date) :: unquote(spec.types.cal_date)
      def year_end(year, type \\ :fixed) do
        unquote(spec.opts[f]).(year + 1) - 1 |> as_type(type)
      end
    end
  end


  # Quarter functions

  defp gen_fun(:quarters, %{module: module, name: name, opts: %{quarters: quarters}} = spec) do
    txt = """
    Returns a list of the quarters of the #{name} calendar.

    The `type` parameter determines the type of the returned quarters:
    - `:integer` returns the numbers of the quarters,
    - `:atom` returns the internal names of the quarters,
    - `:name` returns the common names of the quarters (*default*).
    """
    quarter_atoms = Keyword.keys(quarters)
    quarter_names = Enum.map(quarters, fn {_, [_, name | _]} -> name end)
    quarter_numbers = Enum.map(quarters, fn {_, [n, _ | _]} -> n end)
    io = [
      nil, quarter_names,
      :integer, quarter_numbers,
      :atom, quarter_atoms,
      :name, quarter_names
    ]
    doc = gen_doc(txt, module, :quarters, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec quarters :: [integer | atom | String.t]
      def quarters(type \\ :name)
      def quarters(:atom), do: unquote(quarter_atoms)
      def quarters(:name), do: unquote(quarter_names)
      def quarters(:integer), do: unquote(quarter_numbers)

      unquote_splicing(gen_fun(:single_quarters, spec))
    end
  end

  defp gen_fun(:add_quarters = f, %{name: name} = spec) do
    diff = 3
    txt = """
    Adds the number of `quarters` to a fixed day or #{name} `date`.

    If `quarters` is negative, the quarters will be subtracted.

    Because of the different lengths of quarters the result is calculated
    using the average length of a quarter; so day of the base date and
    the day of the result may vary.
    """
    io = gen_doctest_io(spec, spec.opts[f], diff)
    doc = gen_doc(txt, spec.module, :add_quarters, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec add_quarters(unquote(spec.types.cal_date), integer, :fixed | :date) :: unquote(spec.types.cal_date)
      def add_quarters(cal_date, quarters, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).(quarters) |> as_type(type)
      end
    end
  end

  defp gen_fun(:day_of_quarter = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the ordinal day number of a fixed day or #{name} date in the corresponding quarter."
    day = get_f(spec.opts[f]).(sample.fixed)
    io = [
      sample.fixed, day,
      sample.date, day
    ]
    doc = gen_doc(txt, spec.module, :day_of_quarter, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec day_of_quarter(unquote(spec.types.cal_date)) :: integer
      def day_of_quarter(cal_date) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_in_quarter = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the number of days in the quarter given by a fixed day or #{name} date."
    days = get_f(spec.opts[f]).(sample.fixed)
    io = [
      sample.fixed, days,
      sample.date, days
    ]
    doc = gen_doc(txt, spec.module, :days_in_quarter, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_in_quarter(unquote(spec.types.cal_date)) :: 90..92
      def days_in_quarter(cal_date) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_remaining_in_quarter = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the number of days remaining in the quarter given by a fixed day or #{name} date."
    days = get_f(spec.opts[f]).(sample.fixed)
    io = [
      sample.fixed, days,
      sample.date, days
    ]
    doc = gen_doc(txt, spec.module, :days_remaining_in_quarter, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_remaining_in_quarter(unquote(spec.types.cal_date)) :: 89..91
      def days_remaining_in_quarter(cal_date) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:end_of_quarter = f, %{name: name, sample: sample} = spec) do
    quarter = get_f(spec.opts[:quarter]).(sample.month)
    fixed = get_f(spec.opts[f]).(sample.year, quarter)
    date = get_f(spec.from_fixed).(fixed)

    txt1 = "Returns the last day of the quarter given by a fixed day or a #{name} date."
    io1 = [
      sample.fixed, fixed,
      [:fields, sample.fixed, :fixed], fixed,
      [:fields, sample.fixed, :date], date,
      nil, nil,
      sample.date, fixed,
      [:fields, sample.date, :fixed], fixed,
      [:fields, sample.date, :date], date,
    ]

    txt2 = "Returns the last day of the quarter given by the #{name} `year` and `quarter`."
    io2 = [
      [:fields, sample.year, quarter, :fixed], fixed,
      [:fields, sample.year, quarter, :date], date,
    ]
    doc1 = gen_doc(txt1, spec.module, :end_of_quarter, io1, :type_text)
    doc2 = gen_doc(txt2, spec.module, :end_of_quarter, io2, :type_text)
    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec end_of_quarter(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_quarter(cal_date, type \\ :fixed) do
        {year, _, _} = as_date(cal_date)
        end_of_quarter(year, quarter(cal_date), type)
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec end_of_quarter(unquote(spec.types.year), 1..4, :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_quarter(year, quarter, type) do
        unquote(spec.opts[f]).(year, quarter) |> as_type(type)
      end
    end
  end

  defp gen_fun(:mean_quarter = f, %{name: name} = spec) do
    txt = "Returns the average length of a #{name} quarter."
    len = get_f(spec.opts[f]).()
    io = [nil, len]
    doc = gen_doc(txt, spec.module, :mean_quarter, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec mean_quarter :: number
      def mean_quarter, do: unquote(spec.opts[f]).()
    end
  end

  defp gen_fun(:quarter = f, %{name: name, sample: sample} = spec) do
    quarter = get_f(spec.opts[f]).(sample.month)
    {atom, [number, quarter_name |_]} = Enum.at(spec.opts.quarters, quarter - 1)
    txt = """
    Returns the quarter of a fixed day or a #{name} date.

    The `type` parameter determines the type of the returned quarter:
    - `:atom` returns the atom of the quarter,
    - `:integer` returns the number of the quarter (*default*),
    - `:name` returns the name of the quarter.
    """
    io = [
      sample.fixed, number,
      [:fields, sample.fixed, :atom], atom,
      [:fields, sample.fixed, :integer], number,
      [:fields, sample.fixed, :name], quarter_name,
      sample.date, number,
      [:fields, sample.date, :atom], atom,
      [:fields, sample.date, :integer], number,
      [:fields, sample.date, :name], quarter_name,
    ]
    doc = gen_doc(txt, spec.module, :quarter, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec quarter(unquote(spec.types.cal_date)) :: 1..4 | atom | String.t
      def quarter(cal_date, type \\ :integer)
      def quarter(cal_date, :atom) do
        {atom, _} = Enum.at(unquote(spec.opts.quarters), quarter(cal_date) - 1)
        atom
      end
      def quarter(cal_date, :integer) do
        {_, m, _} = as_date(cal_date)
        unquote(spec.opts[f]).(m)
      end
      def quarter(cal_date, :name) do
        {_, [_, name | _]} = Enum.at(unquote(spec.opts.quarters), quarter(cal_date) - 1)
        name
      end
    end
  end

  defp gen_fun(:single_quarters, %{name: name, opts: %{quarters: quarters}} = spec) do
    # quarters = Enum.filter(quarters, fn {_, v} -> is_list(v) end)
    for {quarter, [n, quarter_name | _]} <- quarters do
      txt = """
      Returns the quarter `#{quarter}` of the `#{name}` calendar.

      The `type` parameter determines the type of the returned quarter:
      - `:integer` returns the number of the quarter (*default*),
      - `:name` returns the name of the quarter.
      """
      io = [
        nil, n,
        :integer, n,
        :name, quarter_name
      ]
      doc = gen_doc(txt, spec.module, quarter, io)
      quote do
        @doc """
        #{unquote(doc)}
        """
        @spec unquote(quarter)(:integer | :name) :: integer
        def unquote(quarter)(type \\ :integer)
        def unquote(quarter)(:integer), do: unquote(n)
        def unquote(quarter)(:name), do: unquote(quarter_name)
      end
    end
  end

  defp gen_fun(:start_of_quarter = f, %{name: name, sample: sample} = spec) do
    quarter = get_f(spec.opts[:quarter]).(sample.month)
    fixed = get_f(spec.opts[f]).(sample.year, quarter)
    date = get_f(spec.from_fixed).(fixed)

    txt1 = "Returns the first day of the quarter given by a fixed day or a #{name} date."
    io1 = [
      sample.fixed, fixed,
      [:fields, sample.fixed, :fixed], fixed,
      [:fields, sample.fixed, :date], date,
      nil, nil,
      sample.date, fixed,
      [:fields, sample.date, :fixed], fixed,
      [:fields, sample.date, :date], date,
    ]
    doc1 = gen_doc(txt1, spec.module, :start_of_quarter, io1, :type_text)

    txt2 = "Returns the first day of the quarter given by the #{name} `year` and `quarter`."
    io2 = [
      [:fields, sample.year, quarter, :fixed], fixed,
      [:fields, sample.year, quarter, :date], date,
    ]
    doc2 = gen_doc(txt2, spec.module, :start_of_quarter, io2, :type_text)
    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec start_of_quarter(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_quarter(cal_date, type \\ :fixed) do
        {year, _, _} = as_date(cal_date)
        start_of_quarter(year, quarter(cal_date), type)
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec start_of_quarter(unquote(spec.types.year), 1..4, :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_quarter(year, quarter, type) do
        unquote(spec.opts[f]).(year, quarter) |> as_type(type)
      end
    end
  end


  # Month functions

  defp gen_fun(:months, %{module: module, name: name, opts: %{months: months}} = spec) do
    txt = """
    Returns a list of the months of the #{name} calendar.

    The `type` parameter determines the type of the returned months:
    - `:integer` returns the numbers of the months,
    - `:atom` returns the internal names of the months,
    - `:name` returns the common names of the months (*default*).
    """
    month_atoms = Keyword.keys(months)
    month_names = Enum.map(months, fn {_, [_, name | _]} -> name end)
    month_numbers = Enum.map(months, fn {_, [n, _ | _]} -> n end)
    io = [
      nil, month_names,
      :integer, month_numbers,
      :atom, month_atoms,
      :name, month_names
    ]
    doc = gen_doc(txt, module, :months, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec months(:atom | :integer | :name) :: [integer | atom | String.t]
      def months(type \\ :name)
      def months(:atom), do: unquote(month_atoms)
      def months(:name), do: unquote(month_names)
      def months(:integer), do: unquote(month_numbers)

      unquote_splicing(gen_fun(:single_months, spec))
    end
  end

  defp gen_fun(:add_months = f, %{name: name} = spec) do
    txt = """
    Adds the number of `months` to a fixed day or #{name} `date`.

    If `months` is negative, the months will be subtracted.

    Because of the different lengths of months the result is calculated
    using the average length of a month; so the day of the base date and
    the day of the result may vary.
    """
    diff = 3
    io = gen_doctest_io(spec, spec.opts[f], diff)
    doc = gen_doc(txt, spec.module, :add_months, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec add_months(unquote(spec.types.cal_date), integer, :fixed | :date) :: unquote(spec.types.cal_date)
      def add_months(cal_date, months, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).(months) |> as_type(type)
      end
    end
  end

  defp gen_fun(:day_of_month = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the ordinal day number of a fixed day or #{name} date in the corresponding month."
    day = get_f(spec.opts[f]).(sample.fixed)
    io = [sample.fixed, day, sample.date, day]
    doc = gen_doc(txt, spec.module, :day_of_month, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec day_of_month(unquote(spec.types.cal_date)) :: integer
      def day_of_month(cal_date) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_in_month = f, %{name: name, sample: sample} = spec) do
    days = get_f(spec.opts[f]).(sample.year, sample.month)

    txt1 = "Returns the number of days in the month of a fixed day or #{name} date."
    io1 = [sample.fixed, days, sample.date, days]
    doc1 = gen_doc(txt1, spec.module, :days_in_month, io1)

    txt2 = "Returns the number of days in the month given by the #{name} `year` and `month`."
    io2 = [[:fields, sample.year, sample.month], days]
    doc2 = gen_doc(txt2, spec.module, :days_in_month, io2)
    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec days_in_month(unquote(spec.types.cal_date)) :: integer
      def days_in_month(cal_date) do
        {year, month, _} = as_date(cal_date)
        unquote(spec.opts[f]).(year, month)
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec days_in_month(unquote(spec.types.year), unquote(spec.types.month)) :: integer
      def days_in_month(year, month) do
        unquote(spec.opts[f]).(year, month)
      end
    end
  end

  defp gen_fun(:days_remaining_in_month = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the number of days remaing in the month after a fixed day or #{name} date."
    days = get_f(spec.opts[f]).(sample.date)
    io = [sample.fixed, days, sample.date, days]
    doc = gen_doc(txt, spec.module, :days_remaining_in_month, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_remaining_in_month(unquote(spec.types.cal_date)) :: integer
      def days_remaining_in_month(cal_date) do
        cal_date |> as_date |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:end_of_month = f, %{name: name, sample: sample} = spec) do
    fixed = get_f(spec.opts[f]).(sample.year, sample.month) |> get_f(spec.to_fixed).()
    date = get_f(spec.from_fixed).(fixed)

    txt1 = "Returns the last day of the month given by a fixed day or #{name} date."
    io1 = [
      sample.fixed, fixed,
      [:fields, sample.fixed, :fixed], fixed,
      [:fields, sample.fixed, :date], date,
      nil, nil,
      date, fixed,
      [:fields, sample.date, :fixed], fixed,
      [:fields, sample.date, :date], date,
    ]
    doc1 = gen_doc(txt1, spec.module, :end_of_month, io1, :type_text)

    txt2 = "Returns the last day of the month given by the #{name} `year` and `month`."
    io2 = [
      [:fields, sample.year, sample.month, :fixed], fixed,
      [:fields, sample.year, sample.month, :date], date,
    ]
    doc2 = gen_doc(txt2, spec.module, :end_of_month, io2, :type_text)

    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec end_of_month(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_month(cal_date, type \\ :fixed) do
        {year, month, _} = as_date(cal_date)
        unquote(spec.opts[f]).(year, month) |> as_type(type)
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec end_of_month(unquote(spec.types.year), unquote(spec.types.month), :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_month(year, month, type) do
        unquote(spec.opts[f]).(year, month) |> as_type(type)
      end
    end
  end

  defp gen_fun(:mean_month = f, %{name: name} = spec) do
    len = get_f(spec.opts[f]).()
    txt = "Returns the average length of a #{name} month."
    io = [nil, len]
    doc = gen_doc(txt, spec.module, :mean_month, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec mean_month :: number
      def mean_month, do: unquote(spec.opts[f]).()
    end
  end

  defp gen_fun(:single_months, %{name: name, opts: %{months: months}} = spec) do
    months = Enum.filter(months, fn {_, v} -> is_list(v) end)
    for {month, [pos, month_name | _]} <- months do
      txt = """
      Returns the month `#{month}` of the `#{name}` calendar.

      The `type` parameter determines the type of the returned month:
      - `:integer` returns the number of the month (*default*),
      - `:name` returns the name of the month.
      """
      io = [
        nil, pos,
        :integer, pos,
        :name, month_name
      ]
      doc = gen_doc(txt, spec.module, month, io)
      quote do
        @doc """
        #{unquote(doc)}
        """
        @spec unquote(month)(:integer | :name) :: integer
        def unquote(month)(type \\ :integer)
        def unquote(month)(:integer), do: unquote(pos)
        def unquote(month)(:name), do: unquote(month_name)
      end
    end
  end

  defp gen_fun(:start_of_month = f, %{name: name, sample: sample} = spec) do
    date = get_f(spec.opts[f]).(sample.year, sample.month)
    fixed = get_f(spec.to_fixed).(date)

    txt1 = "Returns the first day of the month given by a fixed day or #{name} date."
    io1 = [
      fixed, fixed,
      [:fields, fixed, :fixed], fixed,
      [:fields, fixed, :date], date,
      nil, nil,
      date, fixed,
      [:fields, date, :fixed], fixed,
      [:fields, date, :date], date,
    ]
    doc1 = gen_doc(txt1, spec.module, :start_of_month, io1, :type_text)

    txt2 = "Returns the first day of the month given by the #{name} `year` and `month`."
    io2 = [
      [:fields, sample.year, sample.month, :fixed], fixed,
      [:fields, sample.year, sample.month, :date], date,
    ]
    doc2 = gen_doc(txt2, spec.module, :start_of_month, io2, :type_text)

    quote do
      @doc """
      #{unquote(doc1)}
      """
      @spec start_of_month(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_month(cal_date, type \\ :fixed) do
        {year, month, _} = as_date(cal_date)
        start_of_month(year, month, type)
      end

      @doc """
      #{unquote(doc2)}
      """
      @spec start_of_month(unquote(spec.types.year), unquote(spec.types.month), :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_month(year, month, type) do
        unquote(spec.opts[f]).(year, month) |> as_type(type)
      end
    end
  end


  # Weekday functions

  defp gen_fun(:weekdays, %{module: module, name: name, opts: %{weekdays: weekdays}} = spec) do
    txt = """
    Returns a list of the weekdays of the #{name} calendar.

    The `type` parameter determines the type of the returned weekdays:
    - `:integer` returns the numbers of the weekdays,
    - `:atom` returns the internal names of the weekdays,
    - `:name` returns the common names of the weekdays (*default*).
    """
    weekday_atoms = Keyword.keys(weekdays)
    weekday_names = Enum.map(weekdays, fn {_, [_, name | _]} -> name end)
    weekday_numbers = Enum.map(weekdays, fn {_, [n, _ | _]} -> n end)
    io = [
      nil, weekday_names,
      :integer, weekday_numbers,
      :atom, weekday_atoms,
      :name, weekday_names
    ]
    doc = gen_doc(txt, module, :weekdays, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec weekdays :: [integer | atom | String.t]
      def weekdays(type \\ :name)
      def weekdays(:atom), do: unquote(weekday_atoms)
      def weekdays(:integer), do: unquote(weekday_numbers)
      def weekdays(:name), do: unquote(weekday_names)

      unquote_splicing(gen_fun(:single_weekdays, spec))
    end
  end

  defp gen_fun(:add_weeks = f, %{name: name} = spec) do
    txt = """
    Adds the number of `weeks` to a fixed day or #{name} `date`.

    If `weeks` is negative, the weeks will be subtracted.
    """
    diff = 3
    io = gen_doctest_io(spec, spec.opts[f], diff)
    doc = gen_doc(txt, spec.module, :add_weeks, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec add_weeks(unquote(spec.types.cal_date), integer, :fixed | :date) :: unquote(spec.types.cal_date)
      def add_weeks(cal_date, weeks, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).(weeks) |> as_type(type)
      end
    end
  end

  defp gen_fun(:day_of_week = f, %{name: name, sample: sample} = spec) do
    day = get_f(spec.opts[f]).(sample.fixed)
    txt = "Returns the ordinal day number of a fixed day or #{name} date in the corresponding week."
    io = [
      sample.fixed, day,
      sample.date, day
    ]
    doc = gen_doc(txt, spec.module, :day_of_week, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec day_of_week(unquote(spec.types.cal_date)) :: integer
      def day_of_week(cal_date) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).()
      end
    end
  end

  defp gen_fun(:days_in_week = f, %{name: name} = spec) do
    txt = "Returns the number of days in a week of the #{name} calendar."
    days = get_f(spec.opts[f]).()
    io = [nil, days]
    doc = gen_doc(txt, spec.module, :days_in_week, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec days_in_week :: integer
      def days_in_week, do: unquote(spec.opts[f]).()
    end
  end

  defp gen_fun(:end_of_week = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the end of the week of the fixed day or #{name} date."
    fixed = get_f(spec.opts[f]).(sample.fixed)
    date = get_f(spec.from_fixed).(fixed)
    io = [
      sample.fixed, fixed,
      [:fields, sample.fixed, :fixed], fixed,
      [:fields, sample.fixed, :date], date,
      nil, nil,
      sample.date, fixed,
      [:fields, sample.date, :fixed], fixed,
      [:fields, sample.date, :date], date
    ]
    doc = gen_doc(txt, spec.module, :end_of_week, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec end_of_week(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def end_of_week(cal_date, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).() |> as_type(type)
      end
    end
  end

  defp gen_fun(:single_weekdays, %{name: name, opts: %{weekdays: weekdays}} = spec) do
    weekdays = Enum.filter(weekdays, fn {_, v} -> is_list(v) end)
    for {weekday, [pos, weekday_name | _]} <- weekdays do
      txt = """
      Returns the weekday `#{weekday}` of the `#{name}` calendar.

      The `type` parameter determines the type of the returned weekday:
      - `:integer` returns the number of the weekday (*default*),
      - `:name` returns the name of the weekday.
      """
      io = [
        nil, pos,
        :integer, pos,
        :name, weekday_name
      ]
      doc = gen_doc(txt, spec.module, weekday, io)
      quote do
        @doc """
        #{unquote(doc)}
        """
        @spec unquote(weekday)(:integer | :name) :: integer
        def unquote(weekday)(type \\ :integer)
        def unquote(weekday)(:integer), do: unquote(pos)
        def unquote(weekday)(:name), do: unquote(weekday_name)
      end
    end
  end

  defp gen_fun(:start_of_week = f, %{name: name, sample: sample} = spec) do
    txt = "Returns the start of the week of the fixed day or #{name} date."
    fixed = get_f(spec.opts[f]).(sample.fixed)
    date = get_f(spec.from_fixed).(fixed)
    io = [
      sample.fixed, fixed,
      [:fields, sample.fixed, :fixed], fixed,
      [:fields, sample.fixed, :date], date,
      nil, nil,
      sample.date, fixed,
      [:fields, sample.date, :fixed], fixed,
      [:fields, sample.date, :date], date
    ]
    doc = gen_doc(txt, spec.module, :start_of_week, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec start_of_week(unquote(spec.types.cal_date), :fixed | :date) :: unquote(spec.types.cal_date)
      def start_of_week(cal_date, type \\ :fixed) do
        cal_date |> as_fixed |> unquote(spec.opts[f]).() |> as_type(type)
      end
    end
  end

  defp gen_fun(:weekday = f, %{name: name, sample: sample, opts: %{weekdays: weekdays}} = spec) do
    txt = """
    Returns the weekday of a fixed day or a #{name} date.

    The `type` parameter determines the type of the returned weekday:
    - `:atom` returns the internal name of weekday,
    - `:integer` returns the number of the weekday (*default*),
    - `:name` returns the common name of the weekday.
    """
    weekday = get_f(spec.opts[f]).(sample.fixed)
    {weekday_atom, [weekday_pos, weekday_name | _]} = Enum.at(weekdays, weekday)
    io = [
      sample.fixed, weekday_pos,
      [:fields, sample.fixed, :integer], weekday_pos,
      [:fields, sample.fixed, :atom], weekday_atom,
      [:fields, sample.fixed, :name], weekday_name,
      nil, nil,
      sample.date, weekday_pos,
      [:fields, sample.date, :integer], weekday_pos,
      [:fields, sample.date, :atom], weekday_atom,
      [:fields, sample.date, :name], weekday_name,
    ]
    doc = gen_doc(txt, spec.module, :weekday, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec weekday(unquote(spec.types.cal_date), :atom | :integer | :name) :: integer | atom | String.t
      def weekday(cal_date, type \\ :integer) do
        weekday = cal_date |> as_fixed |> unquote(spec.opts[f]).()
        {weekday_atom, [weekday_pos, weekday_name | _]} = Enum.at(unquote(weekdays), weekday)
        case type do
          :atom -> weekday_atom
          :integer -> weekday_pos
          :name -> weekday_name
        end
      end
    end
  end


  # Holiday functions

  defp gen_fun(:holidays,  %{module: module, name: name, opts: %{holidays: holidays}} = spec) do
    txt = """
    Returns a list of the holidays of the #{name} calendar.

    The `type` parameter determines the type of the returned holidays:
    - `:atom` returns the internal names of the holidays,
    - `:name` returns the common names of the holidays (*default*).
    """
    holiday_atoms = Enum.map(holidays, fn {atom, _} -> atom end)
    holiday_names = Enum.map(holidays, fn {_, [name | _]} -> name end)
    io = [
      nil, holiday_names,
      :atom, holiday_atoms,
      :name, holiday_names
    ]
    doc = gen_doc(txt, module, :holidays, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec holidays :: [atom | String.t]
      def holidays(type \\ :name)
      def holidays(:atom), do: unquote(holiday_atoms)
      def holidays(:name), do: unquote(holiday_names)

      unquote_splicing(gen_fun(:single_holidays, spec))
    end
  end

  defp gen_fun(:single_holidays, %{name: name, sample: sample, opts: %{holidays: holidays}} = spec) do
    for {holiday, [holiday_name | _]} <- holidays do
      txt = """
      Returns the fixed date of `#{holiday_name}` of the
      #{name} calendar in the given `gregorian_year` or `[]`,
      if there is no such holiday in that year.
      """
      result = "Calixir.#{holiday}(#{sample.g_year})" |> Code.eval_string |> elem(0)
      date = get_greg(result)
      io = [sample.g_year, date]
      doc = gen_doc(txt, spec.module, holiday, io, :type_text)
      quote do
        @doc """
        #{unquote(doc)}
        """
        @spec unquote(holiday)(Gregorian.gregorian_year) :: unquote(spec.types.cal_date)
        def unquote(holiday)(gregorian_year) do
          result = Calixir.unquote(holiday)(gregorian_year)
          if result == [] do
            []
          else
            if is_list(result) do
              # Calixir.gregorian_from_fixed(hd(result))
              hd(result)
            else
              # Calixir.gregorian_from_fixed(result)
              result
            end
          end
        end
      end
    end
  end


  # Calixir API functions

  defp gen_fun(:calixir_api,  %{module: module, name: name, opts: %{calixir_api: calixir_api}}) do
    txt = """
    Returns a list of the Calixir functions of the #{name} calendar.

    The `type` parameter determines the type of the returned Calixir function:
    - `:atom` returns the internal names of the functions (*default*),
    - `:spec` returns the complete specifications of the functions.
    """
    atoms = Enum.map(calixir_api, fn {atom, _} -> atom end)
    fun_specs = Enum.map(calixir_api, fn {atom, [args | _]} -> [atom, args] end)
    io = [
      nil, atoms,
      :atom, atoms,
      :fun_specs, fun_specs
    ]
    doc = gen_doc(txt, module, :calixir_api, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec calixir_api :: [atom | list]
      def calixir_api(type \\ :atom)
      def calixir_api(:atom), do: unquote(atoms)
      def calixir_api(:fun_specs), do: unquote(fun_specs)
    end
  end


  # Calculations

  defp gen_fun(:calculations, %{to_fixed: nil}), do: nil
  defp gen_fun(:calculations, spec) do
    quote do
      unquote(gen_fun(:add_days, spec))
      unquote(gen_fun(:date_diff, spec))
      unquote(gen_fun(:range, spec))
      unquote(gen_fun(:start_of_calendar, spec))
      unquote(gen_fun(:start_of_day, spec))
      unquote(gen_fun(:today, spec))
    end
  end

  defp gen_fun(:add_days, %{name: name} = spec) do
    txt = """
    Adds the number of `days` to a fixed day or #{name} date.

    If `days` is negative, the days will be subtracted.
    """
    f = quote(do: fn fixed, days -> fixed + days end)
    diff = 100
    io = gen_doctest_io(spec, f, diff)
    doc = gen_doc(txt, spec.module, :add_days, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec add_days(unquote(spec.types.cal_date), integer, :fixed | :date) :: unquote(spec.types.cal_date)
      def add_days(cal_date, days, type \\ :fixed) do
        cal_date |> as_fixed |> Kernel.+(days) |> as_type(type)
      end
    end
  end

  defp gen_fun(:date_diff, %{name: name} = spec) do
    txt = """
    Returns the difference (= number of days) between two #{name} dates.

    The dates can be given as fixed days or #{name} dates in arbitrary
    combination. The difference is calculated by `date2 - date1`.

    If `cal_date2` is larger (= later) than `cal_date1` the result is positive.

    If `cal_date2` is smaller (= earlier) than `cal_date1` the result is negative.
    """
    {fixed1, fixed2, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, fixed1, fixed2], 100,
      [:fields, fixed2, fixed1], -100,
      [:fields, date1, date2], 100,
      [:fields, date2, date1], -100,
      [:fields, fixed1, date2], 100,
      [:fields, date1, fixed2], 100,
    ]
    doc = gen_doc(txt, spec.module, :date_diff, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec date_diff(unquote(spec.types.cal_date), unquote(spec.types.cal_date)) :: integer
      def date_diff(cal_date1, cal_date2) do
        as_fixed(cal_date2) - as_fixed(cal_date1)
      end
    end
  end

  defp gen_fun(:range, %{name: name} = spec) do
    txt = "Returns the distance between two  #{name} dates as a range of fixed days."
    {fixed1, fixed2, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date2], fixed1..fixed2
    ]
    doc = gen_doc(txt, spec.module, :range, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec range(unquote(spec.types.date), unquote(spec.types.date)) :: integer
      def range(date1, date2), do: as_fixed(date1)..as_fixed(date2)
    end
  end

  defp gen_fun(:start_of_calendar, %{start_of_calendar: nil}), do: nil
  defp gen_fun(:start_of_calendar = f, %{name: name} = spec) do
    txt = "Returns the first official use of the #{name} calendar."
    fixed = get_f(spec.opts[f]).()
    date = get_f(spec.from_fixed).(fixed)
    io = [
      nil, fixed,
      :fixed, fixed,
      :date, date
    ]
    doc = gen_doc(txt, spec.module, :start_of_calendar, io, :type_text)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec start_of_calendar(:fixed | :date) :: term
      def start_of_calendar(type \\ :fixed) do
        unquote(spec.opts[f]).() |> as_type(type)
      end
    end
  end

  defp gen_fun(:start_of_day, %{name: name, start_of_day: sod} = spec) do
    txt = """
    Returns the start of the day in the #{name} calendar.

    Possible return values are:
    - `:midnight`,
    - `:noon`,
    - `:sunrise`,
    - `:sunset`,
    """
    io = [nil, sod]
    doc = gen_doc(txt, spec.module, :start_of_day, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec start_of_day :: :midnight | :sunset | :sunrise | :noon
      def start_of_day do
        unquote(sod)
      end
    end
  end

  defp gen_fun(:today, %{to_fixed: nil}), do: nil
  defp gen_fun(:today, %{name: name, sample: sample} = spec) do
    txt = """
    Returns the current date either as a fixed day or a #{name} date.

    (This cannot be doctested, because `today` is a moving target.)
    """
    io = [
      nil, sample.fixed,
      :fixed, sample.fixed,
      :date, sample.date
    ]
    doc = gen_doc(txt, spec.module, :today, io, :type_text) |> String.replace("iex>", "")
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec today(:fixed | :date) :: unquote(spec.types.cal_date)
      def today(type \\ :fixed) do
        Date.utc_today() |> Date.to_erl() |> as_type(type)
      end
    end
  end


  # Comparisons

  defp gen_fun(:comparisons, %{to_fixed: nil}), do: nil
  defp gen_fun(:comparisons, spec) do
    quote do
      unquote(gen_fun(:gt, spec))
      unquote(gen_fun(:ge, spec))
      unquote(gen_fun(:eq, spec))
      unquote(gen_fun(:le, spec))
      unquote(gen_fun(:lt, spec))
      unquote(gen_fun(:compare, spec))
    end
  end

  defp gen_fun(:eq, %{name: name} = spec) do
    txt = "Returns true if #{name} `date1` is equal #{name} `date2`, otherwise false."
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], true,
      [:fields, date1, date2], false,
      [:fields, date2, date1], false
    ]
    doc = gen_doc(txt, spec.module, :eq, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec eq(unquote(spec.types.date), unquote(spec.types.date)) :: boolean
      def eq(date1, date2), do: as_fixed(date1) == as_fixed(date2)
    end
  end

  defp gen_fun(:ge, %{name: name} = spec) do
    txt = "Returns true if #{name} `date1` is greater (= later) than or equal #{name} `date2`, otherwise false."
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], true,
      [:fields, date1, date2], false,
      [:fields, date2, date1], true
    ]
    doc = gen_doc(txt, spec.module, :ge, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec ge(unquote(spec.types.date), unquote(spec.types.date)) :: boolean
      def ge(date1, date2), do: as_fixed(date1) >= as_fixed(date2)
    end
  end

  defp gen_fun(:gt, %{name: name} = spec) do
    txt = "Returns true if #{name} `date1` is greater (= later) than #{name} `date2`, otherwise false."
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], false,
      [:fields, date1, date2], false,
      [:fields, date2, date1], true
    ]
    doc = gen_doc(txt, spec.module, :gt, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec gt(unquote(spec.types.date), unquote(spec.types.date)) :: boolean
      def gt(date1, date2), do: as_fixed(date1) > as_fixed(date2)
    end
  end

  defp gen_fun(:le, %{name: name} = spec) do
    txt = "Returns true if #{name} `date1` is smaller (= earlier) than or equal #{name} `date2`, otherwise false."
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], true,
      [:fields, date1, date2], true,
      [:fields, date2, date1], false
    ]
    doc = gen_doc(txt, spec.module, :le, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec le(unquote(spec.types.date), unquote(spec.types.date)) :: boolean
      def le(date1, date2), do: as_fixed(date1) <= as_fixed(date2)
    end
  end

  defp gen_fun(:lt, %{name: name} = spec) do
    txt = "Returns true if #{name} `date1` is smaller (= earlier) than #{name} `date2`, otherwise false."
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], false,
      [:fields, date1, date2], true,
      [:fields, date2, date1], false
    ]
    doc = gen_doc(txt, spec.module, :lt, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec lt(unquote(spec.types.date), unquote(spec.types.date)) :: boolean
      def lt(date1, date2), do: as_fixed(date1) < as_fixed(date2)
    end
  end

  defp gen_fun(:compare, %{name: name} = spec) do
    txt = """
    Compares two #{name} dates and returns...
    - `:lt` if `date1` is smaller (= earlier) than `date2`,
    - `:eq` if `date1` is equal `date2`,
    - `:gt` if `date1` is larger (= later) than `date2`.
    """
    {_, _, date1, date2} = get_compare_dates(spec)
    io = [
      [:fields, date1, date1], :eq,
      [:fields, date1, date2], :lt,
      [:fields, date2, date1], :gt
    ]
    doc = gen_doc(txt, spec.module, :compare, io)
    quote do
      @doc """
      #{unquote(doc)}
      """
      @spec compare(unquote(spec.types.date), unquote(spec.types.date)) :: :lt | :eq | :gt
      def compare(date1, date2) do
        cond do
          lt(date1, date2) -> :lt
          gt(date1, date2) -> :gt
          eq(date1, date2) -> :eq
        end
      end
    end
  end

  
  # Catch-all function

  defp gen_fun(function, %{keyword: keyword} = _spec) do
    IO.puts("=== #{function} === missing for: #{keyword}")
  end


  ##########################################################
  # Helpers
  ##########################################################

  def atomize(s) do
    Regex.replace(~r|([A-Z][a-z]+)|, s, fn _, x -> "_#{x}" end)
    |> String.trim_leading("_")
    |> String.downcase
    |> String.to_atom
  end

  defp get_f(function), do: function |> Code.eval_quoted |> elem(0)

  defp get_compare_dates(%{sample: sample} = spec, diff \\ 100) do
    { sample.fixed,
      sample.fixed + diff,
      sample.date,
      get_f(spec.from_fixed).(sample.fixed + diff)
    }
  end

  defp gen_doctest_io(%{sample: sample} = spec, function, diff) do
    f = get_f(function)
    from_fixed = get_f(spec.from_fixed)
    fixed = sample.fixed
    date = sample.date
    fixed_plus = f.(fixed, diff)
    fixed_minus = f.(fixed, -diff)
    date_plus = from_fixed.(fixed_plus)
    date_minus = from_fixed.(fixed_minus)
    [
      [:fields, fixed, diff], fixed_plus,
      [:fields, fixed, -diff], fixed_minus,
      nil, nil,
      [:fields, fixed, diff, :fixed], fixed_plus,
      [:fields, fixed, -diff, :fixed], fixed_minus,
      nil, nil,
      [:fields, fixed, diff, :date], date_plus,
      [:fields, fixed, -diff, :date], date_minus,
      nil, nil,
      [:fields, date, diff], fixed_plus,
      [:fields, date, -diff], fixed_minus,
      nil, nil,
      [:fields, date, diff, :fixed], fixed_plus,
      [:fields, date, -diff, :fixed], fixed_minus,
      nil, nil,
      [:fields, date, diff, :date], date_plus,
      [:fields, date, -diff, :date], date_minus,
    ]
  end

  defp get_greg([]), do: []
  defp get_greg(value) when is_list(value), do: value |> hd |> get_greg
  defp get_greg(value), do: Calixir.gregorian_from_fixed(value)

end