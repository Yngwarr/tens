class_name SumLabel
extends Control

@export_group("Internal")
@export var view: Label
@export var anim: AnimationPlayer

var default_font_color: Color


func _ready() -> void:
	default_font_color = view.label_settings.font_color


func update_text(value: int) -> void:
	var is_target := value == Game.TARGET_SUM

	view.text = ("%d!" % value) if is_target else str(value)
	view.label_settings.font_color = Color.LIME if is_target else default_font_color

	if is_target:
		anim.play(&"bounce")
	else:
		anim.play(&"RESET")
