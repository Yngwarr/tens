class_name HintButton
extends TextureButton

@export var anim: AnimationPlayer


func demand_attention() -> void:
	anim.play(&"attention")


func calm_down() -> void:
	anim.play(&"RESET")
