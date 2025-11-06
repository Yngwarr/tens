class_name WallpaperElement
extends Control

signal wallpaper_changed(index: int)

@export_group("Internal")
@export var art: TextureRect
@export var selected: TextureRect
@export var locked: TextureRect
@export var button: Button
@export var anim: AnimationPlayer
@export var cost_label: Label

var cost: int
var index: int


func _ready() -> void:
	button.pressed.connect(on_wallpaper_pressed)


func init(p_index: int, p_cost: int) -> void:
	index = p_index
	cost = p_cost

	art.texture = Global.wallpaper_textures[index]
	cost_label.text = str(cost)

	if Stats.get_stat(&"games_played") < cost:
		locked.visible = true
	else:
		locked.visible = false


func on_wallpaper_pressed() -> void:
	if Stats.get_stat(&"games_played") < cost:
		anim.play("bounce")
	else:
		wallpaper_changed.emit(index)


func get_texture() -> Texture2D:
	return art.texture


func set_selected(on: bool) -> void:
	selected.visible = on
