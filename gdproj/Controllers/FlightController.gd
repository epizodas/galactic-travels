extends Node
class_name FlightController

var _spaceship: Spaceship = null
var _orders: Array[Order] = []

var _selectedModules: Array[SpaceshipModule] = []

func openFlightView():
	var planets: Array[Planet] = Planet.fetchAllPlanets()
	if planets.is_empty():
		printerr("Error: fetchAllPlanets() returned an empty array.")
		return

	var MainViewRef = get_tree().current_scene.find_child("MainView") as MainView
	MainViewRef.visible = false

	var FlightViewRef = get_tree().current_scene.find_child("FlightView") as FlightView
	FlightViewRef.displayFlightView(planets)

	storedPlanets = planets.duplicate(true)
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

func rememberSpaceship(spaceship: Spaceship) -> void:
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
		var modIdx = availableModules.find_custom(func(m): return m.type == SpaceshipModule.Type.Shield)
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
	simulationPlanets.clear()
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
			simulationPlanets.append(simPlanet)
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
		step = max(step, 3600.0)
	elif curDistDiff > 0 and lastDistDiff > 0:
		step *= 1.1
		step = min(step, 86400.0)

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
	var lastDistDiff = 0.0
	var lastDist = -1
	var intersectPlanet = false
	step = 86400
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
			if lastDistDiff < 0:
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
					var travel_seconds = (curDist / _spaceship.speed) * 86400.0
					var _trip = Trip.new(Time.get_date_dict_from_unix_time(currentTime), Time.get_date_dict_from_unix_time(currentTime + int(travel_seconds)), curDist, fuelUsage)
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
func _get_debug_vis() -> Control:
	return Engine.get_main_loop().current_scene.get_node_or_null(
        "MarginContainer/MainLayout/FlightOptimalCargoView/VBoxContainer/VBoxContainer/Panel"
	)

func displayFlightOptimalCargoView():
	var optimalCargoView = get_tree().current_scene.find_child("FlightOptimalCargoView") as FlightOptimalCargoView
	optimalCargoView.displayFlightOptimalCargoView()

func calculateOptimalCargo():
	var free_space = calculateSpaceshipSize();
	
	var order_arr: Array[Order] = Order.fetchAllOrderedOrders();
	var cargo_arr: Array[Cargo] = [];
	for order in order_arr:
		var cargo = Cargo.fetchOrderCargo(order.id)
		cargo_arr.append_array(cargo)
	
	var foundOrders: Array[Order] = await findOrdersForSpaceship(free_space, order_arr, cargo_arr)
	
	var num = checkFoundOrderCount(foundOrders)
	if num <= 0:
		return "Nerasta užsakymų";
	
	var foundCargo: Array[Cargo] = []
	for order in foundOrders:
		for cargo in cargo_arr:
			if order.id == cargo.order_id:
				foundCargo.append(cargo)
	
	var takenCapacity: float = checkSpaceshipCapacity(foundCargo);
	if takenCapacity <= 30:
		return "Rasti užsakymai užema mažiau nei 30% erdvėlaivio vietos";
	
	rememberOrders(foundOrders)
	return foundCargo

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

func findOrdersForSpaceship(freeSpace: Array, orders: Array[Order], cargo: Array[Cargo]) -> Array[Order]:
	var grid_h: int = freeSpace.size()
	var grid_w: int = freeSpace[0].size() if grid_h > 0 else 0
	var free_rects: Array = [{"x": 0, "y": 0, "w": grid_w, "h": grid_h}]
	var placed_items: Array = []
	var cargo_by_order: Dictionary = {}
	for c in cargo:
		var key: int = int(c.order_id)
		if not cargo_by_order.has(key):
			cargo_by_order[key] = []
		cargo_by_order[key].append(c)

	var accepted_orders: Array[Order] = []

	for order in orders:
		if not cargo_by_order.has(int(order.id)):
			continue

		var order_cargo: Array = cargo_by_order[int(order.id)]

		var temp_free_rects: Array = []
		for rect in free_rects:
			temp_free_rects.append(rect.duplicate())
		var temp_placed: Array = []
		var order_fits: bool = true

		for item in order_cargo:
			var best_rect_idx: int = -1
			var best_area: int = 999999999

			for i in range(temp_free_rects.size()):
				var rect = temp_free_rects[i]
				if rect["w"] >= item.width and rect["h"] >= item.length:
					var area = rect["w"] * rect["h"]
					if area < best_area:
						best_area = area
						best_rect_idx = i

			if best_rect_idx == -1:
				print("  FAIL: item doesnt fit anywhere")
				order_fits = false
				break

			var chosen = temp_free_rects[best_rect_idx].duplicate()
			temp_free_rects.remove_at(best_rect_idx)
			
			temp_placed.append({
				"x": chosen["x"],
				"y": chosen["y"],
				"w": item.width,
				"h": item.length,
				"label": str(order.id)
			})
			
			if chosen["w"] - item.width > 0:
				temp_free_rects.append({
					"x": chosen["x"] + item.width,
					"y": chosen["y"],
					"w": chosen["w"] - item.width,
					"h": item.length
				})
			if chosen["h"] - item.length > 0:
				temp_free_rects.append({
					"x": chosen["x"],
					"y": chosen["y"] + item.length,
					"w": chosen["w"],
					"h": chosen["h"] - item.length
				})

		if order_fits:
			accepted_orders.append(order)
			free_rects = temp_free_rects
			placed_items.append_array(temp_placed)

	var _debug_vis := _get_debug_vis()
	if _debug_vis:
		_debug_vis.update_state(grid_w, grid_h, free_rects, placed_items)

	return accepted_orders

func checkFoundOrderCount(foundOrders: Array[Order]) -> int:
	return foundOrders.size();
	
