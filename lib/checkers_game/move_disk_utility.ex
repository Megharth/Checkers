defmodule CheckersGame.MoveDisk do

  def move_disk(game, position) do
      shift_disk(game, position)
  end

  def shift_disk(game, position) do
    # Get the selected disk
    tile = find_selected_disk(game.board, 0)
    selectedDisk = tile.disk

    # Check if there was any enemy kill
    result = check_enemy_kill(selectedDisk, position, game)

    # Update all the values
    board = result.board
    selectedDisk = Map.put(selectedDisk, :position, position)
    tile = Map.put(tile, :disk, nil)

    # To check if the disk becomes king after move
    if selectedDisk.isKing === false do
      Map.put(selectedDisk, :isKing, is_king(selectedDisk))
    end

    new_tile = Map.put(Enum.at(board, position), :disk, selectedDisk)

    # Move the disk from current position to new Position
    board = List.replace_at(board, tile.position, tile)
    |> List.replace_at(position, new_tile)
    |> remove_highlights()
    %{
      board: board,
      whites: result.whites,
      blacks: result.blacks
    }
  end

  def is_king(disk) do
    if disk.color == "black" and disk.position <= 7 do
      true
    else
      false
    end
    if disk.color == "white" and disk.position >=56 do
      true
    else
      false
    end
  end

  # To remove highlights from all the tiles
  def remove_highlights(board) do
    Enum.map(board, fn tile ->
      Map.put(tile, :isHighlighted, false)
    end)
  end

  # To remove disk from either whites or blacks
  def remove_disk(position, deck) do
    index = Enum.find_index(deck, fn el ->
      el.position == position
    end)
    List.delete(deck, index)
  end

  # To find the selected disk from the entire board
  def find_selected_disk(board, position) do
    tile = Enum.at(board, position)
    if tile[:disk] !== nil and tile.disk.isSelected == true do
      set_is_selected_false(board, position)
    else
      find_selected_disk(board, position+1)
    end
  end

  # Set the selected status of disk to false
  def set_is_selected_false(board, position) do
    disk = Enum.at(board, position).disk |> Map.put(:isSelected, false)
    Map.merge(Enum.at(board, position), %{disk: disk})
  end

  # Check if there was enemy on the next tile
  def check_enemy_kill(disk, position, game) do
    # If there was enemy, kill it and update the board
    if abs(disk.position - position) > 9 do
      delta = div(disk.position - position, 2)
      deadDisk = disk.position - delta
      color = Enum.at(game.board, deadDisk)
      board = kill_enemy(game.board, deadDisk)
      if color == "white" do
        whites = remove_disk(deadDisk, game.whites)
        blacks = game.blacks
        %{
         board: board,
         whites: whites,
         blacks: blacks
        }
      else
        whites = game.whites
        blacks = remove_disk(deadDisk, game.blacks)
        %{
          board: board,
          whites: whites,
          blacks: blacks
        }
      end
    # Else return the original state of the game
    else
      game
    end
  end

  # To remove enemy disk from the board
  def kill_enemy(board, position) do
    tile = Map.merge(Enum.at(board, position), %{disk: nil})
    List.replace_at(board, position, tile)
  end

end