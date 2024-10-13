--For Command Computer from Computercraft with CC:VS addon installed
local DroneBaseClassCommandComputer = require "lib.tilt_ships.DroneBaseClassCommandComputer"

local quaternion = require "lib.quaternions"

local instance_configs = {}

local drone = DroneBaseClassCommandComputer(instance_configs)

function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(0,0,1))*self.target_rotation
	--self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveX(),vector.new(1,0,0))*self.target_rotation
	self.target_global_position = vector.new(X,Y,Z)
end

drone:run()
