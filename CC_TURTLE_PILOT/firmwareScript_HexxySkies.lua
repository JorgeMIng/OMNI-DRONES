--For HexxySkies and HexTweaks 4.0.0+
local DroneBaseClassHexxySkies = require "lib.tilt_ships.DroneBaseClassHexxySkies"

local quaternion = require "lib.quaternions"

local instance_configs = {}

local drone = DroneBaseClassHexxySkies(instance_configs)

function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(0,0,1))*self.target_rotation
	--self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(1,0,0))*self.target_rotation
	self.target_global_position = vector.new(X,Y,Z)
end

drone:run()
