class_name HintButton
extends TextureButton

@export var anim: AnimationPlayer
@export var hint_label: Label
@export var ad_label: TextureRect
@export var button: TextureButton

var hint_count := 5


func _ready() -> void:
	update_label()
	button.pressed.connect(on_button_pressed)


func demand_attention() -> void:
	anim.play(&"attention")


func calm_down() -> void:
	anim.play(&"RESET")


func update_label() -> void:
	if hint_count > 0:
		ad_label.visible = false
		hint_label.text = str(hint_count)
		hint_label.visible = true
	else:
		hint_label.visible = false
		ad_label.visible = true


func show_ad() -> void:
	hint_count = 5


func on_button_pressed() -> void:
	if hint_count > 0:
		hint_count = hint_count - 1
		update_label()
	else:
		show_ad()
		update_label()
