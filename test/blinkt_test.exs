defmodule Blinkt.BlinktTest do
  use ExUnit.Case, async: true
  alias Blinkt.Pixel
  alias Blinkt.Pixels

  setup do
    start_supervised Pixels
    # Pixels.start_link()
    Pixels.init()
  end

  test "set the lux" do
    Pixels.set_lux(1, 0.5)
    %Pixel{lux: lux} = Pixels.get(1)
    assert lux == 0.5
  end
end

