defmodule Roshambo do
  def main(argv) do
    player_move = List.first(argv)
    if Enum.member?(["rock", "paper", "scissors"], player_move) do
      play(player_move)
    else
      IO.puts("Please provide a value of 'rock', 'paper' or 'scissors'")
    end
  end

  defp play(player_move) do
    get_comp_move()
    |> determine_winner(player_move)
    |> IO.puts
  end

  defp get_comp_move do
    Enum.random(["rock", "paper", "scissors"])
  end

  defp determine_winner("paper", "rock") do
    "You lost, computer played - paper"
  end

  defp determine_winner("rock", "scissors") do
    "You lost, computer played - rock"
  end

  defp determine_winner("scissors", "paper") do
    "You lost, computer played - scissors"
  end

  defp determine_winner(comp_move, player_move) when comp_move == player_move do
    "It was tie - you both played #{comp_move}"
  end

  defp determine_winner(comp_move, _) do
    "You win! Computer played #{comp_move}"
  end
end