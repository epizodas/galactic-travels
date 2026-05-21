class_name Hangar

var shipCapacity: int
var moduleCapacity: int

func _init(
	p_shipCapacity: int,
	p_moduleCapacity: int,
) -> void:
	self.shipCapacity = p_shipCapacity
	self.moduleCapacity = p_moduleCapacity

static func getSpaceshipModuleByType(moduleType: SpaceshipModule.Type):
	var moduleName = "modulis"
	for typeName in SpaceshipModule.Type:
		if SpaceshipModule.Type.get(typeName) == moduleType:
			moduleName = str(typeName)
			break

	var module = SpaceshipModule.new(moduleName, moduleType)
	return module
	
static func getHangarSpaceships():
	pass
