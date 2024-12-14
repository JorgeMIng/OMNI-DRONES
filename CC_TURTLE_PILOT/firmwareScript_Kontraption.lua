--For Balyena SandSkiff VS+Kontraption MC 1.20.1 and 1.18.2
--Watch this tutorial video on how to use this class: https://youtu.be/t7hRWTVeBWA
local DroneBaseClassKontraption = require "lib.tilt_ships.DroneBaseClassKontraption"

local Test = require "lib.test_3"
local utilities = require "lib.utilities"

print("fuck",Test)
local pp = Test()
local dd =pp:build()
print("results",dd.result)
print("default executed",dd.was_default)


--print("result_last",#pp:build())

local quaternion = require "lib.quaternions"

local instance_configs = {
	ship_constants_config = {
		PID_SETTINGS=
		{
			POS = {
				P=0.05,
				I=0.001,
				D=0.015,
			},
		},
		ION_THRUSTERS_COUNT = { --number of ion thrusters pointing in each cardinal direction
        	pos=vector.new(2,2,2), 	-- +X, +Y, +Z	-- this is how many ion thrusters Balyena has
        	neg=vector.new(2,2,2)	-- -X, -Y, -Z
    	},
},channels_config = {
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
}
}

local drone = DroneBaseClassKontraption(instance_configs)

-- Watch this tutorial video to learn how to use this function: https://youtu.be/07Czgxqp0dk?si=gltpueMIgFjHpqJZ&t=269 (skip to 4:29)
function drone:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveY(), -90)*default_ship_orientation -- Rotates the default orientation so that the nose of the ship is aligned with it's local +X axis
end

-- Watch this tutorial video to learn how to use this function: https://youtu.be/07Czgxqp0dk?si=gltpueMIgFjHpqJZ&t=269 (5:25 to 10:30)



function drone:customFlightLoopBehavior(customFlightVariables)
	
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(0,0,1))*self.target_rotation
	--self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveY(),vector.new(0,-1,0))*self.target_rotation -- uncomment to flip ship upside down
	local target_pos =vector.new(6,13,12)
	if (self:getTargetMode()=="PLAYER")then
		local player_info=self.sensors.radars:getRadarTarget("PLAYER",false) or false
	--print(self.get)
		if player_info  then
			target_pos=player_info.position
		end
	 --end
	end
	
	self.target_global_position = target_pos --replace XYZ with world coordinates
end

drone:run()
