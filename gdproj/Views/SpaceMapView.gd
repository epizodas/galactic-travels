extends Control
class_name SpaceMapView

@onready var _root_vbox: VBoxContainer = $VBoxContainer

var _content_row: HBoxContainer
var _map_area: Control
var _overlay_root: Control
var _info_panel: PanelContainer
var _info_scroll: ScrollContainer
var _info_title: Label
var _info_details: Label
var _zoom_level: float = 1.0
var _elapsed_time: float = 0.0

const MIN_ZOOM := 0.5
const MAX_ZOOM := 2.5
const ZOOM_STEP := 1.1
const ORBIT_SPEED := 0.02

func _ready() -> void:
	_ensure_map_layout()
	_apply_zoom()
	_hide_info_panel()
	set_process(true)

func _process(delta: float) -> void:
	if not visible or _map_area == null:
		return

	_elapsed_time += delta * 10000
	_layout_planet_buttons()

func displaySpaceMap(planets: Array[Button]):
	_ensure_map_layout()
	#_zoom_level = 1.0
	_elapsed_time = 0.0
	_clear_map()
	for planet in planets:
		_map_area.add_child(planet)
	visible = true
	_apply_zoom()
	call_deferred("_layout_planet_buttons")
	_hide_info_panel()
	
func exitSpaceMap():
	var main_view = get_tree().current_scene.find_child("MainView", true, false) as MainView
	if main_view:
		main_view.displayMainPage()
	visible = false
	
func selectSpaceBody(body: SpaceBody, planet: Planet = null) -> void:
	_ensure_map_layout()
	_info_panel.visible = true
	_info_title.text = body.name
	if planet != null:
		_info_details.text = _formatPlanetInfo(planet)
	else:
		_info_details.text = _formatSpaceBodyInfo(body)

func selectPlanet(planet: Planet):
	#selectSpaceBody(planet, planet)
	var planetData = _spaceMapController.getSpaceBodyInfo(planet)
	
	_ensure_map_layout()
	_info_panel.visible = true
	_info_title.text = planet.name
	_info_details.text = _formatPlanetInfo(planet)

func selectSun() -> void:
	#_ensure_map_layout()
	#_info_panel.visible = true
	#_info_title.text = "Sun"
	#_info_details.text = _formatSunInfo()
	pass

func _on_map_area_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_info_panel()

func _unhandled_input(event: InputEvent) -> void:
	if not visible or _map_area == null:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_adjust_zoom(ZOOM_STEP)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_adjust_zoom(1.0 / ZOOM_STEP)
			get_viewport().set_input_as_handled()

func _ensure_map_layout() -> void:
	if _content_row == null:
		_content_row = _root_vbox.get_node_or_null("ContentRow") as HBoxContainer
		if _content_row == null:
			_content_row = HBoxContainer.new()
			_content_row.name = "ContentRow"
			_content_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_content_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
			_root_vbox.add_child(_content_row)

	if _overlay_root == null:
		_overlay_root = get_node_or_null("OverlayRoot") as Control
		if _overlay_root == null:
			_overlay_root = Control.new()
			_overlay_root.name = "OverlayRoot"
			_overlay_root.anchor_left = 0.0
			_overlay_root.anchor_top = 0.0
			_overlay_root.anchor_right = 1.0
			_overlay_root.anchor_bottom = 1.0
			_overlay_root.offset_left = 0.0
			_overlay_root.offset_top = 0.0
			_overlay_root.offset_right = 0.0
			_overlay_root.offset_bottom = 0.0
			_overlay_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
			add_child(_overlay_root)

	if _map_area == null:
		_map_area = _content_row.get_node_or_null("MapArea") as Control
		if _map_area == null:
			_map_area = Control.new()
			_map_area.name = "MapArea"
			_map_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_map_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
			_map_area.mouse_filter = Control.MOUSE_FILTER_STOP
			_content_row.add_child(_map_area)
		if not _map_area.gui_input.is_connected(_on_map_area_gui_input):
			_map_area.gui_input.connect(_on_map_area_gui_input)
		if not _map_area.resized.is_connected(_layout_planet_buttons):
			_map_area.resized.connect(_layout_planet_buttons)

	if _info_title == null or _info_details == null:
		_info_panel = _overlay_root.get_node_or_null("InfoPanel") as PanelContainer
		if _info_panel == null:
			_info_panel = PanelContainer.new()
			_info_panel.name = "InfoPanel"
			_info_panel.custom_minimum_size = Vector2(280, 0)
			_info_panel.anchor_left = 1.0
			_info_panel.anchor_top = 0.0
			_info_panel.anchor_right = 1.0
			_info_panel.anchor_bottom = 1.0
			_info_panel.offset_left = -320.0
			_info_panel.offset_top = 0.0
			_info_panel.offset_right = -16.0
			_info_panel.offset_bottom = 0.0
			_overlay_root.add_child(_info_panel)
		_info_panel.visible = false

		_info_scroll = _info_panel.get_node_or_null("Scroll") as ScrollContainer
		if _info_scroll == null:
			_info_scroll = ScrollContainer.new()
			_info_scroll.name = "Scroll"
			_info_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_info_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
			_info_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
			_info_panel.add_child(_info_scroll)

		var info_margin = _info_scroll.get_node_or_null("Margin") as MarginContainer
		if info_margin == null:
			info_margin = MarginContainer.new()
			info_margin.name = "Margin"
			info_margin.set("theme_override_constants/margin_left", 12)
			info_margin.set("theme_override_constants/margin_top", 12)
			info_margin.set("theme_override_constants/margin_right", 12)
			info_margin.set("theme_override_constants/margin_bottom", 12)
			info_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			info_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
			_info_scroll.add_child(info_margin)

		var info_box = info_margin.get_node_or_null("InfoBox") as VBoxContainer
		if info_box == null:
			info_box = VBoxContainer.new()
			info_box.name = "InfoBox"
			info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			info_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
			info_margin.add_child(info_box)

		_info_title = info_box.get_node_or_null("Title") as Label
		if _info_title == null:
			_info_title = Label.new()
			_info_title.name = "Title"
			_info_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			info_box.add_child(_info_title)

		_info_details = info_box.get_node_or_null("Details") as Label
		if _info_details == null:
			_info_details = Label.new()
			_info_details.name = "Details"
			_info_details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			_info_details.size_flags_vertical = Control.SIZE_EXPAND_FILL
			info_box.add_child(_info_details)

