extends Node
class_name ToastController

func show_message(message: String, duration: float = 2.5) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return

	var toast_layer := scene.find_child("ToastLayer", true, false)
	if toast_layer != null and toast_layer.has_method("show_message"):
		toast_layer.show_message(message, duration)
	else:
		push_warning("ToastLayer not found, message was: %s" % message)

func show(message: String, duration: float = 2.5) -> void:
	show_message(message, duration)
