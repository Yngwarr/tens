class_name HintButton
extends TextureButton

@export var anim: AnimationPlayer
@export var hint_label: Label
@export var ad_icon: TextureRect
@export var button: TextureButton

var hint_count := Global.DEFAULT_HINT_COUNT


func _ready() -> void:
	update_label()
	button.pressed.connect(on_button_pressed)


func demand_attention() -> void:
	anim.play(&"attention")


func calm_down() -> void:
	anim.play(&"RESET")


func update_label() -> void:
	var show_icon := hint_count == 0

	ad_icon.visible = show_icon
	hint_label.visible = not show_icon

	if not show_icon:
		hint_label.text = str(hint_count)


func show_ad() -> void:
	hint_count = Global.REWARDED_AD_HINTS


func on_button_pressed() -> void:
	if hint_count > 0:
		hint_count -= 1
	else:
		show_ad()

	update_label()
