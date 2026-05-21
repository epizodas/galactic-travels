extends ItemList
class_name ModuleChooserList

@export var selected_list: bool = false

func _ready() -> void:
	select_mode = SELECT_SINGLE

func add_module(module: SpaceshipModule) -> void:
	add_item(module.name)
	set_item_metadata(get_item_count() - 1, module)

func remove_module(module: SpaceshipModule) -> void:
	var module_index := _find_module_index(module)
	if module_index != -1:
		remove_item(module_index)

func _find_module_index(module: SpaceshipModule) -> int:
	for index in range(get_item_count()):
		if get_item_metadata(index) == module:
			return index
	return -1

func _find_item_at_position(mouse_position: Vector2) -> int:
	return get_item_at_position(mouse_position, true)

func _get_drag_data(at_position: Vector2) -> Variant:
	var module_index := _find_item_at_position(at_position)
	if module_index == -1:
		return null

	var module := get_item_metadata(module_index) as SpaceshipModule
	if module == null:
		return null

	var preview := Label.new()
	preview.text = module.name
	set_drag_preview(preview)

	return {
		"source_list": self ,
		"module": module,
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not (data is Dictionary):
		return false

	if not data.has("source_list") or not data.has("module"):
		return false

	var source_list = data["source_list"]
	if source_list == null or source_list == self:
		return false

	return source_list.has_method("remove_module")

# func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
# 	return data is Dictionary \
# 		and data.has("source_list") \
# 		and data["source_list"] is ItemList \
# 		and data["source_list"] != self \
# 		and data["source_list"].has_method("remove_module") \
# 		and data.has("module") \
# 		and data["module"] is SpaceshipModule

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not _can_drop_data(at_position, data):
		return

	var source_list: ModuleChooserList = data["source_list"]
	var module: SpaceshipModule = data["module"]

	source_list.remove_module(module)
	add_module(module)
	
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView

	if selected_list:
		FlightViewRef.selectModule(module)
	else:
		FlightViewRef.deselectModule(module)
