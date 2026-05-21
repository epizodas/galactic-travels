extends Node
class_name FlightController

var _planets: Array[SpaceBody] = []
var _spaceship: Spaceship = null

var _selectedModules: Array[SpaceshipModule] = []

func openFlightView():
	var planets: Array[Planet] = Planet.fetchAllPlanets()

	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false

	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(planets)

	storedPlanets = planets.duplicate_deep()

var storedPlanets: Array[Planet]

var departPlanet: Planet
var destPlanet: Planet

func rememberPlanets(depart: Planet, dest: Planet):
	departPlanet = depart
	destPlanet = dest
	pass

func submitPlanets():
	rememberPlanets(null, null)
	printerr("Sita tikrai matysit, TODO submitPlanets()")
	#Planet.getPlanetHangar()
	pass

func getRememberedPlanets():
	pass

func getRememberedSpaceship():
	pass

func getRoute():
	return null

func selectModule(module: SpaceshipModule):
	if not _selectedModules.has(module):
		_selectedModules.append(module)
	
func deselectModule(module: SpaceshipModule):
	_selectedModules.erase(module)

func getSelectedModules() -> Array[SpaceshipModule]:
	return _selectedModules.duplicate()

func changeSpaceshipModules():
	var moduleTypes = SpaceshipModule.Type

	var availableModules: Array[SpaceshipModule] = []

	for type in moduleTypes:
		var mod_type = SpaceshipModule.Type.get(type)
		var module = Hangar.getSpaceshipModuleByType(mod_type)

		if not module:
			continue

		availableModules.append(module)

	var route = getRoute()

	if route:
		var shieldModule = availableModules.find_custom(func(m): return m.type == SpaceshipModule.Type.Sheld)
		if shieldModule:
			selectModule(shieldModule)

	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	print(availableModules)
	FlightViewRef.displayAvailableModules(availableModules)

func submitModules():
	var selected_modules = getSelectedModules()
	
	if _spaceship:
		var ok = _spaceship.assignModules(selected_modules)
		if not ok:
			pass
	
	var speedModule = selected_modules.find_custom(func(m): return m.type == SpaceshipModule.Type.Speed)
	if speedModule != -1:
		return "Reikia pergeneruoti maršrutą"
		
	return null

func getRememberedNeededFuel():
	pass

func calculateTotalCosts():
	var totalCost = 0.0
	for module in _selectedModules:
		totalCost += module.cost
	return totalCost

var simulationPlanets: Array[SimulatedPlanet]
var currentTime = 0
var step = 0
var endTime = 0

