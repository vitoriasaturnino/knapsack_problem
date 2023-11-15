defmodule Knapsack.CoreTest do
  use ExUnit.Case, async: true

  describe "solve_knapsack_problem/2" do
    test "returns the correct result" do
      items = [{6, 1}, {10, 2}, {12, 3}, {7, 2}, {2, 1}]
      capacity = 5

      assert Knapsack.Core.solve_knapsack_problem(items, capacity) ==
               {:ok, [{7, 2}, {10, 2}, {6, 1}], 23}
    end

    test "returns the correct result for given items and capacity" do
      items = [{6, 1}, {10, 2}, {12, 3}, {7, 2}, {2, 1}]
      capacity = 5

      assert Knapsack.Core.solve_knapsack_problem(items, capacity) ==
               {:ok, [{7, 2}, {10, 2}, {6, 1}], 23}
    end

    test "returns empty list when no items are provided" do
      items = []
      capacity = 5
      assert Knapsack.Core.solve_knapsack_problem(items, capacity) == {:ok, [], 0}
    end

    test "returns empty list when capacity is zero" do
      items = [{6, 1}, {10, 2}, {12, 3}]
      capacity = 0
      assert Knapsack.Core.solve_knapsack_problem(items, capacity) == {:ok, [], 0}
    end

    test "handles single item that fits in the knapsack" do
      items = [{5, 2}]
      capacity = 5
      assert Knapsack.Core.solve_knapsack_problem(items, capacity) == {:ok, [{5, 2}], 5}
    end

    test "handles single item that doesn't fit in the knapsack" do
      items = [{6, 3}]
      capacity = 2
      assert Knapsack.Core.solve_knapsack_problem(items, capacity) == {:ok, [], 0}
    end

    test "correctly solves problem with multiple items and exact fit" do
      items = [{3, 2}, {5, 3}, {8, 5}]
      capacity = 5
      assert Knapsack.Core.solve_knapsack_problem(items, capacity) == {:ok, [{5, 3}, {3, 2}], 8}
    end
  end
end
