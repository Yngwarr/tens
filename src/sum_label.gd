class_name SumLabel
extends Control

@export_group("Internal")
@export var view: Label
@export var anim: AnimationPlayer

func _ready() -> void:
	view.visible = false

func update_text(value: int) -> void:
	var is_target := value == Game.TARGET_SUM
	
	if value == 0: 
		view.visible = false
	else: 
		view.visible = true
	
	view.text = ("%d!" % value) if is_target else str(value)
	
	if is_target:
		view.label_settings.outline_color = Color.FOREST_GREEN 
	else:
		view.label_settings.outline_color = Color.DARK_RED


	if is_target:
		anim.play(&"bounce")
	else:
		anim.play(&"RESET")
