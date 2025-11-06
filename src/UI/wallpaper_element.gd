class_name WallpaperElement
extends Control

signal wallpaper_changed(texture: Texture2D)

@export_group("Internal")
@export var art: TextureRect
@export var selected: TextureRect
@export var locked: TextureRect
@export var button: Button
@export var anim: AnimationPlayer

var star_count = 6
var stars_needed = 5


func _ready() -> void:
	button.pressed.connect(on_wallpaper_pressed)

	if star_count <= stars_needed:
		locked.visible = true
	else:
		locked.visible = false


func init(texture: Texture2D) -> void:
	art.texture = texture


func on_wallpaper_pressed() -> void:
	wallpaper_changed.emit(art.texture)

	if star_count < stars_needed:
		anim.play("bounce")


func get_texture() -> Texture2D:
	return art.texture


func set_selected(on: bool) -> void:
	selected.visible = on
