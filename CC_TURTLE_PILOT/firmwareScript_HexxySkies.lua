--For HexxySkies and HexTweaks 4.0.0+
local DroneBaseClassHexxySkies = require "lib.tilt_ships.DroneBaseClassHexxySkies"

local Path = require "lib.paths.Path"
local path_utilities = require "lib.path_utilities"
local quaternion = require "lib.quaternions"
local JSON = require "lib.JSON"

local instance_configs = {}

local drone = DroneBaseClassHexxySkies:subclass()
--[[
function drone:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveY(), 0)*default_ship_orientation
end
]]--
function drone:customFlightLoopBehavior(customFlightVariables)
	self.target_rotation = quaternion.fromToRotation(self.target_rotation:localPositiveY(),vector.new(0,1,0))*self.target_rotation
	self.target_global_position = vector.new(-5,10,-8)
end

local customDrone = drone(instance_configs)

customDrone:run()
