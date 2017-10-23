defmodule Blinkt.Pixels.Tests do
    use ExUnit.Case, async: false
    alias Blinkt.Pixel
    alias Blinkt.Pixels
    
    test "start the pixel bar state" do
        Pixels.start_link
    end
    
    test "initialize the pixel bar state" do
        Pixels.start_link
        Pixels.init
    end

    test "fetch a pixel from the pixel bar state" do
        Pixels.start_link
        Pixels.init
        p = Pixels.get(1)
        assert p != nil
    end

    test "set a pixel to white" do
        Pixels.start_link
        Pixels.init
        Pixels.set_pixel(1, 255, 255, 255)
        p = Pixels.get(1)
        assert p.red == 255
    end
end
