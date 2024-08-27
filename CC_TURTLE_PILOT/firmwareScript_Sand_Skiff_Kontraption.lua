--For Sand Skiff using VS+Kontraption
local DroneBaseClassKontraption = require "lib.tilt_ships.DroneBaseClassKontraption"

local Path = require "lib.paths.Path"
local path_utilities = require "lib.path_utilities"
local quaternion = require "lib.quaternions"
local JSON = require "lib.JSON"

local instance_configs = {
	radar_config = {
		designated_ship_id = "3",
		designated_player_name="PHO",
		ship_id_whitelist={},
		player_name_whitelist={},
	},
	ship_constants_config = {
		DRONE_ID = ship.getId(),
		PID_SETTINGS=
		{
			POS = {
				P=0.05,
				I=0.001,
				D=0.015,
			},
		},
		ION_THRUSTERS_COUNT = { --number of thrusters pointing in each cardinal direction
        	pos=vector.new(26,26,12), 	-- +X, +Y, +Z
        	neg=vector.new(26,26,12)	-- -X, -Y, -Z
    	}
	},
	channels_config = {
		DEBUG_TO_DRONE_CHANNEL = 9,
		DRONE_TO_DEBUG_CHANNEL = 10,
		
		REMOTE_TO_DRONE_CHANNEL = 7,
		DRONE_TO_REMOTE_CHANNEL = 8,
		
		DRONE_TO_COMPONENT_BROADCAST_CHANNEL = 800,
		COMPONENT_TO_DRONE_CHANNEL = 801,
		
		EXTERNAL_AIM_TARGETING_CHANNEL = 1009,
		EXTERNAL_ORBIT_TARGETING_CHANNEL = 1010,
		EXTERNAL_GOGGLE_PORT_CHANNEL = 1011,
		REPLY_DUMP_CHANNEL = 10000,
	},
	rc_variables = {
		
	},
}

local drone = DroneBaseClassKontraption:subclass()

function drone:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveY(), -90)*default_ship_orientation
end

function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveY(),vector.new(0,1,0))*self.target_rotation
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(1,0,0))*self.target_rotation
	self.target_global_position = vector.new(-50,30,7)
end

local customDrone = drone(instance_configs)

customDrone:run()