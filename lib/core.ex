defmodule Knapsack do
  @moduledoc """
  Módulo responsável por resolver o problema da mochila.
  """

  @doc """
  Função principal para resolver o problema da mochila.
  """
  @spec solve(list({integer(), integer()}), integer()) :: {:ok, list({integer(), integer()}), integer()}
  def solve(items, capacity) do
    dp =
      Enum.reduce(0..length(items), Map.new(), fn i, acc ->
        Enum.reduce(0..capacity, acc, fn j, acc ->
          if i == 0 or j == 0 do
            Map.put(acc, {i, j}, 0)
          else
            {value, weight} = Enum.at(items, i - 1)

            if j < weight do
              Map.put(acc, {i, j}, Map.get(acc, {i - 1, j}))
            else
              include = value + Map.get(acc, {i - 1, j - weight})
              exclude = Map.get(acc, {i - 1, j})
              Map.put(acc, {i, j}, max(include, exclude))
            end
          end
        end)
      end)

    {selected_items, _} = reconstruct_items(dp, items, length(items), capacity, [])
    {:ok, Enum.reverse(selected_items), Map.get(dp, {length(items), capacity})}
  end

  defp reconstruct_items(_, _, 0, _, selected_items), do: {selected_items, 0}
  defp reconstruct_items(_, _, _, 0, selected_items), do: {selected_items, 0}

  defp reconstruct_items(dp, items, i, j, selected_items) do
    if Map.get(dp, {i, j}) == Map.get(dp, {i - 1, j}) do
      reconstruct_items(dp, items, i - 1, j, selected_items)
    else
      {_, weight} = Enum.at(items, i - 1)
      reconstruct_items(dp, items, i - 1, j - weight, [Enum.at(items, i - 1) | selected_items])
    end
  end
end
