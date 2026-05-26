class_name Database

static var _db: SQLite
static var db: SQLite:
	get:
		if !_db:
			_db = SQLite.new()
			_db.path = "res://galactic-travels.sqlite"
			var hasDb = false
			if FileAccess.file_exists(_db.path):
				hasDb = true
			_db.open_db()
			print("Opening db")
			if !hasDb:
				_setup_database()
			else:
				_migrate_spacebody_orbits()
		return _db
#static func init():
	#db = SQLite.new()
	#db.path="res://data.db"
	#var hasDb = false
	#if ResourceLoader.exists(db.path):
		#hasDb = true
	#db.open_db()
	##if !hasDb:
	#_setup_database()
	#pass

static func _setup_database() -> void:
	print("Setting up database")
	
	db.create_table("user_roles", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("user_roles", {"id": 1, "value": "client"})
	db.insert_row("user_roles", {"id": 2, "value": "flight_coordinator"})
	db.insert_row("user_roles", {"id": 3, "value": "administrator"})

	db.create_table("spaceship_categories", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("spaceship_categories", {"id": 1, "value": "S"})
	db.insert_row("spaceship_categories", {"id": 2, "value": "A"})
	db.insert_row("spaceship_categories", {"id": 3, "value": "B"})
	db.insert_row("spaceship_categories", {"id": 4, "value": "C"})
	db.insert_row("spaceship_categories", {"id": 5, "value": "D"})
	
	db.create_table("order_status", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("order_status", {"id": 1, "value":"Užsakytas"})
	db.insert_row("order_status", {"id": 2, "value":"Patvirtintas"})
	db.insert_row("order_status", {"id": 3, "value":"Sumokėtas"})
	db.insert_row("order_status", {"id": 4, "value":"Užbaigtas"})
	db.insert_row("order_status", {"id": 5, "value":"Atšauktas"})
	
	db.create_table("users", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"username": {"data_type": "text", "not_null": true},
		"password": {"data_type": "text"},
		"email": {"data_type": "text"},
		"user_role_id": {"data_type": "int"}
	})
	
	db.insert_row("users", {
		"username": "admin",
		"password": "admin.pass",
		"email": "admin@example.com",
		"user_role_id": 3
	})
	
	db.insert_row("users", {
		"username": "coord",
		"password": "coord.passw",
		"email": "coordinator@example.com",
		"user_role_id": 2
	})
	
	db.insert_row("users", {
		"username": "client",
		"password": "client.passw",
		"email": "client@example.com",
		"user_role_id": 1
	})
	
	db.create_table("orders", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"price": {"data_type": "real"},
		"order_status": {"data_type": "int"},
		"user_id": {"data_type": "int"}
	})
	
	db.insert_row("orders", {
		"id": 1,
		"order_status": 1,
		"user_id": 3
	})

	db.insert_row("orders", {
		"id": 2,
		"order_status": 1,
		"user_id": 3
	})
	
	db.insert_row("orders", {
		"id": 3,
		"price": 20.5,
		"order_status": 2,
		"user_id": 3
	})
	
	db.insert_row("orders", {
		"id": 4,
		"price": 269,
		"order_status": 4,
		"user_id": 3
	})
	
	
	db.create_table("cargo", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"length": {"data_type": "real"},
		"width": {"data_type": "real"},
		"mass": {"data_type": "real"},
		
		"order_id": {"data_type": "int"},
	})
	
	db.insert_row("cargo", {
		"name": "Kava",
		"length": 2,
		"width": 2,
		"mass": 30,
		
		"order_id": 1,
	})
	
	db.insert_row("cargo", {
		"name": "Kakava",
		"length": 2,
		"width": 2,
		"mass": 15,
		
		"order_id": 1,
	})
	
	db.insert_row("cargo", {
		"name": "Arbata",
		"length": 2,
		"width": 2,
		"mass": 20,
		
		"order_id": 2,
	})

	db.insert_row("cargo", {
		"name": "Sumuštinis",
		"length": 1,
		"width": 2,
		"mass": 55,
		
		"order_id": 2,
	})

	db.insert_row("cargo", {
		"name": "Kupranugariai",
		"length": 2,
		"width": 2,
		"mass": 25,
		
		"order_id": 2,
	})

	db.insert_row("cargo", {
		"name": "Petražolės",
		"length": 1,
		"width": 3,
		"mass": 33,
		
		"order_id": 2,
	})

	db.insert_row("cargo", {
		"name": "Pingvinai",
		"length": 2,
		"width": 3,
		"mass": 14,
		
		"order_id": 1,
	})
	
	db.insert_row("cargo", {
		"name": "Tabakas",
		"length": 2,
		"width": 2,
		"mass": 30,
		
		"order_id": 3,
	})
	
	db.insert_row("cargo", {
		"name": "Agurkai",
		"length": 2,
		"width": 2,
		"mass": 30,
		
		"order_id": 4,
	})
	
	db.insert_row("cargo", {
		"name": "Vazelinas",
		"length": 2,
		"width": 2,
		"mass": 30,
		
		"order_id": 4,
	})

	db.create_table("spaceship", {
		"code": {"data_type": "text", "primary_key": true},
		"name": {"data_type": "text"},
		"speed": {"data_type": "real"},
		"maxTemp": {"data_type": "real"},
		"cargoLength": {"data_type": "real"},
		"cargoWidth": {"data_type": "real"},
		"category": {"data_type": "int"},
		"fuelCapacity": {"data_type": "real"},
		"fuelConsumption": {"data_type": "real"},
		"moduleCapacity": {"data_type": "int"},
		"hangar_id": {"data_type": "int"},
	})
	
	db.insert_row("spaceship", {
		"code": "SHP-" + str(randi_range(1, 1000)),
		"name": "spaceship 1",
		"speed": 200.3,
		"maxTemp": 2000.3,
		"cargoLength": 10,
		"cargoWidth": 10,
		"category": 5,
		"fuelCapacity": 500,
		"fuelConsumption": 1,
		"moduleCapacity": 1,
		"hangar_id": 0,
	})
	
	db.insert_row("spaceship", {
		"code": "SHP-" + str(randi_range(1, 1000)),
		"name": "spaceship 2",
		"speed": 200.3,
		"maxTemp": 2000.3,
		"cargoLength": 5,
		"cargoWidth": 5,
		"category": 4,
		"fuelCapacity": 300,
		"fuelConsumption": 0.5,
		"moduleCapacity": 1,
		"hangar_id": 0,
	})
	
	db.create_table("spaceship_modules", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"module_ability_id": {"data_type": "int"},
		
		"hangar_id": {"data_type": "int"},
		"spaceship_id": {"data_type": "int"},
	})
	
	db.create_table("journeys", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"departure_date": {"data_type": "text"},
		"arrival_date": {"data_type": "text"},
		"distance": {"data_type": "real"},
		"required_fuel_amount": {"data_type": "real"},
	
		"spaceship_id": {"data_type": "int"},
		"pilot_id": {"data_type": "int"},
		"flight_coordinator_id": {"data_type": "int"}
	})
	
	db.create_table("spacebodies", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "string"},
		"mass": {"data_type": "float"},
		"temp": {"data_type": "float"},
		"radius": {"data_type": "float"},
		"color": {"data_type": "string"},
		"orbitXOffset": {"data_type": "float"},
		"orbitYOffset": {"data_type": "float"},
		"orbitalPeriod": {"data_type": "float"},
		"orbitalRadius": {"data_type": "float"},
		"phase": {"data_type": "float"}
	})
	
	db.create_table("planets", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"spaceBody_id": {"data_type": "int", "not_null": true},
		"hangar_id": {"data_type": "int", "not_null": true},
		"atmHeight": {"data_type": "float"},
		"atmDensity": {"data_type": "float"},
		"fuelCost": {"data_type": "float"}
	})
	
	# Helper function that adds the Sun and all planets
	addPlanetsToDB();
	
	db.create_table("hangars", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"shipCapacity": {"data_type": "int" },
		"moduleCapacity": {"data_type": "int"},
	})

	db.insert_row("hangars", {
		"id": 0,
		"shipCapacity": 2,
		"moduleCapacity": 4
	})

	db.create_table("pilots", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"surname": {"data_type": "text"},
		"spaceship_category_id": {"data_type": "int"},
		"hourly_wage": {"data_type": "real"}
	})

	db.insert_row("pilots", {
		"name": "Jebediah",
		"surname": "Kerman",
		"spaceship_category_id": 1,
		"hourly_wage": 67.69
	})
	
	db.create_table("trip", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"departureTime": {"data_type": "datetime"},
		"arrivalTime": {"data_type": "datetime"},
		"distance": {"data_type": "float"},
		"requiredFuel": {"data_type": "float"},
	})
	
	db.insert_row("trip", {
		"departureTime": "2026-06-01",
		"arrivalTime": "2026-08-01",
		"distance": 55000,
		"requiredFuel": 489,
	})

