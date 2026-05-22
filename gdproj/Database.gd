class_name Database

static var _db : SQLite
static var db : SQLite:
	get:
		if !_db:
			_db = SQLite.new()
			_db.path="res://galactic-travels.sqlite"
			var hasDb = false
			if FileAccess.file_exists(_db.path):
				hasDb = true
			_db.open_db()
			if !hasDb:
				_setup_database()
		return _db
# good intro to the plugin
# https://www.youtube.com/watch?v=j-BRiTrw_F0
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
	
	db.insert_row("user_roles", {"id": 1, "value":"client"})
	db.insert_row("user_roles", {"id": 2, "value":"flight_coordinator"})
	db.insert_row("user_roles", {"id": 3, "value":"administrator"})

	db.create_table("spaceship_categories", {
		"id": {"data_type": "int", "primary_key": true},
		"value": {"data_type": "text", "not_null": true, "unique": true}
	})
	
	db.insert_row("spaceship_categories", {"id": 1, "value":"S"})
	db.insert_row("spaceship_categories", {"id": 2, "value":"A"})
	db.insert_row("spaceship_categories", {"id": 3, "value":"B"})
	db.insert_row("spaceship_categories", {"id": 4, "value":"C"})
	db.insert_row("spaceship_categories", {"id": 5, "value":"D"})

	db.create_table("pilots", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text", "not_null": true},
		"surname": {"data_type": "text", "not_null": true},
		"license_category_id": {"data_type": "int"},
		"hourly_wage": {"data_type": "real"}
	})
	
	db.create_table("users", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"username": {"data_type": "text", "not_null": true},
		"password": {"data_type": "text"},
		"email": {"data_type": "text"},
		"user_role_id": {"data_type": "int"}
	})
	
	db.insert_row("users", {
		"username":"admin", 
		"password": "admin.pass", 
		"email": "admin@example.com",
		"user_role_id": 3
	})
	
	db.insert_row("users", {
		"username":"coord", 
		"password": "coord.passw", 
		"email": "coordinator@example.com",
		"user_role_id": 2
	})
	
	db.insert_row("users", {
		"username":"client", 
		"password": "client.passw", 
		"email": "client@example.com",
		"user_role_id": 1
	})
	
	db.create_table("orders", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"price": {"data_type": "real"},
		"order_status": {"data_type": "text"},
		"user_id": {"data_type": "int"}
	
		#departure planet id
		#arrival planet id
	})
	
	db.insert_row("orders", {
		"order_status": "Placed",
		"user_id": 3
	})
	
	db.create_table("cargo", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"length": {"data_type": "real"},
		"width": {"data_type": "real"},
		"mass": {"data_type": "real"},
		
		"order_id":{"data_type": "int"},
	})
	
	db.insert_row("cargo", {
		"name": "Cargo1",
		"length": 10,
		"width": 20,
		"mass": 30,
		
		"order_id": 1,
	})
	
	db.insert_row("cargo", {
		"name": "Cargo2",
		"length": 20,
		"width": 5,
		"mass": 15,
		
		"order_id": 1,
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
		"cargoLength": 5,
		"cargoWidth": 5,
		"category": 5,
		"fuelCapacity": 500,
		"fuelConsumption": 1,
		"moduleCapacity": 1,
		"hangar_id": 1,
	})
	print("Inserted spaceship row")
	
	
	db.create_table("spaceship_modules", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"module_ability_id": {"data_type": "int"},
		
		"hangar_id":{"data_type": "int"},
		"spaceship_id":{"data_type": "int"},
	})
	
	db.create_table("journeys", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"departure_date": {"data_type": "text"},
		"arrival_date": {"data_type": "text"},
		"distance": {"data_type": "real"},
		"required_fuel_amount": {"data_type": "real"},
	
		"spaceship_id":{"data_type": "int"},
		"pilot_id":{"data_type": "int"},
		"flight_coordinator_id":{"data_type": "int"}
	})
	
	db.create_table("hangars", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"spaceship_capacity": {"data_type": "int"},
		"module_capacity": {"data_type": "int"}
	
		#planet id turi ig
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
		"phase": {"data_type": "float"},
	})
	
	db.create_table("planets", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"spaceBody_id": {"data_type": "int", "not_null": true},
		"hangar_id": {"data_type": "int", "not_null": true},
		"atmHeight": {"data_type": "float"},
		"atmDensity": {"data_type": "float"},
	})
	
	db.insert_row("spacebodies", {
		"id": 0,
		"name": "Žemė",
		"mass": 1500,
		"temp": 273,
		"radius": 10,
		"color": "#FFF",
		"orbitXOffset": 0,
		"orbitYOffset": 0,
		"orbitalPeriod": 10,
		"orbitalRadius": 10,
		"phase": 0
	})
	
	db.insert_row("planets", {
		"spaceBody_id": 0,
		"hangar_id": 0,
		"atmHeight": 10,
		"atmDensity": 0.5
	})
	
	db.create_table("hangars", {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"shipCapacity": {"data_type": "int", "not_null": true},
		"moduleCapacity": {"data_type": "int", "not_null": true},
	})

	db.insert_row("hangars", {
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
		"distance": 10000,
		"requiredFuel": 22222,
	})
