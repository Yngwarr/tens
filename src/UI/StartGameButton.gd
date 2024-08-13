extends Button

@export_file("*.tscn") var next_scene_name: String
@export var anim: AnimationPlayer

func _ready() -> void:
	pressed.connect(proceed)
	anim.animation_finished.connect(on_anim_finished)

func proceed() -> void:
	anim.play(&"hide")

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name != &"hide":
		return

	# this is 100% expected behavior
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene_name)
