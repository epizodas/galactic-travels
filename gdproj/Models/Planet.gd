extends SpaceBody
class_name Planet

var atmHeight: float
var atmDensity: float
var hangarId: int

func _init(
	p_name: String,
	p_mass: float,
	p_temp: float,
	p_radius: float,
	p_color: String,
	p_orbitXOffset: float,
	p_orbitYOffset: float,
	p_orbitalPeriod: float,
	p_orbitalRadius: float,
	p_phase: float,
	p_fuelCost: float,
	p_atmHeight: float,
	p_atmDensity: float,
	p_hangarId: int
) -> void:
	super._init(
		p_name, 
		p_mass, 
		p_temp, 
		p_radius, 
		p_color, 
		p_orbitXOffset, 
		p_orbitYOffset, 
		p_orbitalPeriod, 
		p_orbitalRadius, 
		p_phase,
		p_fuelCost
	)
	atmHeight = p_atmHeight
	atmDensity = p_atmDensity
	hangarId = p_hangarId
	
static func fetchAllPlanets():
	var output = Database.db.select_rows(
	"planets",
	"",
	["id", "spaceBody_id", "hangar_id", "atmHeight", "atmDensity"])
	
	var retval: Array[Planet] = []
	for pd in output:
		var sb = Database.db.select_rows("spacebodies", "id = '%s'" % [pd.spaceBody_id], 
			["id", "name", "mass", "temp", "radius", "color", 
			"orbitXOffset", "orbitYOffset", "orbitalPeriod", "orbitalRadius", "phase"])
		if(len(sb) == 0):
			continue
		sb = sb[0]
		retval.push_back(new(sb.name, sb.mass, sb.temp, sb.radius, sb.color, 
			sb.orbitXOffset, sb.orbitYOffset, sb.orbitalPeriod, sb.orbitalRadius, 
			sb.phase, pd.atmHeight, pd.atmDensity, pd.hangar_id))

	return retval

func fetchPlanet(planet_id: int) -> Planet:
	var output = Database.db.select_rows(
	"planets",
	"id = '%s'" % [planet_id],
	["id", "name", "mass", "temp", "radius", "color", 
	"orbitXOffset", "orbitYOffset", "orbitalPeriod", "orbitalRadius",
	 "phase", "fuelCost", "atmHeight", "atmDensity", "hangar_id"])
	
	var planetData = output[0]	
	return new(
		planetData.name,
		planetData.mass,
		planetData.temp,
		planetData.radius,
		planetData.color,
		planetData.orbitXOffset,
		planetData.orbitYOffset,
		planetData.orbitalPeriod,
		planetData.orbitalRadius,
		planetData.phase,
		planetData.fuelCost,
		planetData.atmHeight,
		planetData.atmDensity,
		planetData.hangar_id
	)

func getPlanetHangar() -> Hangar :
	var output = Database.db.select_rows(
	"hangars",
	"id = '%s'" % [hangarId],
	["id", "shipCapacity", "moduleCapacity"])
	var hData = output[0]
	return Hangar.new(hData.shipCapacity, hData.moduleCapacity)
