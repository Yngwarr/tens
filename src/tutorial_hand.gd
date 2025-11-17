class_name TutorialHand
extends Sprite2D

@export_group("Internal")
@export var state_machine: StateMachine
@export var cooldown_timer: Timer

## returns Vector4
var get_move: Callable


func _ready() -> void:
	var hidden_state := HiddenHandState.new()
	var move_state := MoveHandState.new()

	hidden_state.setup({hand = self, move_state = move_state, cooldown = 1.5})
	move_state.setup({hand = self, hidden_state = hidden_state})

	state_machine.add_state(hidden_state)
	state_machine.add_state(move_state)

	state_machine.transition(hidden_state)


func init(p_get_move: Callable) -> void:
	get_move = p_get_move


func next_move() -> Vector4:
	return get_move.call() as Vector4


func on_player_turn() -> void:
	state_machine.current_state.on_player_turn()
