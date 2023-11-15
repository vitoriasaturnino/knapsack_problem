defmodule Knapsack.Input do
  @moduledoc """
  Módulo responsável por coletar dados de entrada para o problema da mochila.
  """

  @doc """
  Coleta dados de entrada para o problema da mochila.
  """
  @spec run(any()) :: {integer(), list({integer(), integer()})}
  def run(_args \\ []) do
    capacity = InputUtils.get_validated_number("Digite a capacidade da mochila:")
    items = collect_items()

    {capacity, items}
  end

  @spec collect_items() :: list({integer(), integer()})
  defp collect_items(items \\ []) do
    InputUtils.print_splitter()

    if InputUtils.get_confirmation("Deseja inserir um item? (s/n)") do
      item = get_item()
      IO.puts("Item inserido com sucesso!")
      collect_items([item | items])
    else
      Enum.reverse(items)
    end
  end

  @spec get_item() :: {integer(), integer()}
  defp get_item do
    weight = InputUtils.get_validated_number("Digite o peso do item:")
    value = InputUtils.get_validated_number("Digite o valor do item:")
    {value, weight}
  end
end

defmodule InputUtils do
  @moduledoc """
  Módulo de utilitários para entrada de dados.
  """

  @spec get_validated_number(String.t()) :: integer()
  def get_validated_number(message) do
    message
    |> user_input()
    |> parse_integer(message)
  end

  @spec parse_integer(String.t(), String.t()) :: integer()
  defp parse_integer(input, message) do
    case Integer.parse(input) do
      {number, _} when is_integer(number) -> number
      _ ->
        IO.puts("Por favor, insira um número inteiro válido.")
        get_validated_number(message)
    end
  end

  @spec get_confirmation(String.t()) :: boolean()
  def get_confirmation(message) do
    user_input(message) == "s"
  end

  @spec user_input(String.t()) :: String.t()
  defp user_input(message) do
    IO.puts(message)
    IO.gets("") |> String.trim()
  end

  @spec print_splitter() :: :ok
  def print_splitter do
    IO.puts(String.duplicate("-", 30))
  end
end
