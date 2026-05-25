class_name SpaceBody

var id: int
var name: String
var mass: float
var temp: float
var radius: float
var color: String
var orbitXOffset: float
var orbitYOffset: float
var orbitalPeriod: float
var orbitalRadius: float
var phase: float
var fuelCost: float

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
) -> void:
	name = p_name
	mass = p_mass
	temp = p_temp
	radius = p_radius
	color = p_color
	orbitXOffset = p_orbitXOffset
	orbitYOffset = p_orbitYOffset
	orbitalPeriod = p_orbitalPeriod
	orbitalRadius = p_orbitalRadius
	phase = p_phase
	
static func fetchAllSpaceBodies() -> Array[SpaceBody]:
	var output = Database.db.select_rows("spacebodies", "", ["id", "name", "mass", "temp", "radius", "color",
		"orbitXOffset","orbitYOffset","orbitalPeriod","orbitalRadius","phase"])
	var bodies: Array[SpaceBody] = [];
	for row in output:
		var body = SpaceBody.new(
			row.name, row.mass, row.temp, row.radius, row.color,
			row.orbitXOffset, row.orbitYOffset, row.orbitalPeriod, row.orbitalRadius, 
			row.phase
		)
		body.id = row.id
		bodies.append(body)

	return bodies
	
