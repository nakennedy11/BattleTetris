defmodule Tetrismp.BackupAgent do
  use Agent

  # Attribution: Professor Tuck's Backup Agent Code:
  # https://github.com/NatTuck/hangman-2019-01/blob/02-04-backup-agent/lib/hangman/backup_agent.ex

  def start_link(_args0) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(name, val) do
    Agent.update __MODULE__, fn state->
      Map.put(state, name, val)
    end
  end

  def get(name) do
    Agent.get __MODULE__, fn state ->
      Map.get(state, name)
    end
  end
end


