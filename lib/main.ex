defmodule Knapsack.Main do
  @moduledoc """
  Módulo principal do problema da mochila.
  """

  @doc """
  Função principal do programa.
  """
  def main(_args \\ []) do
    {capacity, items} = Input.run()

    case items do
      [] ->
        IO.puts("Nenhum item foi inserido.")

      _ ->
        items
        |> Enum.reverse()
        |> Knapsack.solve(capacity)
        |> IO.inspect(label: "Resultado")
    end
  end
end
