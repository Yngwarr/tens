@tool
class_name StatsWindow
extends PopupPanel

@export var label_container: Node

func _ready() -> void:
	if Engine.is_editor_hint():
		render_stats()
	else:
		visibility_changed.connect(on_toggle)

func on_toggle() -> void:
	if not visible:
		return

	render_stats()

func render_stats() -> void:
	var child_count := label_container.get_child_count()
	# Here we assume that (1) all the children are labels and (2) if there are
	# labels, the amount of them is exactly the amount of stats. The assumption
	# is based on the fact that only this code fiddles with the content of the
	# label_container, if this is not true, the code will break in the way
	# scientists call "utter bullshit".
	if child_count > 0:
		var keys := Stats.data.keys()
		for i in range(child_count):
			var label := label_container.get_child(i) as Label
			label.text = stat_to_string(Stats.data[keys[i]])
	else:
		for x in Stats.data:
			var label := Label.new()
			label.text = stat_to_string(Stats.data[x])
			label_container.add_child(label)

func stat_to_string(stat: Dictionary) -> String:
	return "%s: %s" % [stat.name, stat.value]
