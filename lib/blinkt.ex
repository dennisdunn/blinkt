defmodule Blinkt do
  use Bitwise
  use Agent
  alias Pigpiox.GPIO

  @dat 23
  @clk 24

  @buffer 32
  @pixel 4

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> <<0::size(256)>> end, name: __MODULE__)
  end

  def set_pixel(idx, r, g, b, l) do
    skip = idx * 4
    Agent.update(__MODULE__, fn <<pre::binary-size(skip), _::binary-size(4), post::binary>> -> pre <> <<l, b, g, r>> <> post end)
  end

  def get_pixel(idx) do
    skip = idx * 4
    Agent.get(__MODULE__,  fn state -> binary_part(state, skip, 4) end )
  end

  def dump() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def shift_left() do
    Agent.update(__MODULE__, fn <<a::binary-size(4), b::binary>> -> b <> a end)
  end

  def shift_right() do
    Agent.update(__MODULE__, fn <<a::binary-size(28), b::binary>> -> b <> a end)
  end

  def clear() do
    Agent.update(__MODULE__,  fn _ -> <<0::size(256)>> end )
    :ok
  end

  def show() do
    _sof()
    for <<pixel::binary-size(4) <- Agent.get(__MODULE__, fn state -> state end)>>, do: _write_pixel(pixel);
    _eof()
    :ok
  end

  def _write_pixel(<<l, c::binary>>) do
    for <<bit::size(1) <- <<l ||| 224>> >>, do: _write_bit(bit)
    for <<bit::size(1) <- c>>, do: _write_bit(bit)
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
