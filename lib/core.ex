defmodule Knapsack.Core do
  @moduledoc """
  Módulo responsável por resolver o problema da mochila.
  """

  @doc """
  Função principal para resolver o problema da mochila.
  """
  @spec solve_knapsack_problem(list({integer(), integer()}), integer()) ::
          {:ok, list({integer(), integer()}), integer()}
  def solve_knapsack_problem(items, capacity) do
    dynamic_prog_matrix = build_dynamic_prog_matrix(items, capacity)
    selected_items = reconstruct_selected_items(dynamic_prog_matrix, items, capacity)

    {:ok, selected_items, Map.get(dynamic_prog_matrix, {length(items), capacity})}
  end

  defp build_dynamic_prog_matrix(items, capacity) do
    Enum.reduce(0..length(items), Map.new(), fn item_index, acc ->
      Enum.reduce(0..capacity, acc, fn current_capacity, acc ->
        process_item_for_capacity(acc, item_index, current_capacity, items)
      end)
    end)
  end

  defp reconstruct_selected_items(dynamic_prog_matrix, items, capacity) do
    {selected_items, _} =
      reconstruct_items(dynamic_prog_matrix, items, length(items), capacity, [])

    Enum.reverse(selected_items)
  end

  defp reconstruct_items(_, _, 0, _, selected_items), do: {selected_items, 0}
  defp reconstruct_items(_, _, _, 0, selected_items), do: {selected_items, 0}

  defp reconstruct_items(dp, items, i, j, selected_items) do
    case {Map.get(dp, {i, j}), Map.get(dp, {i - 1, j})} do
      {value, value} ->
        reconstruct_items(dp, items, i - 1, j, selected_items)

      _ ->
        {_, weight} = Enum.at(items, i - 1)
        reconstruct_items(dp, items, i - 1, j - weight, [Enum.at(items, i - 1) | selected_items])
    end
  end

  defp process_item_for_capacity(acc, item_index, current_capacity, items) do
    case {item_index, current_capacity} do
      {0, _} ->
        Map.put(acc, {item_index, current_capacity}, 0)

      {_, 0} ->
        Map.put(acc, {item_index, current_capacity}, 0)

      _ ->
        {value, weight} = Enum.at(items, item_index - 1)
        update_dynamic_programming_matrix(acc, item_index, current_capacity, {value, weight})
    end
  end

  defp update_dynamic_programming_matrix(dynamic_prog_matrix, item_index, current_capacity, item) do
    {value, weight} = item

    if current_capacity < weight do
      Map.put(
        dynamic_prog_matrix,
        {item_index, current_capacity},
        Map.get(dynamic_prog_matrix, {item_index - 1, current_capacity})
      )
    else
      calculate_max_value(dynamic_prog_matrix, item_index, current_capacity, value, weight)
    end
  end

  defp calculate_max_value(dynamic_prog_matrix, item_index, current_capacity, value, weight) do
    include_value =
      value + Map.get(dynamic_prog_matrix, {item_index - 1, current_capacity - weight})

    exclude_value = Map.get(dynamic_prog_matrix, {item_index - 1, current_capacity})

    Map.put(
      dynamic_prog_matrix,
      {item_index, current_capacity},
      max(include_value, exclude_value)
    )
  end
end
