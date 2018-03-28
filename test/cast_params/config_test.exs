defmodule CastParams.ConfigTest do
  use ExUnit.Case
  doctest CastParams.Config

  alias CastParams.{Config, Param}

  test "expect parse :integer param" do
    assert [param] = Config.configure([age: :integer])

    assert %Param{name: :age, type: :integer} == param
  end

  test "expect parse :boolean param" do
    assert [param] = Config.configure([terms: :boolean])
    assert %Param{name: :terms, type: :boolean} == param
  end
end