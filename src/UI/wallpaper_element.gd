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
	pressed.connect(func(): wallpaper_changed.emit(art.texture))

func init(texture: Texture2D) -> void:
	art.texture = texture

func _ready() -> void:
	button.pressed.connect(on_wallpaper_pressed)
	if star_count <= stars_needed:
		locked.visible = true
	else:
		locked.visible = false

func on_wallpaper_pressed() -> void:
	if star_count >= stars_needed:
		if selected.visible == true:
			selected.visible = false
		else:
			selected.visible = true
	else:
		anim.play("bounce")
