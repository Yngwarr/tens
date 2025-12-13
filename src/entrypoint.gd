extends Node2D

@export var game_scene: PackedScene
@export var tutorial_scene: PackedScene


func _ready() -> void:
	call_deferred(&"jump_scenes")


func jump_scenes() -> void:
	var show_tutorial: bool = ConfigCtl.get_pref(&"show_tutorial")
	get_tree().change_scene_to_packed(tutorial_scene if show_tutorial else game_scene)
