defmodule Knapsack.Core do
  @moduledoc """
  Módulo responsável por resolver o problema da mochila.
  """

  @doc """
  Resolve o problema da mochila utilizando programação dinâmica.
  """
  @spec solve_knapsack_problem(list({integer(), integer()}), integer()) ::
          {:ok, list({integer(), integer()}), integer()}
  def solve_knapsack_problem(items, capacity) do
    dynamic_prog_matrix = build_dynamic_prog_matrix(items, capacity)
    selected_items = reconstruct_selected_items(dynamic_prog_matrix, items, capacity)

    {:ok, selected_items, Map.get(dynamic_prog_matrix, {length(items), capacity})}
  end

  @spec build_dynamic_prog_matrix(list({integer(), integer()}), integer()) :: map()
  defp build_dynamic_prog_matrix(items, capacity) do
    0..length(items)
    |> Enum.reduce(Map.new(), &process_item_row(&1, &2, capacity, items))
  end

  @spec process_item_row(integer(), map(), integer(), list({integer(), integer()})) :: map()
  defp process_item_row(item_index, acc, capacity, items) do
    0..capacity
    |> Enum.reduce(acc, &process_capacity_for_item(&1, item_index, &2, items))
  end

  @spec process_capacity_for_item(integer(), integer(), map(), list({integer(), integer()})) ::
          map()
  defp process_capacity_for_item(current_capacity, item_index, acc, items) do
    case {item_index, current_capacity} do
      {0, _} -> Map.put(acc, {item_index, current_capacity}, 0)
      {_, 0} -> Map.put(acc, {item_index, current_capacity}, 0)
      _ -> update_dp_matrix(acc, item_index, current_capacity, Enum.at(items, item_index - 1))
    end
  end

  @spec update_dp_matrix(map(), integer(), integer(), {integer(), integer()}) :: map()
  defp update_dp_matrix(dp_matrix, item_index, current_capacity, {value, weight}) do
    if current_capacity < weight do
      Map.put(
        dp_matrix,
        {item_index, current_capacity},
        Map.get(dp_matrix, {item_index - 1, current_capacity})
      )
    else
      include_value = value + Map.get(dp_matrix, {item_index - 1, current_capacity - weight})
      exclude_value = Map.get(dp_matrix, {item_index - 1, current_capacity})
      Map.put(dp_matrix, {item_index, current_capacity}, max(include_value, exclude_value))
    end
  end

  @spec reconstruct_selected_items(map(), list({integer(), integer()}), integer()) ::
          list({integer(), integer()})
  defp reconstruct_selected_items(dp_matrix, items, capacity) do
    {selected_items, _} = reconstruct_items(dp_matrix, items, length(items), capacity, [])
    Enum.reverse(selected_items)
  end

  @spec reconstruct_items(map(), list({integer(), integer()}), integer(), integer(), list({integer(), integer()})) ::
          {list({integer(), integer()}), integer()}
  defp reconstruct_items(_dp_matrix, _items, 0, _, acc), do: {acc, 0}
  defp reconstruct_items(_dp_matrix, _items, _, 0, acc), do: {acc, 0}


  defp reconstruct_items(dp_matrix, items, item_index, current_capacity, acc) do
    if Map.get(dp_matrix, {item_index, current_capacity}) ==
         Map.get(dp_matrix, {item_index - 1, current_capacity}) do
      reconstruct_items(dp_matrix, items, item_index - 1, current_capacity, acc)
    else
      {_value, weight} = Enum.at(items, item_index - 1)

      reconstruct_items(dp_matrix, items, item_index - 1, current_capacity - weight, [
        Enum.at(items, item_index - 1) | acc
      ])
    end
  end
end
