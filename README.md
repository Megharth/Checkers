# CheckersGame
### Tech stack
  - Backend: _Elixir_, _Phoenix_
  - Frontend: _React_
  - Database: _Postgres SQL_

This is an implementation of Checkers game with following features such as:
  - Multiplayer Support with the help of sockets
  - Features two tables
    - One for the active games where you can join as a guest and spectate the match
    - One for the pending games where you can join as the second player. On joining, this match is moved to active games table.
  - Supports multiple concurrent games using GenServer of Elixir
  - Implements all the rules of the standard Checkers
  - Allows players as well as guests to send messages in a general chat box which is unique for every game

_Note: Games remain active unless and until both players quit or the game is concluded_

# Dependencies

_Note: These instruction are only for Debain/Ubuntu based Linux Distros_

  - Install Node.js and npm
  - You will need to install erlang and elixir to run this project. This [article](https://gist.github.com/rubencaro/6a28138a40e629b06470) is the easiest way to do it.
  - Install phoenix from [here](https://hexdocs.pm/phoenix/installation.html#content)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.