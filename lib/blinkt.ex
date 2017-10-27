defmodule Blinkt do
  use Bitwise
  use Agent
  alias Pigpiox.GPIO

  @dat 23
  @clk 24

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> <<0::size(8 * 4 * 8)>> end, name: __MODULE__)
  end

  def set_pixel(idx, <<pixel::binary-size(4)>>) when is_binary(pixel) do
    Agent.update(__MODULE__,(<<pre::size(idx * 4 * 8), ignore::size(4 * 8), rest::binary>> -> pre <> pixel <> rest) )
  end
  
    def get_pixel(idx) do
      Agent.get(__MODULE__,(<<ignore::size(idx * 4 * 8), pixel::size(4 * 8), rest::binary>> -> pixel) )
    end

  def set_brightness(brightness) do
    for i <- 0..7, do: Pixels.set_pixel(i, brightness) 
    :ok
  end

  def clear() do
    Agent.update(__MODULE__, (_ -> <<0::size(8 * 4 * 8)>>) )
    :ok
  end

  def show() do
    _sof()
    for _ 0..7 <- Agent.get(__MODULE__, (state->state))
    _eof()
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

  defp _write_pixel(<<r,g,b,lux>>) do
    _write_byte(<<lux ||| 224>>)
    _write_byte(<<b>>)
    _write_byte(<<g>>)
    _write_byte(<<r>>)
    :ok
  end

  defp _write_byte(bits)when bits != <<>> do
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
