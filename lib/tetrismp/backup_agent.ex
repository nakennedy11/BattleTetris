defmodule Tetrismp.BackupAgent do
  use Agent

  # Attribution: Professor Tuck's Backup Agent Code:
  # https://github.com/NatTuck/hangman-2019-01/blob/02-04-backup-agent/lib/hangman/backup_agent.ex

  def start_link(_args0) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(gamename, user, val) do
    Agent.update __MODULE__, fn state->
      users = Map.get(state, gamename)
      if users do
        IO.puts("usrs nil")
        users = Map.put(users, user, val)
        Map.put(state, gamename, users)
      else
       IO.puts("users not nil")
        users = %{}
        users = Map.put(users, user, val)
        Map.put(state, gamename, users)
      end
    end
  end

  def get(name, user) do
    Agent.get __MODULE__, fn state ->
     IO.puts(name)
      users = Map.get(state, name)
      if users do
        Map.get(users, user)
      else 
        nil
      end
    end
  end
end

