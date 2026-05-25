extends Node
class_name FlightController

var _planets: Array[SpaceBody] = []
var _spaceship: Spaceship = null
var _neededFuel: float = 0.0
var _pilot: Pilot = null
var _tripDurationHours: int = 0
var _orders: Array[Order] = []

var _selectedModules: Array[SpaceshipModule] = []

func submit():
	pass

func openFlightView():
	var planets: Array[Planet] = Planet.fetchAllPlanets()

	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false

	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(planets)

	storedPlanets = planets.duplicate_deep()
	destPlanet = storedPlanets[0]
	departPlanet = storedPlanets[0]

var storedPlanets: Array[Planet]

var departPlanet: Planet
var destPlanet: Planet

func rememberPlanets(depart: Planet, dest: Planet):
	departPlanet = depart
	destPlanet = dest
	pass

func checkSpaceshipAmount(spaceships: Array[Spaceship]):
	return len(spaceships) > 0

func submitPlanets(id1, id2) -> Array[Spaceship]:
	rememberPlanets(storedPlanets[id1], storedPlanets[id2])
	
	var hangar = storedPlanets[id1].getPlanetHangar()
	var spaceships = hangar.getHangarSpaceships()
	if checkSpaceshipAmount(spaceships):
		return spaceships
	return []

# Mistakes were made.
var rememberedSpaceship: Spaceship
func rememberSpaceship(spaceship: Spaceship):
	rememberedSpaceship = spaceship
	
func submitSpaceship(spaceship: Spaceship):
	rememberSpaceship(spaceship)
	return true

func getRoute() -> Trip:
	var trips = Trip.fetchTrips()
	var trip = trips[0]
	trip.intersectPlanet = true
	return trip


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
			var trips = Trip.fetchTrips()
			
			for trip in trips:
				module = trip.spaceship.getModulesByType(mod_type)
		
		if module:
			availableModules.append(module)

	var route = getRoute()

	if route and route.intersectPlanet:
		var modIdx = availableModules.find_custom(func(m): return m.type == SpaceshipModule.Type.Sheld)
		if modIdx != -1:
			selectModule(availableModules[modIdx])

	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayAvailableModules(availableModules)

