class_name TutorialHand
extends Sprite2D

@export_group("Internal")
@export var state_machine: StateMachine
@export var cooldown_timer: Timer

## { from: Vector2, to: Vector2 }
var moves: Array[Dictionary] = []


func _ready() -> void:
	var inactive_state := InactiveHandState.new()
	var hidden_state := HiddenHandState.new()
	var move_state := MoveHandState.new()

	inactive_state.setup({
		hand = self,
		hidden_state = hidden_state
	})

	hidden_state.setup({
		hand = self,
		move_state = move_state,
		cooldown = 1
	})

	move_state.setup({
		hand = self,
		hidden_state = hidden_state
	})

	state_machine.add_state(inactive_state)
	state_machine.add_state(hidden_state)
	state_machine.add_state(move_state)

	# state_machine.transition(inactive_state)


func add_moves(new_moves: Array[Dictionary]) -> void:
	moves.append_array(new_moves)
	# state_machine.current_state.on_moves_added()


func next_move() -> Dictionary:
	return moves[0]
