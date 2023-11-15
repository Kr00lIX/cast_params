defmodule CastParams.Integration.PlugRouter.SimpleRouterTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  use RouterHelper

  describe "parse no required params" do
    defmodule ExampleSimpleRouter do
      use Plug.Router
      use CastParams

      cast_params(category_id: :integer, terms: :boolean)
      cast_params(name: :string)

      get("/", do: send_resp(conn, 200, "ok"))
    end

    property "expect prepare valid existing params to type" do
      check all(
              category_id <- integer(),
              terms <- boolean(),
              skipped <- StreamData.binary()
            ) do
        assert %{"category_id" => ^category_id, "skipped" => ^skipped} =
                 call_params(ExampleSimpleRouter, %{"category_id" => "#{category_id}", "skipped" => skipped})

        assert %{"terms" => ^terms, "skipped" => ^skipped} =
                 call_params(ExampleSimpleRouter, %{"terms" => "#{terms}", "skipped" => skipped})

        assert %{"terms" => ^terms, "category_id" => ^category_id} =
                 call_params(ExampleSimpleRouter, %{"terms" => "#{terms}", "category_id" => category_id})
      end
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
      assert %{"category_id" => 12_345, "name" => nil} = call_params(ExampleSimpleRouter, %{"category_id" => "12345"})

      assert %{"terms" => nil, "skipped" => "234", "category_id" => nil, "name" => "Taras"} =
               call_params(ExampleSimpleRouter, %{"skipped" => "234", "name" => "Taras"})
    end
  end

  describe "parse required params" do
    defmodule ExampleRequiredRouter do
      use Plug.Router
      use CastParams

      cast_params(category_id: :integer!, terms: :boolean!)

      get("/", do: send_resp(conn, 200, "ok"))
    end

    test "expect prepare valid existing params to type" do
      assert %{"category_id" => 12_345, "terms" => true, "skipped" => "234"} =
               call_params(ExampleRequiredRouter, %{"category_id" => "12345", "terms" => "true", "skipped" => "234"})

      assert_raise CastParams.NotFound, fn ->
        call_params(ExampleRequiredRouter, %{"category_id" => "12345", "skipped" => "234"})
      end

      assert_raise CastParams.NotFound, fn ->
        call_params(ExampleRequiredRouter, %{"terms" => "true"})
      end
    end
  end
end
