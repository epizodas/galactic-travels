extends CanvasLayer
class_name ToastLayer

const MAX_VISIBLE_TOASTS := 4

var _toast_container: VBoxContainer

func _ready() -> void:
	_setup_ui()

func show_message(message: String, duration: float = 2.5) -> void:
	if message.strip_edges().is_empty():
		return

	if _toast_container == null:
		_setup_ui()

	var cur_time = Time.get_unix_time_from_system()
	while _toast_container.get_child_count() >= MAX_VISIBLE_TOASTS && (Time.get_unix_time_from_system() - cur_time < 5) :
		_toast_container.get_child(0).queue_free()

	var toast := _build_toast(message)
	_toast_container.add_child(toast)

	toast.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(toast, "modulate:a", 1.0, 0.15)
	tween.tween_interval(max(duration, 0.2))
	tween.tween_property(toast, "modulate:a", 0.0, 0.2)
	tween.finished.connect(func():
		if is_instance_valid(toast):
			toast.queue_free()
	)

func _setup_ui() -> void:
	if _toast_container != null:
		return

	layer = 100

	var root_margin := MarginContainer.new()
	root_margin.name = "RootMargin"
	root_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_margin.anchor_left = 1.0
	root_margin.anchor_right = 1.0
	root_margin.anchor_top = 0.0
	root_margin.anchor_bottom = 1.0
	root_margin.offset_left = -360.0
	root_margin.offset_right = -16.0
	root_margin.offset_top = 16.0
	root_margin.offset_bottom = -16.0
	add_child(root_margin)

	_toast_container = VBoxContainer.new()
	_toast_container.name = "ToastContainer"
	_toast_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_toast_container.alignment = BoxContainer.ALIGNMENT_END
	_toast_container.set("theme_override_constants/separation", 8)
	root_margin.add_child(_toast_container)

func _build_toast(message: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.14, 0.20, 0.96)
	style.border_color = Color(0.38, 0.55, 0.92, 1.0)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set("theme_override_constants/margin_left", 12)
	margin.set("theme_override_constants/margin_top", 8)
	margin.set("theme_override_constants/margin_right", 12)
	margin.set("theme_override_constants/margin_bottom", 8)
	panel.add_child(margin)

	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	margin.add_child(label)

	return panel