static func _migrate_spacebody_orbits() -> void:
	var sun_rows = db.select_rows("spacebodies", "name = 'Sun'", ["id"])
	if sun_rows.is_empty():
		db.insert_row("spacebodies", {
			"id": 8,
			"name": "Sun",
			"mass": 1989000,
			"temp": 5778,
			"radius": 70,
			"color": "#FFD54A",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 0,
			"orbitalRadius": 0,
			"phase": 0
		})

	db.update_rows("spacebodies", "1", {
		"orbitXOffset": 0,
		"orbitYOffset": 0
	})
	
static func addPlanetsToDB():
	var planets = [
		{
			"id": 0,
			"name": "Merkurijus",
			"mass": 330,
			"temp": 440,
			"radius": 4,
			"color": "#8C7853",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 88,
			"orbitalRadius": 80,
			"phase": 0,
			"atmHeight": 1,
			"atmDensity": 0.01,
			"fuelCost": 1.0
		},
		{
			"id": 1,
			"name": "Venera",
			"mass": 4868,
			"temp": 737,
			"radius": 9,
			"color": "#E6C27A",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 225,
			"orbitalRadius": 120,
			"phase": 0,
			"atmHeight": 15,
			"atmDensity": 0.9,
			"fuelCost": 2.0
		},
		{
			"id": 2,
			"name": "Žemė",
			"mass": 5972,
			"temp": 288,
			"radius": 10,
			"color": "#4B7BEC",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 365,
			"orbitalRadius": 160,
			"phase": 0,
			"atmHeight": 10,
			"atmDensity": 0.5,
			"fuelCost": 1.5
		},
		{
			"id": 3,
			"name": "Marsas",
			"mass": 642,
			"temp": 210,
			"radius": 6,
			"color": "#C1440E",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 687,
			"orbitalRadius": 210,
			"phase": 0,
			"atmHeight": 5,
			"atmDensity": 0.1,
			"fuelCost": 1.2
		},
		{
			"id": 4,
			"name": "Jupiteris",
			"mass": 1898000,
			"temp": 165,
			"radius": 30,
			"color": "#D9A066",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 4333,
			"orbitalRadius": 320,
			"phase": 0,
			"atmHeight": 40,
			"atmDensity": 1.5,
			"fuelCost": 5.0
		},
		{
			"id": 5,
			"name": "Saturnas",
			"mass": 568000,
			"temp": 134,
			"radius": 26,
			"color": "#E3C565",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 10759,
			"orbitalRadius": 420,
			"phase": 0,
			"atmHeight": 35,
			"atmDensity": 1.2,
			"fuelCost": 4.5
		},
		{
			"id": 6,
			"name": "Uranas",
			"mass": 86800,
			"temp": 76,
			"radius": 18,
			"color": "#7FDBFF",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 30687,
			"orbitalRadius": 520,
			"phase": 0,
			"atmHeight": 25,
			"atmDensity": 0.8,
			"fuelCost": 4.0
		},
		{
			"id": 7,
			"name": "Neptūnas",
			"mass": 102000,
			"temp": 72,
			"radius": 18,
			"color": "#4169E1",
			"orbitXOffset": 0,
			"orbitYOffset": 0,
			"orbitalPeriod": 60190,
			"orbitalRadius": 620,
			"phase": 0,
			"atmHeight": 25,
			"atmDensity": 0.9,
			"fuelCost": 4.2
		}
	]

	db.insert_row("spacebodies", {
		"id": 8,
		"name": "Saulė",
		"mass": 1989000,
		"temp": 5778,
		"radius": 70,
		"color": "#FFD54A",
		"orbitXOffset": 0,
		"orbitYOffset": 0,
		"orbitalPeriod": 0,
		"orbitalRadius": 0,
		"phase": 0
	})

	for p in planets:
		db.insert_row("spacebodies", {
			"id": p.id,
			"name": p.name,
			"mass": p.mass,
			"temp": p.temp,
			"radius": p.radius,
			"color": p.color,
			"orbitXOffset": p.orbitXOffset,
			"orbitYOffset": p.orbitYOffset,
			"orbitalPeriod": p.orbitalPeriod,
			"orbitalRadius": p.orbitalRadius,
			"phase": p.phase
		})

		db.insert_row("planets", {
			"spaceBody_id": p.id,
			"hangar_id": 0,
			"atmHeight": p.atmHeight,
			"atmDensity": p.atmDensity,
			"fuelCost": p.fuelCost
		})
