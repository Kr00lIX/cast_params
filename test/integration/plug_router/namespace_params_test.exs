defmodule CastParams.Integration.PlugRouter.NamespaceParamsTest do
  use ExUnit.Case, async: true
  use RouterHelper
  
  describe "parse no required params" do
    defmodule ExampleSimpleRouter do
      use Plug.Router
      use CastParams

      cast_params(user: [age: :integer, name: :string!, subscribed: :boolean])

      get("/", do: send_resp(conn, 200, "ok"))
    end

    test "expect prepare valid existing params to type" do
      assert %{"user" => %{"age" => 10, "name" => "K", "subscribed" => false}} =
               call_params(ExampleSimpleRouter, %{"user" => %{"age" => "10", "name" => "K", "subscribed" => "0"}})

      assert %{"user" => %{"age" => nil, "name" => "K", "subscribed" => nil}} =
          call_params(ExampleSimpleRouter, %{"user" => %{"name" => "K"}})

    end

  end
end
