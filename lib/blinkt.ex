defmodule Blinkt do
  use Bitwise
  alias Blinkt.Pixel
  alias Blinkt.Pixels
 # alias Pigpiox.GPIO

  @dat 23
  @clk 24

  def start() do
    Pixels.start_link
    Pixels.init
    Blinkt._setup_gpio
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
    Blinkt._sof
    0..7 |> Enum.map(fn i ->  _write_pixel(Pixels.get(i)) end)
    Blinkt._eof
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

  defp _sof do
    Blinkt._pulse_data_line(32)
  end

  defp _eof do
    Blinkt._pulse_data_line(36)
  end

  defp _write_pixel(pixel) do
    %Pixel{red: r, green: g, blue: b, lux: brightness} = pixel
    Blinkt._write_byte(trunc(brightness * 31) &&& 31)
    Blinkt._write_byte(b)
    Blinkt._write_byte(g)
    Blinkt._write_byte(r)
  end

  def waa(bits) do
  Blinkt._write_byte(bits)
  end

  defp _write_byte(bits) when bits == <<>> do
    :ok
  end
  defp _write_byte(bits) do
    <<b::size(1), rest::bitstring>> = bits
    IO.puts b
    Blinkt._write_byte(rest)
  end

  defp _pulse_data_line(n) do
    # GPIO.write(@dat, 0)
    # 1..n |> Enum.map(fn () -> GPIO.write(@dat, 1)
    # GPIO.write(@dat, 0)
    # end)
  end

  defp _setup_gpio do
    # GPIO.set_mode(@dat, :output)
    # GPIO.set_mode(@clk, :output)
  end
  
end
