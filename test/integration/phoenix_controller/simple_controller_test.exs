defmodule CastParams.Integration.Phoenix.SimpleContollerTest do
  use ExUnit.Case, async: true
  use RouterHelper
  import Phoenix.Controller

  describe "use for one action with guard" do
    defmodule ExampleController do
      use Phoenix.Controller
      use CastParams, nulify: false

      cast_params([category_id: :integer, terms: :boolean] when action == :index)

      def index(conn, _params) do
        send_resp(conn, 200, "OK")
      end

      def show(conn, _params) do
        send_resp(conn, 200, "OK")
      end
    end

    test "expect check guards for index action" do
      assert %{"category_id" => 1, "terms" => true} = 
          action_params(ExampleController, :index, %{"category_id" => "1", "terms" => "true"})      
    end

    test "skip cast_params plug for show action" do      
      assert %{"category_id" => "1", "terms" => "true"} = 
          action_params(ExampleController, :show, %{"category_id" => "1", "terms" => "true"})
    end

    test "doesn't nulify param" do
      assert %{"category_id" => 1} == action_params(ExampleController, :index, %{"category_id" => "1"})
      assert %{"terms" => true} == action_params(ExampleController, :index, %{"terms" => "1"})
    end
  end

  describe "use for each action defined plug" do
    defmodule ThreeCastsController do
      use Phoenix.Controller
      use CastParams, nulify: true

      cast_params(id: :integer!)
      cast_params([age: :integer] when action == :index)
      cast_params name: :string!, amount: :float when action == :show

      def index(conn, %{"id" => _id, "age" => _age} = _params) do
        send_resp(conn, 200, "OK")
      end

      def show(conn, %{"id" => _id, "amount" => _amount, "name" => _name} = _params) do
        send_resp(conn, 200, "OK")
      end
    end

    test "expect check guards for index action" do
      assert %{"id" => 1, "age" => 35, "query" => "select: 1"} =
               action_params(ThreeCastsController, :index, %{"id" => "1", "age" => "35", "query" => "select: 1"})

      assert %{"id" => 1, "age" => nil} == action_params(ThreeCastsController, :index, %{"id" => "1"})
    end

    test "skip cast_params plug for show action" do
      assert %{"amount" => nil, "id" => 1, "name" => "J"} =
               action_params(ThreeCastsController, :show, %{"id" => 1, "name" => "J"})

      assert %{"amount" => 4.99, "id" => 1, "name" => "J"} =
               action_params(ThreeCastsController, :show, %{"id" => 1, "name" => "J", "amount" => "4.99"})
    end

    test "raise error for required params" do
      assert_raise CastParams.NotFound, fn ->
        action_params(ThreeCastsController, :index, %{})
      end

      assert_raise CastParams.NotFound, fn ->
        action_params(ThreeCastsController, :show, %{"id" => 1, "amount" => "4.99"})
      end
    end
  end
end
