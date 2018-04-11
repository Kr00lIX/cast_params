defmodule CastParams.ConfigTest do
  use ExUnit.Case
  doctest CastParams.Config, import: true
  import CastParams.Config
  alias CastParams.Config
  
  test "expect default values from config" do
    assert %Config{
      nulify: true
    } == init([])
  end

  test "expect get :nulify option" do
    assert %Config{nulify: true} == init([nulify: true])
    assert %Config{nulify: false} == init([nulify: false])
  end

end