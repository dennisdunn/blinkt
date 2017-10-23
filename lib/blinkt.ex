defmodule Blinkt do
  use Bitwise
  alias Blinkt.Pixel
  alias Blinkt.Pixels

  # @DAT 23
  # @CLK 24

  def start() do
    Pixels.start_link()
    Pixels.init()
    :ok
  end

  def set_brightness(brightness) do
    0..7 |> Enum.map(fn i -> Pixels.set_pixel(i, brightness) end)
    :ok
  end

  def clear() do
    0..7 |> Enum.map(fn i -> Pixels.set(i, %Pixel{lux: 0.2}) end)
    :ok
  end

  def show() do

  end

  def get_pixel(x) do
    Pixels.get(x)
  end

  def set_pixel(x, r, g, b, brightness) do
    Pixels.put(x, %Pixel{red: r, green: g, blue: b, lux: brightness})
    :ok
  end

  def set_all(r, g, b, brightness) do 
    0..7 |> Enum.map(fn i -> Blinkt.set_pixel(i, r, g, b, brightness) end)
    :ok
  end
  
end
