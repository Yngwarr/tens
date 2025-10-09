class_name Pause
extends Node

## Must have [code]process_mode == PROCESS_MODE_WHEN_PAUSED[/code].
@export var pause_screen: PauseMenu


func pause() -> void:
	PokiSDK.gameplayStop()

	get_tree().paused = true
	pause_screen.pause()


func unpause() -> void:
	PokiSDK.gameplayStart()

	get_tree().paused = false
	pause_screen.unpause()
