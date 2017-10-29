defmodule Blinkt do
  use Bitwise
  use Agent
  alias Pigpiox.GPIO

  @dat 23
  @clk 24

  @buffer 32
  @pixel 4

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> <<0::size(@buffer)>> end, name: __MODULE__)
  end

  def set_pixel(idx, r, g, b, l) do
    skip = idx * @pixel
    Agent.update(__MODULE__, fn <<pre::binary-size(skip), _::binary-size(@pixel), post::binary>> -> pre <> <<l, g, b, r>> <> post end)
  end
  
  def get_pixel(idx) do
      skip = idx * @pixel
    Agent.get(__MODULE__,  fn state -> binary_part(state, skip, @pixel) end )
    end

  def clear() do
    Agent.update(__MODULE__,  fn _ -> <<0::size(@buffer)>> end )
    :ok
  end

  def show() do
    _sof()
   for <<b::binary-size(1) <- Agent.get(__MODULE__, fn state -> state end)>>, do: _write_byte(b);
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

  defp _write_byte(byte) do
    for <<bit::size(1) <- byte>>, do: _write_bit(bit)
    :ok
  end

  defp _write_bit(bit) do
    GPIO.write(@dat, bit)
    _pulse_gpio_pin(@clk)
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
