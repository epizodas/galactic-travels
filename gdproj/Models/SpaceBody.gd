class_name SpaceBody

var name: String
var code: String
var mass: float
var temp: float
var radius: float
var color: float
var orbitXOffset: float
var orbitYOffset: float
var orbitalPeriod: float
var orbitalRadius: float
var phase: float

func _init(
	p_name: String,
	p_code: String,
	p_mass: float,
	p_temp: float,
	p_radius: float,
	p_color: float,
	p_orbitXOffset: float,
	p_orbitYOffset: float,
	p_orbitalPeriod: float,
	p_orbitalRadius: float,
	p_phase: float
) -> void:
	name = p_name
	code = p_code
	mass = p_mass
	temp = p_temp
	radius = p_radius
	color = p_color
	orbitXOffset = p_orbitXOffset
	orbitYOffset = p_orbitYOffset
	orbitalPeriod = p_orbitalPeriod
	orbitalRadius = p_orbitalRadius
	phase = p_phase
