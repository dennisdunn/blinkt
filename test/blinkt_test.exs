defmodule Blinkt.BlinktTest do
  use ExUnit.Case, async: true

  setup do
    {ok, pixels} = Blinkt.Pixelbar.start_link(%{})
    %{pixels: Blinkt.Pixelbar.init(pixels)}
  end

  test "set the lux", %{pixels: pixels} do
    Blinkt.Pixelbar.set_lux(pixels, 0.5)
    %Blinkt.Pixel{lux: lux} = Blinkt.Pixelbar.get(pixels, 1)
    assert lux == 0.5
  end
end

