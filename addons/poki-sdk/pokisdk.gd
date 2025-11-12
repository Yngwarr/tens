extends Node

var sdk_handle = null
var _cb_commercial_break
var _cb_reward_break
var _cb_shareable_url

signal ad_started
signal ad_ended
signal commercial_break_ended(response)
signal rewarded_break_ended(success: bool)
signal shareable_url_ready(url)


# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.has_feature("poki"):
		return

	sdk_handle = JavaScriptBridge.get_interface("PokiSDK")
	_cb_commercial_break = JavaScriptBridge.create_callback(Callable(self, "on_commercial_break"))
	_cb_reward_break = JavaScriptBridge.create_callback(Callable(self, "on_reward_break"))
	_cb_shareable_url = JavaScriptBridge.create_callback(Callable(self, "on_shareable_url"))


func gameplayStart():
	if not OS.has_feature("poki"):
		print("simulating gameplayStart()")
		return

	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no gameplay started")
		return

	sdk_handle.gameplayStart()


func gameplayStop():
	if not OS.has_feature("poki"):
		print("simulating gameplayStop()")
		return

	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no gameplay stopped")
		return

	sdk_handle.gameplayStop()


func commercialBreak():
	if not OS.has_feature("poki"):
		print("simulating commercialBreak()")
		on_commercial_break({})
		return

	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no commercial break")
		return

	ad_started.emit()
	sdk_handle.commercialBreak().then(_cb_commercial_break)


func on_commercial_break(args):
	print("Commercial break done!")
	print(args)
	ad_ended.emit()
	commercial_break_ended.emit(args)


func rewardedBreak():
	if not OS.has_feature("poki"):
		print("simulating rewardedBreak()")
		on_reward_break([true])
		return

	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no rewarded break")
		return

	ad_started.emit()
	sdk_handle.rewardedBreak().then(_cb_reward_break)


func on_reward_break(args: Array):
	print("Reward break done!")
	ad_ended.emit()
	rewarded_break_ended.emit(args[0])


func shareableURL(obj: Dictionary):
	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no shareable URL")
		return

	var params = JavaScriptBridge.create_object("Object")

	for key in obj.keys():
		params[key] = obj[key]

	sdk_handle.shareableURL(params).then(_cb_shareable_url)


func on_shareable_url(url):
	shareable_url_ready.emit(url)


func isAdBlocked():
	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no add blocking check")
		return

	var ret = sdk_handle.isAdBlocked()
	return ret


func enableEventTracking():
	if not sdk_handle:
		push_warning("PokiSDK is not initialized, no event tracking")
		return

	sdk_handle.enableEventTracking()
