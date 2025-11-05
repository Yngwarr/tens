class_name WallpaperElement
extends Control

signal wallpaper_changed(texture: Texture2D)

@export_group("Internal")
@export var art: TextureRect
@export var selected: NinePatchRect
@export var locked: NinePatchRect
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

	if star_count >= stars_needed:
		selected.visible = not selected.visible
	else:
		anim.play("bounce")
