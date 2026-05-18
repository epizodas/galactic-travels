class_name Hangar

var shipCapacity: int
var moduleCapacity: int

func _init(
	p_shipCapacity: int,
	p_moduleCapacity: int,
) -> void:
	self.shipCapacity = p_shipCapacity
	self.moduleCapacity = p_moduleCapacity

static func getSpaceshipModuleByType():
	pass
	
static func getHangarSpaceships():
	
	pass
