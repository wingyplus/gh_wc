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
    IO.puts(:stderr, :argparse.help(cli(), %{progname: @progname}))
  end

  # Create a new git branch for the issue.
  defp do_new_change(%{issue: gh_issue}) do
    GH.exec(["issue", "view", Integer.to_string(gh_issue |> dbg())])
    |> dbg()

    :ok
  end
end
