defmodule Knapsack do
  @moduledoc """
  Módulo principal do problema da mochila.
  """

  alias Knapsack.{Core, Input}

  @doc """
  Função principal do programa.
  """

  @spec main([binary()]) :: :ok
  def main(_args \\ []) do
    {capacity, items} = Input.run()

    case items do
      [] ->
        IO.puts("Nenhum item foi inserido.")

      _ ->
        items
        |> Enum.reverse()
        |> Core.solve_knapsack_problem(capacity)
        |> IO.inspect(label: "Resultado")
    end
  end
end
