defmodule CheckersGame.GameServer do
  use GenServer


  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
    CheckersGame.GameSup.start_child(spec)
  end

  def reg(name) do
    {:via, Registry, {CheckersGame.GameReg, name}}
  end

  def start_link(name) do
    game = CheckersGame.BackupAgent.get(name) || CheckersGame.Game.new()
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def init(game) do
    {:ok, game}
  end

  def get_moves(name, position) do
    GenServer.call(reg(name), {:get_moves, name, position})
  end

  def move_disk(name, position) do
    GenServer.call(reg(name), {:move_disk, name, position})
  end

  def get_current_state(name) do
    GenServer.call(reg(name), {:get_state, name})
  end

  def chat_added(name, message) do
    GenServer.call(reg(name), {:chat_added, name, message})
  end


  def handle_call({:get_moves, name, position}, _from, game) do
    game = CheckersGame.Game.get_moves(game, position)
    CheckersGame.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:move_disk, name, position}, _from, game) do
    game = CheckersGame.Game.move_disk(game, position)
    CheckersGame.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:get_state, _name}, _from, game) do
    {:reply, game}
  end

  def handle_call({:chat_added, name, message}, _from, game) do 
    game = CheckersGame.Game.chat_added(game, message)
    CheckersGame.BackupAgent.put(name, game)
    {:reply, game, game}
  end

end
