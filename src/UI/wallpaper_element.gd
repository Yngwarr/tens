class_name WallpaperElement
extends Button

@export_group("Internal")
@export var art: TextureRect


func init(texture: Texture2D) -> void:
	art.texture = texture