func submitModules():
	var selected_modules = getSelectedModules()
	
	if _spaceship:
		var ok = _spaceship.assignModules(selected_modules)
		if not ok: pass
	
	var speedModule = selected_modules.find_custom(func(m): return m.type == SpaceshipModule.Type.Speed)
	if speedModule != -1:
		return "Reikia pergeneruoti maršrutą"
		
	return null

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
			simPlanet.x = (sin((sysTime + planet.phase) * planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitXOffset
			simPlanet.y = (cos((sysTime + planet.phase) * planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitYOffset
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
		simPlanet.x = sin((currentTime + planet.phase) * planet.orbitalPeriod) + planet.orbitXOffset
		simPlanet.y = cos((currentTime + planet.phase) * planet.orbitalPeriod) + planet.orbitYOffset

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
	var intersectPlanet = false
	
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
					if collisionResult > 0:
						intersectPlanet = true
					if collisionResult > maxTemperature:
						var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
						RouteViewRef.addWarning("Temperatūra viršyja erdvėlaivio leidžiamą ribą")
					if checkForAsteroidBelt(1000):
						var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
						RouteViewRef.addWarning("Erdvėlaivis kirs asteroidų žiedą")
					setFlag()
					pass
				if flag == 2:
					var _trip = Trip.new(currentTime, currentTime + 1, curDist, fuelUsage)
					_trip.intersectPlanet = intersectPlanet
					return
			else:
				calculateNewStep(curDistDiff, lastDistDiff)
				
		lastDistDiff = curDistDiff

var currentRoute: Trip

func saveCurrentRoute(route):
	currentRoute = route
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(storedPlanets)
	
func displayRouteCreationPage():
	var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
	RouteViewRef.openRouteView()

# Optimal cargo subsystem
func displayFlightOptimalCargoView():
	var optimalCargoView = get_tree().current_scene.find_child("FlightOptimalCargoView") as FlightOptimalCargoView
	optimalCargoView.displayFlightOptimalCargoView()


# ======================================================================================================
# eriko funkcija
# ======================================================================================================

func validateCostValues() -> bool: #3
	return true

func getDeparturePlanet() -> Planet: #4
	return _flightController.departPlanet

func getTripSpaceship() -> Spaceship: #5
	return _flightController._spaceship

func getNeededFuel() -> float: #6
	return _flightController._neededFuel

func calculateFuelCost(planet_fuel_cost: float, needed_fuel: float) -> float: #7
	return planet_fuel_cost * needed_fuel

func getTripPilot() -> Pilot: #8
	return _flightController._pilot

func getTripDuration() -> float: #9
	return _flightController._tripDurationHours

func calculatePilotCost(pilot_hourly_wage: float, duration: int) -> float: #10
	return pilot_hourly_wage * float(duration)

func calculateModuleRent(module_rent: float, duration: int) -> float: #13
	return module_rent * float(duration)

func calculateSpaceshipCargoBay(cargoLength: int, cargoWidth: int) -> int: #14
	return cargoLength * cargoWidth

func getTripOrders() -> Array[Order]: #15
	return _flightController._orders

func calculateCargoArea(cargo_items: Array[Cargo]) -> float: #18
	var total_area = 0.0
	for item in cargo_items:
		total_area += float(item.length * item.width)
	return total_area

func calculateCargoMass(cargo_items: Array[Cargo]) -> float: #19
	var total_mass = 0.0
	for item in cargo_items:
		total_mass += float(item.mass)
	return total_mass

func calculateOrderAreaPart(order_area: float, cargo_bay: float) -> float: #20
	if cargo_bay <= 0.0:
		return 0.0
	return order_area / cargo_bay

func calculateOrderMassCost(order_mass: float, total_mass: float, total_base_cost: float) -> float: #21
	if total_mass <= 0.0:
		return 0.0
	return (order_mass / total_mass) * (total_base_cost * 0.5)

func calculateOrderAreaCost(area_part: float, total_base_cost: float) -> float: #22
	return area_part * (total_base_cost * 0.5)

func calculateOrderTotalCost(mass_cost: float, area_cost: float, markup: float = 1.25) -> float: #23
	return (mass_cost + area_cost) * markup

#func updateOrder(order_id: int, calculated_price: float) -> void: #24
	#Order.updateOrderPrice(order_id, calculated_price)

func calculateProfit(total_revenue: float, total_base_cost: float) -> float: #26
	return total_revenue - total_base_cost

func calculateTotalCosts():
	if not validateCostValues():
		return

	var total = 0.0

	var planet: Planet = getDeparturePlanet()
	var spaceship: Spaceship = getTripSpaceship()
	var needed_fuel = getNeededFuel()

	total += calculateFuelCost(planet.fuelCost, needed_fuel)

	var pilot = getTripPilot()
	var duration = getTripDuration()

	total += calculatePilotCost(pilot.hourly_wage, duration)

	var modules = SpaceshipModule.fetchSpaceshipModules(spaceship.code)
	if modules and modules.size() > 0:
		for module in modules:
			total += calculateModuleRent(module.rent, duration)

	var cargo_bay = calculateSpaceshipCargoBay(spaceship.cargoLength, spaceship.cargoWidth)

	var orders = getTripOrders()

	var orders_cargo_map = {}
	var total_cargo_mass = 0.0

	for order in orders:
		var cargo_items = Cargo.fetchOrderCargo(order.id)
		orders_cargo_map[order.id] = cargo_items
		total_cargo_mass += calculateCargoMass(cargo_items)


	return total

# ======================================================================================================
# 
# ======================================================================================================