func validateEndDate(date):
	var curDate = Time.get_date_dict_from_system()
	curDate.hour = 0
	curDate.minute = 0
	curDate.second = 0

	var sysTime = Time.get_unix_time_from_datetime_dict(curDate)
	endTime = Time.get_unix_time_from_datetime_dict(date)
	var comp = endTime > sysTime
	if comp:
		currentTime = sysTime
		for planet in storedPlanets:
			var simPlanet = SimulatedPlanet.new(planet)
			simPlanet.x = (sin((sysTime + planet.phase)*planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitXOffset
			simPlanet.y = (cos((sysTime + planet.phase)*planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitYOffset
			simulationPlanets.append(SimulatedPlanet.new(planet))
	return comp

func findShortestDistance():
	var outerPlanet: Planet
	var innerPlanet: Planet
	if destPlanet.orbitalRadius < departPlanet.orbitalRadius:
		outerPlanet = departPlanet
		innerPlanet = destPlanet
	else:
		outerPlanet = destPlanet
		innerPlanet = departPlanet

	var innerRadius = innerPlanet.orbitalRadius + innerPlanet.radius
	var outerRadius = outerPlanet.orbitalRadius - outerPlanet.radius
	var distanceBetweenCenters = sqrt(
		pow(innerPlanet.orbitXOffset - outerPlanet.orbitXOffset, 2) +
		pow(innerPlanet.orbitYOffset - outerPlanet.orbitYOffset, 2))
	return outerRadius - innerRadius - distanceBetweenCenters

func simulationStep():
	currentTime += step
	pass

func calculateBodyPositions():
	for simPlanet in simulationPlanets:
		var planet = simPlanet.planet
		simPlanet.x = sin((currentTime + planet.phase)*planet.orbitalPeriod) + planet.orbitXOffset
		simPlanet.y = cos((currentTime + planet.phase)*planet.orbitalPeriod) + planet.orbitYOffset

func compareOrbitDistances():
	var departSim: SimulatedPlanet
	var destSim: SimulatedPlanet
	for sim in simulationPlanets:
		if sim.planet == departPlanet:
			departSim = sim
		elif sim.planet == destPlanet:
			destSim = sim
	if departSim == null or destSim == null:
		return -1
	return sqrt(
		pow(departSim.x - destSim.x, 2) +
		pow(departSim.y - destSim.y, 2))

func calculateNewStep(curDistDiff: float, lastDistDiff: float) -> void:
	if curDistDiff < 0:
		step *= 0.9
		step = max(step, 0.001)
	elif curDistDiff > 0 and lastDistDiff > 0:
		step *= 1.1
		step = min(step, 1.0)

var flag = 0

func setFlag():
	flag += 1

func calculateFuelUsage(distance, ship):
	# TODO: Kai augis padarys erdvelaivio issaugojima,
	# padaryti actual fuel usage calculation
	return distance

func checkForCollisions(departSim: SimulatedPlanet, destSim: SimulatedPlanet, allSims: Array[SimulatedPlanet]) -> float:
	var ax = departSim.x
	var ay = departSim.y
	var bx = destSim.x
	var by = destSim.y
	var dx = bx - ax
	var dy = by - ay
	var segLenSq = dx * dx + dy * dy
	var totalGraze = 0.0

	for sim in allSims:
		if sim == departSim or sim == destSim:
			continue
		var cx = sim.x
		var cy = sim.y
		var planetRadius = sim.planet.radius
		var atmRadius = planetRadius + sim.planet.atmHeight

		var fx = ax - cx
		var fy = ay - cy
		var t = clamp((fx * dx + fy * dy) / segLenSq, 0.0, 1.0)
		var closestX = ax + t * dx
		var closestY = ay + t * dy
		var distSq = (cx - closestX) * (cx - closestX) + (cy - closestY) * (cy - closestY)
		var dist = sqrt(distSq)

		if dist < planetRadius:
			return -1.0
		elif dist < atmRadius:
			var halfChord = sqrt(atmRadius * atmRadius - dist * dist)
			totalGraze += 2.0 * halfChord

	return totalGraze

func checkForAsteroidBelt(beltRadius: float) -> bool:
	var departSim: SimulatedPlanet
	var destSim: SimulatedPlanet
	for s in simulationPlanets:
		if s.planet == departPlanet:
			departSim = s
		elif s.planet == destPlanet:
			destSim = s
	if departSim == null or destSim == null:
		return false

	var ax = departSim.x
	var ay = departSim.y
	var bx = destSim.x
	var by = destSim.y
	var dx = bx - ax
	var dy = by - ay
	var segLenSq = dx * dx + dy * dy
	if segLenSq == 0:
		return false

	var fx = ax
	var fy = ay
	var t = clamp((fx * dx + fy * dy) / segLenSq, 0.0, 1.0)
	var closestX = ax + t * dx
	var closestY = ay + t * dy
	var distSq = closestX * closestX + closestY * closestY

	return distSq < beltRadius * beltRadius


func findRoute():
	findShortestDistance()
	var curDistDiff = -1
	var lastDistDiff = -1
	var lastDist = -1
	while true:
		flag = 0
		simulationStep()
		if currentTime > endTime:
			return 0
		calculateBodyPositions()
		var curDist = compareOrbitDistances()
		if lastDist == -1:
			lastDist = curDist
		curDistDiff = curDist - lastDist
		if curDistDiff < 0:
			calculateNewStep(curDistDiff, lastDistDiff)
		elif curDistDiff > 0:
			if lastDistDiff <= 0:
				setFlag()
				var fuelUsage = calculateFuelUsage(curDist, null) # TODO: ship
				var fuelCapacity = 1000 # TODO: ship
				if fuelUsage < fuelCapacity:
					var departSim: SimulatedPlanet
					var destSim: SimulatedPlanet
					for s in simulationPlanets:
						if s.planet == departPlanet:
							departSim = s
						elif s.planet == destPlanet:
							destSim = s
					var collisionResult = checkForCollisions(departSim, destSim, simulationPlanets)
					var maxTemperature = 1 # TODO: ship
					if collisionResult == -1:
						continue # Collision with planet
					if collisionResult > maxTemperature:
						var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
						RouteViewRef.addWarning("Temperatūra viršyja erdvėlaivio leidžiamą ribą")
					if checkForAsteroidBelt(1000):
						var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
						RouteViewRef.addWarning("Erdvėlaivis kirs asteroidų žiedą")
					setFlag()
					pass
				if flag == 2:
					return currentTime
			else:
				calculateNewStep(curDistDiff, lastDistDiff)
				
				
		lastDistDiff = curDistDiff

func saveCurrentRoute():
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(storedPlanets)
	pass # TODO
