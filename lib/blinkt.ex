defmodule Blinkt do
  use Bitwise
  use Agent
  alias Pigpiox.GPIO

  @dat 23
  @clk 24

  @buffer 256
  @pixel 32

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> <<0::size(@buffer)>> end, name: __MODULE__)
  end

  def set_pixel(idx, <<pixel::size(@pixel)>>) do
    skip = idx * @pixel
    Agent.update(__MODULE__, fn <<pre::size(skip), ignore::size(@pixel), rest::binary>> -> pre <> pixel <> rest end)
  end
  
  def get_pixel(idx) do
      skip = idx * @pixel
      Agent.get(__MODULE__,  fn <<_::size(skip), pixel::size(@pixel), _::binary>> -> pixel end )
    end

  def clear() do
    Agent.update(__MODULE__,  fn _ -> <<0::size(@buffer)>> end )
    :ok
  end

  def show() do
    _sof()
   for <<b::size(8) <- Enum.reverse(Agent.get(__MODULE__, fn state -> state end))>>, do: _write_byte(b);
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

  defp _write_byte(byte) do
    for <<bit::size(1) <- byte>>, do: _write_bit
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
