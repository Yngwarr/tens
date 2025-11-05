extends CanvasLayer

@export_group("Internal")
@export var bg_rect: TextureRect


func change_bg(texture: Texture2D) -> void:
	bg_rect.texture = texture


func get_texture() -> Texture2D:
	return bg_rect.texture
