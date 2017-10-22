defmodule Blinkt do
  use Bitwise

  def start_link(opts) do
    {:ok, pixelbar} = Blinkt.Pixelbar.start_link(opts)
  end

  def set_lux(pixelbar, lux) do

  end
end
