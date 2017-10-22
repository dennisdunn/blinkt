defmodule Blinkt.PixelTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pixelbar} = start_supervised Blinkt.Pixelbar
    %{pixelbar: pixelbar, pixel: %Blinkt.Pixel{}}
  end

  test "store pixel by index", %{pixelbar: pixelbar} do
    assert Blinkt.Pixelbar.get(pixelbar, 0) == nil

    Blinkt.Pixelbar.set(pixelbar, 3, %Blinkt.Pixel{})
    assert Blinkt.Pixelbar.get(pixelbar, 3) != nil
  end

  test "initialize the bar with 8 pixels", %{pixelbar: pixelbar} do
    Blinkt.Pixelbar.init(pixelbar)

    assert Blinkt.Pixelbar.get(pixelbar, 3) != nil
  end

  test "change the lux of a pixel", %{pixel: pixel} do
    new = %Blinkt.Pixel{pixel | lux: 0.5}

    assert new.lux == 0.5
  end

  test "initialize a set of pixels and fetch one" do
    {:ok, pixels} = Blinkt.Pixelbar.start_link(%{})
    Blinkt.Pixelbar.init(pixels)
    assert Blinkt.Pixelbar.get(pixels, 1) != nil
  end
end


