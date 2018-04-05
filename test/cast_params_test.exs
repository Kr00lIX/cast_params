defmodule CastParamsTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest CastParams

  def call(router, params) do
    conn = conn(:get, "/", params)
    opts = router.init([])
    assert %{params: params} = router.call(conn, opts)
    params
  end

  describe "parse no required params" do
    defmodule ExampleSimpleRouter do
      use Plug.Router
      use CastParams
  
      cast_params category_id: :integer, terms: :boolean
      cast_params name: :string
  
      get "/", do: send_resp(conn, 200, "ok")
    end

    test "expect prepare valid existing params to type" do
      assert %{"category_id" => 12345, "skipped" => "234"} = 
        call(ExampleSimpleRouter, %{"category_id" => "12345", "skipped" => "234"})
      
      assert %{"terms" => true, "skipped" => "234"} = 
        call(ExampleSimpleRouter, %{"terms" => "true", "skipped" => "234"})
  
      assert %{"terms" => false, "category_id" => 1} = 
        call(ExampleSimpleRouter, %{"terms" => "false", "category_id" => 1})
    end  
    
    test "receive error if can't prepare param" do
      assert_raise CastParams.Error, fn ->
        call(ExampleSimpleRouter, %{"category_id" => ""})
      end
    end
    
    test "expect parse second definition" do
      assert %{"name" => "Gaudí", "category_id" => 1010} = 
        call(ExampleSimpleRouter, %{"name" => "Gaudí", "category_id" => "1010"})
    end    
  end  
end