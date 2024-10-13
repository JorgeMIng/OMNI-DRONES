local DroneBaseClassKontraption = require "lib.tilt_ships.DroneBaseClassKontraption"

local quaternion = require "lib.quaternions"

local instance_configs = {
	ship_constants_config = {
		PID_SETTINGS=
		{
			POS = { --Kontraption based omni-drones don't need a PID controller for rotation. Gyro Blocks control the rotation instead
				P=0.05,
				I=0.001,
				D=0.015,
			},
		},
		ION_THRUSTERS_COUNT = { --number of ion thrusters pointing in each cardinal direction
        	pos=vector.new(26,26,12), 	-- +X, +Y, +Z
        	neg=vector.new(26,26,12)	-- -X, -Y, -Z
    	},
}

local drone = DroneBaseClassKontraption:subclass()

--[[
function drone:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveY(), -90)*default_ship_orientation
end
]]--
	
function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(0,0,1))*self.target_rotation
	--self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(1,0,0))*self.target_rotation
	self.target_global_position = vector.new(X,Y,Z)
end

local customDrone = drone(instance_configs)

customDrone:run()
