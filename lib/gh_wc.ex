defmodule GhWc do
  @moduledoc """
  Documentation for `GhWc`.
  """

  @progname :gh_wc

  def main(args) do
    :argparse.run(Enum.map(args, &String.to_charlist/1), cli(), %{progname: @progname})
  end

  defp cli() do
    %{
      commands: %{
        ~c"new" => %{
          arguments: [
            %{name: :issue, type: :integer, help: "GitHub issue number."}
          ],
          handler: &do_new_change/1,
          help: "Create a new branch for the GitHub issue."
        }
      },
      handler: &help/1
    }
  end

  defp help(_) do
    exit(:argparse.help(cli(), %{progname: @progname}), 0)
  end

  # Create a new git branch for the issue.
  defp do_new_change(%{issue: gh_issue}) do
    gh_issue = Integer.to_string(gh_issue)

    with {:ok, _} <- GH.exec(["issue", "view", gh_issue]) do
      {_, exit_code} =
        System.cmd(System.find_executable("git"), ["switch", "-c", "iss-#{gh_issue}"],
          into: IO.stream()
        )

      exit("", exit_code)
    else
      {:error, reason} ->
        exit(reason, 2)
    end
  end

  defp exit(message, exit_code) do
    IO.puts(:stderr, message)
    System.halt(exit_code)
  end
end