func checkSpaceshipCapacity(cargo: Array[Cargo]) -> float:
	var total_area := 0

	for c in cargo:
		total_area += c.width * c.length
	print(total_area)
	var spaceship_area = _spaceship.cargoWidth * _spaceship.cargoLength

	if spaceship_area <= 0:
		return 0

	return (float(total_area) / float(spaceship_area)) * 100.0
	
func rememberOrders(foundOrders: Array[Order]) -> void:
	_orders = foundOrders;


# ======================================================================================================
# eriko funkcija

func validateCostValues(price_per_kg: float, price_per_sqm: float, markup_percent: float) -> bool: #6
	if price_per_kg < 0.0 or price_per_sqm < 0.0 or markup_percent < 0.0:
		return false
	return true

func getDeparturePlanet() -> Planet: #7
	return departPlanet

func getTripSpaceship() -> Spaceship: #8
	return _spaceship

func getNeededFuel() -> float: #9
	return currentRoute.requiredFuel

func calculateFuelCost(planet_fuel_cost: float, needed_fuel: float) -> float: #10
	return planet_fuel_cost * needed_fuel

func getTripPilot() -> Pilot: #11
	return Pilot.fetchPilot(1)

func getTripDuration() -> float: #12
	return currentRoute.distance / _spaceship.speed

func calculatePilotCost(pilot_hourly_wage: float, duration: float) -> float: #13
	return pilot_hourly_wage * duration

func calculateModuleRent(module_rent: float, duration: int) -> float: #16
	return module_rent * float(duration)

func calculateSpaceshipCargoBay(cargoLength: int, cargoWidth: int) -> int: #17
	return cargoLength * cargoWidth

func getTripOrders() -> Array[Order]: #18
	return Order.fetchAllOrderedOrders()
	#return _orders

func calculateCargoArea(cargo_items: Array[Cargo]) -> float: #21
	var total_area = 0.0
	for item in cargo_items:
		total_area += float(item.length * item.width)
	return total_area

func calculateOrderAreaPart(order_area: float, cargo_bay: float) -> float: #22
	if cargo_bay <= 0.0 or order_area <= 0.0:
		return 1.0
	return order_area / cargo_bay

func calculateCargoMass(cargo_items: Array[Cargo]) -> float: #23
	var total_mass = 0.0
	for item in cargo_items:
		total_mass += float(item.mass)
	return total_mass

func calculateOrderMassCost(order_mass: float, price_per_kg: float) -> float: #24
	if order_mass <= 0.0:
		return 0.0
	return order_mass * price_per_kg

func calculateOrderAreaCost(area_part: float, cargo_bay: float, price_per_sqm: float) -> float: #25
	return area_part * cargo_bay * price_per_sqm

func calculateOrderTotalCost(mass_cost: float, area_cost: float, markup_percent: float) -> float: #26
	var markup_factor = 1.0
	if markup_percent > 0.0:
		markup_factor += (markup_percent / 100.0)
	return (mass_cost + area_cost) * markup_factor

func calculateProfit(total_revenue: float, total_base_cost: float) -> float: #29
	return total_revenue - total_base_cost

func submitCostInfo(price_per_kg: float, price_per_sqm: float, markup_percent: float):
	if not validateCostValues(price_per_kg, price_per_sqm, markup_percent):
		return null

	var base_cost = 0.0

	var planet: Planet = getDeparturePlanet() #7
	var spaceship: Spaceship = getTripSpaceship() #8
	var needed_fuel = getNeededFuel() #9

	base_cost += calculateFuelCost(planet.fuelCost, needed_fuel) #10 

	var pilot = getTripPilot() #11
	var duration = getTripDuration() #12 

	base_cost += calculatePilotCost(pilot.hourly_wage, duration) #13

	var modules = SpaceshipModule.fetchSpaceshipModules(spaceship.code) #14
	if modules and modules.size() > 0:
		for module in modules:
			base_cost += calculateModuleRent(module.rent, duration) #16

	var cargo_bay = calculateSpaceshipCargoBay(spaceship.cargoLength, spaceship.cargoWidth) #17

	var orders = getTripOrders() #18

	var total_revenue = 0.0

	for order in orders:
		var cargo_items =  Cargo.fetchOrderCargo(order.id) #19

		var order_area = calculateCargoArea(cargo_items) #21
		var area_part = calculateOrderAreaPart(order_area, cargo_bay) #22
		
		var order_mass = calculateCargoMass(cargo_items) #23

		var mass_cost = calculateOrderMassCost(order_mass, price_per_kg) #24
		var area_cost = calculateOrderAreaCost(area_part, cargo_bay, price_per_sqm) #25

		var calculated_order_cost = calculateOrderTotalCost(mass_cost, area_cost, markup_percent) #26

		order.price = calculated_order_cost
		Order.updateOrder( Order.new(order.id, calculated_order_cost, 2)) #27
		total_revenue += calculated_order_cost

	print("=== Cost Breakdown ===")
	print("Fuel cost:    ", calculateFuelCost(planet.fuelCost, needed_fuel))
	print("Pilot cost:   ", calculatePilotCost(pilot.hourly_wage, duration))
	print("Duration:     ", duration)
	print("Total base_cost: ", base_cost)
	print("Total revenue:   ", total_revenue)
	print("Profit:          ", total_revenue - base_cost)
	
	return calculateProfit(total_revenue, base_cost) #28

func openFlightCostView():
	if _spaceship == null or _orders.size() == 0 or _selectedModules.size() == 0 or currentRoute == null:
		return
	var flightCostView = get_tree().current_scene.find_child("FlightView") as FlightView
	if flightCostView:
		flightCostView.displayFlightCostView()
