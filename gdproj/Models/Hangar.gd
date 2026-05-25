class_name Hangar

var shipCapacity: int
var moduleCapacity: int
var id: int

static var modules: Array[SpaceshipModule] = [
	SpaceshipModule.new("Greitis", SpaceshipModule.Type.Speed),
	SpaceshipModule.new("Skydas", SpaceshipModule.Type.Shield)
]

func _init(
	p_id: int,
	p_shipCapacity: int,
	p_moduleCapacity: int,
) -> void:
	self.id = p_id
	self.shipCapacity = p_shipCapacity
	self.moduleCapacity = p_moduleCapacity

static func getSpaceshipModuleByType(moduleType: SpaceshipModule.Type) -> SpaceshipModule:
	var modIdx = modules.find_custom(func(mod): return mod.type == moduleType)
	if modIdx == -1:
		return null
	return modules[modIdx]
	
func getHangarSpaceships() -> Array[Spaceship]:
	var output = Database.db.select_rows(
		"spaceship",
		"hangar_id = '%s'" % [id],
		["name", "code", "speed", "maxTemp", "cargoLength", "cargoWidth", "category", "fuelCapacity", "fuelConsumption", "moduleCapacity"])
	
	var retval: Array[Spaceship] = []
	for spaceshipData in output:
		retval.push_back(Spaceship.new(
			spaceshipData.name,
			spaceshipData.code,
			spaceshipData.speed,
			spaceshipData.maxTemp,
			spaceshipData.cargoLength,
			spaceshipData.cargoWidth,
			spaceshipData.category,
			spaceshipData.fuelCapacity,
			spaceshipData.fuelConsumption,
			spaceshipData.moduleCapacity
	))

	return retval
	
