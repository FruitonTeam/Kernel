package;

class Kernel
{

	static public function nextState(currentState:GameState, move:Move):GameState
	{
		currentState.pieces[move.id].position.moveBy(move.positionChange);
		return currentState;
	}

	static public function generateState():GameState
	{
		return new GameState([
			new Piece(0, 'Jablko', new Position(0, 0)),
			new Piece(1, 'Hruska', new Position(1, 0)),
			new Piece(2, 'Slivka', new Position(0, 1)),
			new Piece(3, 'Jablko', new Position(8, 8)),
			new Piece(4, 'Ananas', new Position(5, 5))
		]);
	}
}
