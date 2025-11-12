class_name HintButton
extends TextureButton

@export var anim: AnimationPlayer
@export var hint_label: Label
@export var ad_icon: TextureRect
@export var button: TextureButton


func demand_attention() -> void:
	anim.play(&"attention")


func calm_down() -> void:
	anim.play(&"RESET")


func update_label(hint_count: int) -> void:
	var show_icon := hint_count == 0

	ad_icon.visible = show_icon
	hint_label.visible = not show_icon

	if not show_icon:
		hint_label.text = str(hint_count)
