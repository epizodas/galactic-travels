class_name SpaceshipModule

enum Type {
	Temperature,
	Sheld,
	Fuel,
	Speed
}

var name: String
var type: Type

func _init(
	module_name: String,
	module_type: Type,
) -> void:
	self.name = module_name
	self.type = module_type
