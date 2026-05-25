extends Node
class_name FlightController

var _departPlanet: Planet = null
var _destPlanet: Planet = null
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
	if planets.is_empty():
		printerr("Error: fetchAllPlanets() returned an empty array.")
		return

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
	_departPlanet = depart
	_destPlanet = dest
	pass

func checkSpaceshipAmount(spaceships: Array[Spaceship]):
	return len(spaceships) > 0

func submitPlanets(id1, id2) -> Array[Spaceship]:
	if id1 < 0 or id1 >= storedPlanets.size() or id2 < 0 or id2 >= storedPlanets.size():
		printerr("Error: Planet selection index out of bounds.")
		return []

	rememberPlanets(storedPlanets[id1], storedPlanets[id2])
	
	var hangar = storedPlanets[id1].getPlanetHangar()
	var spaceships = hangar.getHangarSpaceships()
	if checkSpaceshipAmount(spaceships):
		_spaceship = spaceships[0]
		return spaceships
	return []

func rememberSpaceship(spaceship: Spaceship) -> void
	_spaceship = spaceship
	
func submitSpaceship(spaceship: Spaceship) -> bool:
	rememberSpaceship(spaceship)
	return true

func getRoute() -> Trip:
	var trips = Trip.fetchTrips()
	if trips.is_empty():
		printerr("Error: fetchTrips() returned an empty array.")
		return null

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
var step = 1
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
			simPlanet.x = (sin((sysTime + planet.phase) * 2 * 3.14159265358979 / planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitXOffset
			simPlanet.y = (cos((sysTime + planet.phase) * 2 * 3.14159265358979 / planet.orbitalPeriod) * planet.orbitalRadius) + planet.orbitYOffset
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
		simPlanet.x = sin((currentTime + planet.phase) * 2 * 3.14159265358979 / planet.orbitalPeriod) * planet.orbitalRadius + planet.orbitXOffset
		simPlanet.y = cos((currentTime + planet.phase) * 2 * 3.14159265358979 / planet.orbitalPeriod) * planet.orbitalRadius + planet.orbitYOffset

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
		step = max(step, 0.1)
	elif curDistDiff > 0 and lastDistDiff > 0:
		step *= 1.1
		step = min(step, 1.0)

var flag = 0

func setFlag():
	flag += 1

func calculateFuelUsage(distance):
	return _spaceship.fuelConsumption * distance

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
	step = 2
	print(currentTime)
	print(endTime)
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
		lastDist = curDist
	
		if curDistDiff < 0:
			calculateNewStep(curDistDiff, lastDistDiff)
		elif curDistDiff > 0:
			if lastDistDiff <= 0:
				setFlag()
				var fuelUsage = calculateFuelUsage(curDist)
				var fuelCapacity = _spaceship.fuelCapacity
				if fuelUsage < fuelCapacity:
					var departSim: SimulatedPlanet
					var destSim: SimulatedPlanet
					for s in simulationPlanets:
						if s.planet == departPlanet:
							departSim = s
						elif s.planet == destPlanet:
							destSim = s
					var collisionResult = checkForCollisions(departSim, destSim, simulationPlanets)
					var maxTemperature = _spaceship.maxTemp
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
					var _trip = Trip.new(Time.get_date_dict_from_unix_time(currentTime), Time.get_date_dict_from_unix_time(currentTime + 1), curDist, fuelUsage)
					_trip.intersectPlanet = intersectPlanet
					print("Found trip")
					print(_trip.departureTime)
					return _trip
			else:
				calculateNewStep(curDistDiff, lastDistDiff)
				
		lastDistDiff = curDistDiff

var currentRoute: Trip

func saveCurrentRoute(route):
	currentRoute = route
	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(storedPlanets)
	var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
	RouteViewRef.visible = false
	
func displayRouteCreationPage():
	var RouteViewRef = get_tree().current_scene.find_child("RouteView") as RouteView
	RouteViewRef.openRouteView()

# ======================================================================================================
# domanto funkcija
# ======================================================================================================
func displayFlightOptimalCargoView():
	var optimalCargoView = get_tree().current_scene.find_child("FlightOptimalCargoView") as FlightOptimalCargoView
	optimalCargoView.displayFlightOptimalCargoView()

func calculateOptimalCargo():
	
	var free_space = calculateSpaceshipSize();
	
	var order_arr: Array[Order] = Order.fetchAllOrderedOrders();
	var cargo_arr: Array[Cargo];
	
	for order in order_arr:
		var cargo = Cargo.fetchOrderCargo(order.id)
		cargo_arr.append(cargo)
	
	findOrdersForSpaceship(free_space, order_arr, cargo_arr);
	
	#var num = checkFoundOrderCount(order_arr)
	#if num > 0:
	#	return;
	
	#var takenCapacity: int = checkSpaceshipCapacity();
	#if takenCapacity > 30:
	#	return
	
	#rememberOrders()
	pass

func calculateSpaceshipSize() -> Array:
	var cargoLength = _spaceship.cargoLength
	var cargoWidth = _spaceship.cargoWidth

	var space_grid: Array = []
	space_grid.clear()

	for y in range(cargoLength):
		var row: Array = []
		for x in range(cargoWidth):
			row.append(false)
		space_grid.append(row)
	return space_grid

#--
func groupCargoByOrder(cargo: Array[Cargo]) -> Dictionary:
	var map = {}

	for c in cargo:
		if not map.has(c.order_id):
			map[c.order_id] = []
		map[c.order_id].append(c)

	return map
#--

func findOrdersForSpaceship(free_space: Array, orders: Array[Order], cargo: Array[Cargo]) -> Array[Order]:
	var accepted_orders: Array[Order] = []
	var working_space = free_space.duplicate(true)

	var cargo_by_order = {}

	for c in cargo:
		if not cargo_by_order.has(c.order_id):
			cargo_by_order[c.order_id] = []
		cargo_by_order[c.order_id].append(c)
	
	for order in orders:
		if not cargo_by_order.has(order.id):
			continue

		var order_cargo = cargo_by_order[order.id]

		var test_space = working_space.duplicate(true)

		if tryPackOrderIntoSpace(test_space, order_cargo):
			working_space = test_space
			accepted_orders.append(order)

	return accepted_orders
	
func tryPackOrderIntoSpace(free_space: Array, cargo_list: Array[Cargo]) -> bool:
	cargo_list.sort_custom(func(a, b):
		return a.width * a.height > b.width * b.height
	)

	for cargo in cargo_list:
		var placed = false

		for i in range(free_space.size()):
			var rect = free_space[i]

			if cargo.width <= rect.width and cargo.height <= rect.height:
				split_free_rect(free_space, i, cargo)
				placed = true
				break

		if not placed:
			return false

	return true
	
func split_free_rect(free_space: Array, index: int, cargo: Cargo) -> void:
	var rect = free_space[index]
	free_space.remove_at(index)

	# right rectangle
	if rect.width > cargo.width:
		free_space.append({
			"x": rect.x + cargo.width,
			"y": rect.y,
			"width": rect.width - cargo.width,
			"height": cargo.height
		})

	# bottom rectangle
	if rect.height > cargo.height:
		free_space.append({
			"x": rect.x,
			"y": rect.y + cargo.height,
			"width": rect.width,
			"height": rect.height - cargo.height
		})

func checkFoundOrderCount(foundOrders: Array[Order]) -> int:
	return 0
	
func checkSpaceshipCapacity():
	pass
	
func rememberOrders():
	pass


# ======================================================================================================
# eriko funkcija

func validateCostValues(price_per_kg: float, price_per_sqm: float, markup_percent: float) -> bool: #3
	# Use self references instead of _flightController
	if not _departPlanet or not _spaceship or not _pilot:
		return false
	if price_per_kg < 0.0 or price_per_sqm < 0.0 or markup_percent < 0.0:
		return false
	return true

func getDeparturePlanet() -> Planet: #4
	return _departPlanet

func getTripSpaceship() -> Spaceship: #5
	return _spaceship

func getNeededFuel() -> float: #6
	return _neededFuel

func calculateFuelCost(planet_fuel_cost: float, needed_fuel: float) -> float: #7
	return planet_fuel_cost * needed_fuel

func getTripPilot() -> Pilot: #8
	return _pilot

func getTripDuration() -> int: #9
	return _tripDurationHours

func calculatePilotCost(pilot_hourly_wage: float, duration: int) -> float: #10
	return pilot_hourly_wage * float(duration)

func calculateModuleRent(module_rent: float, duration: int) -> float: #13
	return module_rent * float(duration)

func calculateSpaceshipCargoBay(cargoLength: int, cargoWidth: int) -> int: #14
	return cargoLength * cargoWidth

func getTripOrders() -> Array[Order]: #15
	return _orders

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

func calculateOrderMassCost(order_mass: float, price_per_kg: float) -> float: #21
	if order_mass <= 0.0:
		return 0.0
	return order_mass * price_per_kg

func calculateOrderAreaCost(area_part: float, cargo_bay: float, price_per_sqm: float) -> float: #22
	return area_part * cargo_bay * price_per_sqm

func calculateOrderTotalCost(mass_cost: float, area_cost: float, markup_percent: float) -> float: #23
	var markup_factor = 1.0 + (markup_percent / 100.0)
	return (mass_cost + area_cost) * markup_factor

func calculateProfit(total_revenue: float, total_base_cost: float) -> float: #26
	return total_revenue - total_base_cost

func calculateTotalCosts(price_per_kg: float, price_per_sqm: float, markup_percent: float):
	if not validateCostValues(price_per_kg, price_per_sqm, markup_percent):
		return null

	var base_cost = 0.0

	var planet: Planet = getDeparturePlanet() #4
	var spaceship: Spaceship = getTripSpaceship() #5
	var needed_fuel = getNeededFuel() #6 

	base_cost += calculateFuelCost(planet.fuelCost, needed_fuel) #7

	var pilot = getTripPilot() #8
	var duration = getTripDuration() #9

	base_cost += calculatePilotCost(pilot.hourly_wage, duration) #10

	var modules = SpaceshipModule.fetchSpaceshipModules(spaceship.code) #11
	if modules and modules.size() > 0:
		for module in modules:
			base_cost += calculateModuleRent(module.rent, duration) #13

	var cargo_bay = calculateSpaceshipCargoBay(spaceship.cargoLength, spaceship.cargoWidth) #14

	var orders = getTripOrders() #15

	var orders_cargo_map = {}
	var total_cargo_mass = 0.0

	for order in orders:
		var cargo_items = Cargo.fetchOrderCargo(order.id) #16
		orders_cargo_map[order.id] = cargo_items 
		total_cargo_mass += calculateCargoMass(cargo_items) #18

	var total_revenue = 0.0

	for order in orders:
		var cargo_items = orders_cargo_map[order.id]

		var order_area = calculateCargoArea(cargo_items) #19
		var area_part = calculateOrderAreaPart(order_area, cargo_bay) #20
		
		var order_mass = calculateCargoMass(cargo_items) #kadangi nesaugom tai tenka persiskaiciuot :)

		var mass_cost = calculateOrderMassCost(order_mass, price_per_kg) #21
		var area_cost = calculateOrderAreaCost(area_part, cargo_bay, price_per_sqm) #22

		var calculated_order_cost = calculateOrderTotalCost(mass_cost, area_cost, markup_percent) #23

		Order.updateOrderPrice(order.id, calculated_order_cost) #24
		order.price = calculated_order_cost
		total_revenue += calculated_order_cost

	return calculateProfit(total_revenue, base_cost) #26
