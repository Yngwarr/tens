class_name SumLabel
extends Control

@export_group("Internal")
@export var view: Label
@export var anim: AnimationPlayer
@export var sound: AudioStreamPlayer
@export var particles: CPUParticles2D

var base_pitch: float

func _ready() -> void:
	view.visible = false
	base_pitch = sound.pitch_scale


func update_text(value: int) -> void:
	var is_target := value == Game.TARGET_SUM

	view.visible = value != 0

	view.text = ("%d!" % value) if is_target else str(value)

	if is_target:
		view.label_settings.outline_color = Color.FOREST_GREEN
	elif value > Game.TARGET_SUM:
		view.label_settings.outline_color = Color.DARK_RED
	else:
		view.label_settings.outline_color = Color.BLACK

	if is_target:
		anim.play(&"bounce")
		sound.pitch_scale = Tools.random_pitch(base_pitch)
		sound.play()
	else:
		anim.play(&"RESET")

func play_effect() -> void:
	particles.emitting = true
