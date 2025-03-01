extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control
@export_file("*.tscn") var game_scene_name: String

@export_group("Buttons")
@export var arcade_button: Button
@export var puzzle_button: Button
@export var again_button: Button

func _ready() -> void:
	arcade_button.pressed.connect(start_arcade)
	puzzle_button.pressed.connect(start_puzzle)
	again_button.pressed.connect(start_again)

	ConfigCtl.load_config()
	Stats.read_stats()
	first_to_focus.grab_focus()

func start_arcade() -> void:
	Global.level_desc = {
		"type": &"arcade",
		"width": 16,
		"height": 11
	}

	Global.change_scene(game_scene_name)

func start_puzzle() -> void:
	Global.level_desc = {
		"type": &"puzzle",
		"width": 4,
		"height": 4,
		"level": [1,1,2,7,5,3,2,6,4,3,6,4,6,7,1,2]
	}

	Global.change_scene(game_scene_name)

func start_again() -> void:
	Global.change_scene(game_scene_name)
