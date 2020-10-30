defmodule LuniSolar do
  @moduledoc """
  Documentation for the LuniSolar calendar.

  This is not a calendar proper but rather a collection of
  luni-solar functions that don't fit properly into one of the
  other calendars.

  These functions are used to calculate the astronomical values
  in the sample data tables on the pages 452 and 453 of DR4
  as well as the calculation of the astronomical easter.

  This module demonstrates how one can create topic-specific
  modules by just using `defdelegate` functions that refer to
  their counterparts in `Calixir`.
  """

  @doc """
  Ephemeris Correction.
  """
  defdelegate ephemeris_correction(fixed), to: Calixir

  @doc """
  Equation of Time.
  """
  defdelegate equation_of_time(fixed), to: Calixir

  @doc """
  Solar Longitude.
  """
  defdelegate solar_longitude(tee), to: Calixir

  @doc """
  Next Solstice/Equinox (R.D.).
  """
  defdelegate solar_longitude_after(season, fixed), to: Calixir

  @doc """
  Dawn.
  """
  defdelegate dawn(fixed, location, alpha), to: Calixir

  @doc """
  Midday.
  """
  defdelegate midday(fixed, location), to: Calixir

  @doc """
  Sunset.
  """
  defdelegate sunset(fixed, location), to: Calixir

  @doc """
  Lunar Altitude.
  """
  defdelegate lunar_altitude(fixed, location), to: Calixir

  @doc """
  Lunar Latitude.
  """
  defdelegate lunar_latitude(fixed), to: Calixir

  @doc """
  Lunar Longitude.
  """
  defdelegate lunar_longitude(fixed), to: Calixir

  @doc """
  Next New Moon (R.D.).
  """
  defdelegate new_moon_at_or_after(fixed), to: Calixir

  @doc """
  Moonrise.
  """
  defdelegate moonrise(fixed, location), to: Calixir

  @doc """
  Moonset.
  """
  defdelegate moonset(fixed, location), to: Calixir

  # === Holidays

  @doc """
  Astronomical Easter.
  """
  defdelegate easter(g_year), to: Calixir, as: :astronomical_easter

end