--For Balyena SandSkiff VS+Kontraption MC 1.20.1 and 1.18.2
--Watch this tutorial video on how to use this class: https://youtu.be/t7hRWTVeBWA
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
        	pos=vector.new(26,26,12), 	-- +X, +Y, +Z	-- this is how many ion thrusters Balyena has
        	neg=vector.new(26,26,12)	-- -X, -Y, -Z
    	},
}

local drone = DroneBaseClassKontraption(instance_configs)

function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(0,0,1))*self.target_rotation
	--self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveY(),vector.new(0,-1,0))*self.target_rotation -- uncomment to flip ship upside down
	self.target_global_position = vector.new(X,Y,Z) --replace XYZ with world coordinates
end

drone:run()
