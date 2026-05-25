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

static func fetchSpaceshipModules(ship_code: String) -> Array[SpaceshipModule]:
	var output = Database.db.select_rows(
		"spaceship_modules",
		"spaceship_id = '%s'" % [ship_code],
		["name", "module_ability_id"]
	)
	
	var retval: Array[SpaceshipModule] = []
	for moduleData in output:
		var m_type = moduleData.module_ability_id as Type
		retval.push_back(SpaceshipModule.new(
			moduleData.name,
			m_type
		))
	return retval