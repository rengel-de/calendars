# Calendars

`Calendars` is a collection of calendars that is based on the calendars contained 
in the 4th edition of the book (from here on referenced as _DR4_)
     
[Calendrical Calculations - The Ultimate Edition](https://www.cs.tau.ac.il/~nachum/calendar-book/fourth-edition/)  
by Edward M. Reingold and Nachum Dershowitz  
Cambridge University Press, 2018
 
The calendars are just thin wrappers around the [Calixir](https://hex.pm/packages/calixir) 
package. `Calixir` is a port of the Lisp calendar software `calendrica-4.0.cl` that comes
with DR4.

## Installation

The package is [available in Hex](https://packages/calendars) and can be installed
by adding `calendars` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:calendars, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation has been generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). The docs can be found 
at [https://hexdocs.pm/calendars](https://hexdocs.pm/calendars).

## Copyright and License

The Calixir library and its sample data are made public under the following conditions:

- The code and data can be used for personal use.
- The code can data be used for demonstrations purposes.
- Non-profit reuse with attribution is fine.
- Commercial use of the algorithms should be licensed and are not allowed from this library.

The permissions above are granted **as long as attribution is given to the authors of the 
original algorithms, Nachum Dershowitz and Edward M. Reingold**.

## About the Calendars

In this software, I distinguish __monotonous__ and __cyclical__ 
calendars:

A __monotonous__ calendar has a distinct origin or _epoch_ and 
stretches from there (potentially) to negative and positive infinity. 
All its values or _dates_ are distinct. The most common example is 
probably the `Gregorian` calendar.

A __cyclical__ calendar does not have an origin. It consists of periods or 
_cycles_ of the same length that return indefinitely. All the values or 
dates within one cycle are unique, but they return from cycle to cycle, 
so that it is not possible, to assign such a value to a distinct point 
in time. The most common example is probably the week with its weekdays. 

One could argue that cycles shouldn't be called 'calendars'. But that's the 
way they are treated in DR4. So I'm using the attributes _monotonous_ and 
_cyclical_ to distinguish calendars if and when it matters.

## About the Calendar Conversions

To facilitate the conversion of calendar dates between different calendars 
is one of the main functions of `Calendars`. To minimize the number of conversion  
functions to be written the common star pattern is used. Each conversion from 
one calendar to another is split in two steps:

1. Conversion of the date of the source calendar into a common 'canonical' date.
2. Conversion of the 'canonical' date into a date of the target calendar.

The 'canonical' date is the central hub for all conversions.
Thus, every calendar must only know how to convert its dates into and from 
the corresponding date of some 'canonical' calendar. Prime candidates for a 
'canonical' calendar are calendars that don't have an internal structure of 
their own (i.e. a hierarchy of units like 'year', 'month', and 'day'), but 
work with one unit only (usually the 'day').   
  
One candidate could have been the Julian Day number (`JD` in this package) or
variants thereof (i.e. the Modified Julian Day number, `MJD`). But the 
authors of DR4 have chosen to create their own 'canonical' calendar,
the `RataDie` calendar, that is closely aligned with the `Gregorian` calendar.

The base unit of the `RataDie` is the _day_. Throughout the book (DR4) a  
variable containing a day of this calendar is referred by the term _date_ 
while functions working with such a variable use the term _fixed_, i.e.:

```
gregorian-from-fixed(date) = [year, month, day]  # DR4 62 (2.23)
``` 

I consider this unfortunate, because _date_ is a broader term that can be 
(and commonly is) used for all calendars. So throughout `Calixir` and `Calendars`, 
I use the term _fixed_ instead of _date_ for dates of the `RataDie` calendar, i.e.:

```elixir
gregorian_from_fixed(fixed) = {year, month, day}  # DR4 62 (2.23)
``` 
    
The `fixed` dates of the `RataDie` calendar form the basis for all calendar 
conversions in `Calixir` and `Calendars`. 
- Both, **monotonous** and **cyclical** calendars must have a `from_fixed` function 
that converts a `fixed` date into their own corresponding dates. 

- In addition, **monotonous** calendars must have a `to_fixed` function 
that converts their own dates into the corresponding `fixed` dates. 

Additionally, the calendars have two pairs of conversion functions that are just
syntactic sugar:

- `from_jd` and `to_jd` for Julian Day numbers
- `from_date` and `to_date` for direct conversions from and into another calendar.

## The WHYs and the WHY-NOTs

In this section, I detail some of my decisions why this software is how it is. 
It might help you to understand its structure. 

Before I published the `Calixir` and `Calendars` packages I tried 
various ways to refactor the monolithic `calendrica-4.0` Lisp package, but always 
ended in some form of 'dependency hell'. So I finally decided to keep `Calixir` 
as a single monolithic block and implement the calendars as thin wrappers around 
`Calixir`.

This approach offers an additional advantage: The `Calendars` collection can be 
extended just by adding calendar modules to `lib/calendars`. Additional calendars 
can but don't need to reference `Calixir`. To allow for conversions they only 
have to implement their own `from_fixed`, `to_fixed`, `from_date`, and `to_date` 
functions. `from_jd` and `to_jd` are not required.

If you need additional functionality for a calendar create a new module and use  
existing functionality by creating `defdelegate`s to the base calendar or `Calixir`.   

## Usage

Here is an example for the interactive use of `Calendars`:

```
D:\Projects\calendars>iex -S mix
Interactive Elixir (1.9.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> alias Calendars.Gregorian
Calendars.Gregorian
iex(2)> g_date = Gregorian.date(2020, 7, 24)
{2020, 7, 24}
iex(3)> fixed = Gregorian.to_fixed(g_date)
737630
iex(4)> alias Calendars.Julian
Calendars.Julian
iex(5)> j_date = Julian.from_fixed(fixed)
{2020, 7, 11}
iex(6)> Julian.to_date(j_date, Gregorian)
{2020, 7, 24}
```
   
The same example in a module:

```elixir
defmodule ExampleConverter do

  alias Calendars.{Gregorian, Julian}

  def gregorian_to_julian_conventional do
    g_date = Gregorian.date(2020, 7, 24)  # create Gregorian date 
    fixed = Gregorian.to_fixed(g_date)    # convert Gregorian date to fixed
    j_date = Julian.from_fixed(fixed)     # convert fixed into Julian date
    Julian.to_date(j_date, Gregorian)     # should return {2020, 7, 24}
  end
end
```
Using a pipeline:

```elixir
defmodule PipelineConverter do

  alias Calendars.{Gregorian, Julian, Hebrew}

  def check_pipeline do
    gregorian_date = Gregorian.date(2020, 7, 24)

    if (gregorian_date
        |> Gregorian.to_fixed
        |> Julian.from_fixed
        |> Julian.to_fixed
        |> Gregorian.from_fixed) == gregorian_date,
    do:   {:ok, "Pipline works."},
    else: {:error, "Pipline is broken."}   
  end

  def check_pipeline_using_from_date do
    gregorian_date = Gregorian.date(2020, 7, 28)
    
    if (gregorian_date
        |> Julian.from_date(Gregorian)
        |> Hebrew.from_date(Julian)
        |> Gregorian.from_Hebrew()) == gregorian_date,
    do:   {:ok, "Pipline works."},
    else: {:error, "Pipline is broken."}   
  end

  def check_pipeline_using_to_date do
    gregorian_date = Gregorian.date(2020, 7, 28)
    
    if (gregorian_date
        |> Gregorian.to_date(Julian)
        |> Julian.to_date(Hebrew)
        |> Hebrew.to_date(Gregorian)) == gregorian_date,
    do:   {:ok, "Pipline works."},
    else: {:error, "Pipline is broken."}   
  end

end
``` 

Of course, this works for any pair of monotonous calendars.


  