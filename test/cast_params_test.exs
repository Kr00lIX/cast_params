defmodule CastParamsTest do
  use ExUnit.Case, async: true
  use RouterHelper
  import CastParams
  doctest CastParams

  describe "parse no required params" do
    defmodule ExampleSimpleRouter do
      use Plug.Router
      use CastParams

      cast_params(category_id: :integer, terms: :boolean)
      cast_params(name: :string)

      get("/", do: send_resp(conn, 200, "ok"))
    end

    test "expect prepare valid existing params to type" do
      assert %{"category_id" => 12345, "skipped" => "234"} =
               call_params(ExampleSimpleRouter, %{"category_id" => "12345", "skipped" => "234"})

      assert %{"terms" => true, "skipped" => "234"} =
               call_params(ExampleSimpleRouter, %{"terms" => "true", "skipped" => "234"})

      assert %{"terms" => false, "category_id" => 1} =
               call_params(ExampleSimpleRouter, %{"terms" => "false", "category_id" => 1})
    end

    test "receive error if can't prepare param" do
      assert_raise CastParams.Error, fn ->
        call_params(ExampleSimpleRouter, %{"category_id" => ""})
      end
    end

    test "expect parse second definition" do
      assert %{"name" => "Gaudí", "category_id" => 1010} =
               call_params(ExampleSimpleRouter, %{"name" => "Gaudí", "category_id" => "1010"})
    end

    test "expect nulify params if not exists" do
      assert %{"category_id" => 12345, "name" => nil} = call_params(ExampleSimpleRouter, %{"category_id" => "12345"})

      assert %{"terms" => nil, "skipped" => "234", "category_id" => nil, "name" => "Taras"} =
               call_params(ExampleSimpleRouter, %{"skipped" => "234", "name" => "Taras"})
    end
  end

  describe ".cast_params" do
    def plug(plug, options) do
      assert CastParams.Plug == plug
      options
    end

    test "create call guard" do
      assert [%CastParams.Param{name: "age", required: false, type: :integer}] = cast_params(age: :integer)
    end
  end
end
