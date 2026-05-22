class_name Hangar

var shipCapacity: int
var moduleCapacity: int

static var modules: Array[SpaceshipModule] = [
	SpaceshipModule.new("Greitis", SpaceshipModule.Type.Speed),
	SpaceshipModule.new("Skydas", SpaceshipModule.Type.Sheld)
]

func _init(
	p_shipCapacity: int,
	p_moduleCapacity: int,
) -> void:
	self.shipCapacity = p_shipCapacity
	self.moduleCapacity = p_moduleCapacity

static func getSpaceshipModuleByType(moduleType: SpaceshipModule.Type) -> SpaceshipModule:
	var modIdx = modules.find_custom(func(mod): return mod.type == moduleType)
	if modIdx == -1:
		return null
	return modules[modIdx]
	
static func getHangarSpaceships():
	pass
