defmodule Knapsack.Input do
  @moduledoc """
  Módulo responsável por coletar dados de entrada para o problema da mochila.
  """

  @doc """
  Função principal para coletar dados de entrada para o problema da mochila.
  """
  @spec run(any()) :: {integer(), list({integer(), integer()})}
  def run(_args \\ []) do
    capacity = get_number_from_user("Digite a capacidade da mochila:")
    items = get_items_from_user()

    {capacity, items}
  end

  @spec get_items_from_user() :: list({integer(), integer()})
  defp get_items_from_user(items \\ []) do
    print_splitter()

    if get_confirmation_from_user("Deseja inserir um item? (s/n)") do
      item = get_item_from_user()
      IO.puts("Item inserido com sucesso!")
      get_items_from_user([item | items])
    else
      Enum.reverse(items)
    end
  end

  @spec get_confirmation_from_user(String.t()) :: boolean()
  defp get_confirmation_from_user(message) do
    user_input(message) == "s"
  end

  @spec get_item_from_user() :: {integer(), integer()}
  defp get_item_from_user do
    weight = get_number_from_user("Digite o peso do item:")
    value = get_number_from_user("Digite o valor do item:")
    {value, weight}
  end

  @spec get_number_from_user(String.t()) :: integer()
  defp get_number_from_user(message) do
    input = user_input(message)

    case Integer.parse(input) do
      {number, _} when is_integer(number) ->
        number

      _ ->
        IO.puts("Por favor, insira um número inteiro válido.")
        get_number_from_user(message)
    end
  end

  @spec user_input(String.t()) :: String.t()
  defp user_input(message) do
    IO.puts(message)
    IO.gets("") |> String.trim()
  end

  @spec print_splitter() :: :ok
  defp print_splitter do
    IO.puts(String.duplicate("-", 30))
  end
end
