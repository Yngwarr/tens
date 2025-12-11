extends PopupPanel

@export_file("*.tscn") var next_scene: String

@export_group("Internal")
@export var button_no: Button
@export var button_yes: Button


func _ready() -> void:
	button_no.pressed.connect(on_no_pressed)
	button_yes.pressed.connect(on_yes_pressed)


func on_no_pressed() -> void:
	hide()


func on_yes_pressed() -> void:
	PokiSDK.gameplayStop()
	call_deferred("change_scene")
	

func change_scene() -> void:
	get_tree().change_scene_to_file(next_scene)
