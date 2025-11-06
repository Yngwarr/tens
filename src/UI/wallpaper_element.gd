class_name WallpaperElement
extends Control

signal wallpaper_changed(texture: Texture2D)

@export_group("Internal")
@export var art: TextureRect
@export var selected: TextureRect
@export var locked: TextureRect
@export var button: Button
@export var anim: AnimationPlayer
@export var cost_label: Label

var cost: int


func _ready() -> void:
	button.pressed.connect(on_wallpaper_pressed)


func init(texture: Texture2D, p_cost: int) -> void:
	art.texture = texture
	cost = p_cost
	cost_label.text = str(cost)

	if Stats.get_stat(&"games_played") < cost:
		locked.visible = true
	else:
		locked.visible = false


func on_wallpaper_pressed() -> void:
	if Stats.get_stat(&"games_played") < cost:
		anim.play("bounce")
	else:
		wallpaper_changed.emit(art.texture)


func get_texture() -> Texture2D:
	return art.texture


func set_selected(on: bool) -> void:
	selected.visible = on
