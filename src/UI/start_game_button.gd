extends Button

@export_file("*.tscn") var game_scene_name: String
@export_file("*.tscn") var tutorial_scene_name: String
@export var anim: AnimationPlayer


func _ready() -> void:
	pressed.connect(proceed)
	anim.animation_finished.connect(on_anim_finished)


func proceed() -> void:
	anim.play(&"hide")


func on_anim_finished(anim_name: StringName) -> void:
	if anim_name != &"hide":
		return

	var next_scene := game_scene_name

	if ConfigCtl.get_pref(&"show_tutorial"):
		next_scene = tutorial_scene_name
		ConfigCtl.set_pref(&"show_tutorial", false)

	get_tree().change_scene_to_file(next_scene)