func _clear_map() -> void:
	for child in _map_area.get_children():
		child.queue_free()

func _layout_planet_buttons() -> void:
	if _map_area == null:
		return

	var center = _map_area.size / 2
	_map_area.pivot_offset = center
	for child in _map_area.get_children():
		if child is Button and child.has_meta("space_body"):
			var body = child.get_meta("space_body") as SpaceBody
			if body:
				var period = max(body.orbitalPeriod, 0.001)
				var orbit_angle = (_elapsed_time * ORBIT_SPEED * TAU / period) + body.phase
				var orbit_offset = Vector2(body.orbitalRadius, 0).rotated(orbit_angle)
				child.position = center + Vector2(body.orbitXOffset, body.orbitYOffset) + orbit_offset - Vector2(body.radius, body.radius)

func _apply_zoom() -> void:
	if _map_area == null:
		return

	_map_area.scale = Vector2.ONE * _zoom_level
	_layout_planet_buttons()

func _adjust_zoom(multiplier: float) -> void:
	_zoom_level = clampf(_zoom_level * multiplier, MIN_ZOOM, MAX_ZOOM)
	_apply_zoom()

func _hide_info_panel() -> void:
	if _info_panel != null:
		_info_panel.visible = false

func _formatPlanetInfo(planet: Planet) -> String:
	return """
ID: %s
Masė: %s
Temperatūra: %s
Spindulys: %s
Orbita nuo centro: (%s, %s)
Orbitinis spindulys: %s
Periodas: %s
Atmosfera: aukštis %s, tankis %s
Kuro kaina: %s
""" % [
		str(planet.id),
		str(planet.mass),
		str(planet.temp),
		str(planet.radius),
		str(planet.orbitXOffset),
		str(planet.orbitYOffset),
		str(planet.orbitalRadius),
		str(planet.orbitalPeriod),
		str(planet.atmHeight),
		str(planet.atmDensity),
		str(planet.fuelCost)
	]

func _formatSpaceBodyInfo(body: SpaceBody) -> String:
	return """
ID: %s
Masė: %s
Temperatūra: %s
Spindulys: %s
Orbita nuo centro: (%s, %s)
Orbitinis spindulys: %s
Periodas: %s
""" % [
		str(body.id),
		str(body.mass),
		str(body.temp),
		str(body.radius),
		str(body.orbitXOffset),
		str(body.orbitYOffset),
		str(body.orbitalRadius),
		str(body.orbitalPeriod)
	]

func _formatSunInfo() -> String:
	return "Center of the solar system\n\nThe Sun does not orbit. It remains fixed at the middle of the map while the planets move around it."
