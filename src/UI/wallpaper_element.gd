class_name WallpaperElement
extends BoxContainer

@export_group("Internal")
@export var art: TextureRect


func init(texture: Texture2D) -> void:
	art.texture = texture
