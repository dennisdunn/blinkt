defmodule Blinkt.PixelTest do
  use ExUnit.Case, async: true

  test "store pixel by index" do
    {:ok, pixelBar} = start_supervised Blinkt.Pixelbar
    assert Blinkt.Pixelbar.get(pixelBar, 0) == nil

    Blinkt.Pixelbar.set(pixelBar, 3, %Blinkt.Pixel{})
    assert Blinkt.Pixelbar.get(pixelBar, 3) != nil
  end

  test "initialize the bar with 8 pixels" do
    {:ok, pixelbar} = start_supervised Blinkt.Pixelbar
    Blinkt.Pixelbar.init(pixelbar)

    assert Blinkt.Pixelbar.get(pixelbar, 3) != nil
  end
end


