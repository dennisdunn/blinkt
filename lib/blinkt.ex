defmodule Blinkt do
  use Bitwise
  alias Blinkt.Pixel
  alias Blinkt.Pixels
  alias Pigpiox.GPIO

  @dat 23
  @clk 24

  def start() do
    Pixels.start_link()
    Pixels.init()
    _setup_gpio()
    :ok
  end

  def set_brightness(brightness) do
    for i <- 0..7, do: Pixels.set_pixel(i, brightness) 
    :ok
  end

  def clear() do
    for i <- 0..7, do: Pixels.set_pixel(i, %Pixel{lux: 0.2})
    :ok
  end

  def show() do
    _sof()
    for i <- 0..7, do:  _write_pixel(Pixels.get(i))
    _eof()
    :ok
  end

  def get_pixel(x) do
    Pixels.get(x)
  end

  def set_pixel(x, pixel) do
    Pixels.put(x, pixel)
  end

  def set_pixel(x, r, g, b, brightness) do
    Pixels.put(x, %Pixel{red: r, green: g, blue: b, lux: trunc(brightness * 31) &&& 31})
    :ok
  end

  def set_all(r, g, b, brightness) do 
    for i <- 0..7, do: Blinkt.set_pixel(i, r, g, b, brightness)
    :ok
  end

  defp _sof do
    GPIO.write(@dat, 0)
    for _ <- 1..32, do: _pulse_gpio_pin(@clk)
    :ok
  end

  defp _eof do
    GPIO.write(@dat, 0)
    for _ <- 1..36, do: _pulse_gpio_pin(@clk)
    :ok
  end

  defp _write_pixel(pixel) do
    %Pixel{red: r, green: g, blue: b, lux: brightness} = pixel
    _write_byte(<<brightness ||| 224>>)
    _write_byte(<<b>>)
    _write_byte(<<g>>)
    _write_byte(<<r>>)
    :ok
  end

  defp _write_byte(bits) when bits == <<>> do
    :ok
  end

  defp _write_byte(bits) do
    <<b::size(1), rest::bitstring>> = bits
    GPIO.write(@dat, b)
    _pulse_gpio_pin(@clk)
    _write_byte(rest)
    :ok
  end

  defp _pulse_gpio_pin(pin) do
    GPIO.write(pin, 1)
    GPIO.write(pin, 0)
    :ok
  end

  defp _setup_gpio do
    GPIO.set_mode(@dat, :output)
    GPIO.set_mode(@clk, :output)
    :ok
  end
  
end
