local TenThrusterTemplateVerticalCompactSP = require "lib.tilt_ships.TenThrusterTemplateVerticalCompactSP"

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
				P = 0.7,
				I = 0.024,
				D = 2.07
			},
			ROT = {
				X = {
					P = 0.04,
					I = 0.004,
					D = 0.05
				},
				Y = {
					P = 0.04,
					I = 0.004,
					D = 0.05
				},
				Z = {
					P = 0.04,
					I = 0.004,
					D = 0.05
				}
			}
		},
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

local drone = TenThrusterTemplateVerticalCompactSP:subclass()

function drone:organizeThrusterTable(thruster_table)
	local new_thruster_table = {}

	for i=1,10,1 do
		new_thruster_table[i] = {}
	end
	
	local equivalent_thrusters={
		left_face = {
			x_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			x_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			y_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			y_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			z_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			--z_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)}, --not present in left face 
		},
		right_face={
			x_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			x_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			y_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			y_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
			--z_pos_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)}, --not present in right face 
			z_neg_dir={thruster_count=0,total_thrust=0,equivalent_position=vector.new(0,0,0)},
		}
	}

	for i,thruster in pairs(thruster_table) do
		local dir = thruster.direction
		local rad = thruster.radius -- measured from the center of mass
		local frc = thruster.base_force
		local equivalent_thruster = {}
		if(rad.z > 0) then --thruster is on left side
			if(dir.z > 0) then
				equivalent_thruster = equivalent_thrusters.left_face.z_pos_dir
			elseif(dir.y > 0) then
				equivalent_thruster = equivalent_thrusters.left_face.y_pos_dir
			elseif(dir.y < 0) then
				equivalent_thruster = equivalent_thrusters.left_face.y_neg_dir
			elseif(dir.x > 0) then
				equivalent_thruster = equivalent_thrusters.left_face.x_pos_dir
			elseif(dir.x < 0) then
				equivalent_thruster = equivalent_thrusters.left_face.x_neg_dir
			end
		else --thruster is on right side
			if(dir.z < 0) then
				equivalent_thruster = equivalent_thrusters.right_face.z_neg_dir
			elseif(dir.y > 0) then
				equivalent_thruster = equivalent_thrusters.right_face.y_pos_dir
			elseif(dir.y < 0) then
				equivalent_thruster = equivalent_thrusters.right_face.y_neg_dir
			elseif(dir.x > 0) then
				equivalent_thruster = equivalent_thrusters.right_face.x_pos_dir
			elseif(dir.x < 0) then
				equivalent_thruster = equivalent_thrusters.right_face.x_neg_dir
			end
		end

		equivalent_thruster.thruster_count = equivalent_thruster.thruster_count + 1
		equivalent_thruster.total_thrust = equivalent_thruster.total_thrust + frc
		equivalent_thruster.equivalent_position = equivalent_thruster.equivalent_position + (rad*frc)
	end

	for _,face in pairs(equivalent_thrusters) do
		for _,eqv_thruster in pairs(face) do
			eqv_thruster.equivalent_position = eqv_thruster.equivalent_position/eqv_thruster.total_thrust
		end
	end

	--Left Face
	local left_face_equivalent_thrusters = equivalent_thrusters.left_face
	new_thruster_table[1] = {radius=left_face_equivalent_thrusters.z_pos_dir.equivalent_position,direction=vector.new(0,0,1),base_force=left_face_equivalent_thrusters.z_pos_dir.total_thrust}
	new_thruster_table[2] = {radius=left_face_equivalent_thrusters.x_pos_dir.equivalent_position,direction=vector.new(1,0,0),base_force=left_face_equivalent_thrusters.x_pos_dir.total_thrust}
	new_thruster_table[3] = {radius=left_face_equivalent_thrusters.x_neg_dir.equivalent_position,direction=vector.new(-1,0,0),base_force=left_face_equivalent_thrusters.x_neg_dir.total_thrust}
	new_thruster_table[4] = {radius=left_face_equivalent_thrusters.y_neg_dir.equivalent_position,direction=vector.new(0,-1,0),base_force=left_face_equivalent_thrusters.y_neg_dir.total_thrust}
	new_thruster_table[5] = {radius=left_face_equivalent_thrusters.y_pos_dir.equivalent_position,direction=vector.new(0,1,0),base_force=left_face_equivalent_thrusters.y_pos_dir.total_thrust}

	--Right Face
	local right_face_equivalent_thrusters = equivalent_thrusters.right_face
	new_thruster_table[6] = {radius=right_face_equivalent_thrusters.z_neg_dir.equivalent_position,direction=vector.new(0,0,-1),base_force=right_face_equivalent_thrusters.z_neg_dir.total_thrust}
	new_thruster_table[7] = {radius=right_face_equivalent_thrusters.x_pos_dir.equivalent_position,direction=vector.new(1,0,0),base_force=right_face_equivalent_thrusters.x_pos_dir.total_thrust}
	new_thruster_table[8] = {radius=right_face_equivalent_thrusters.x_neg_dir.equivalent_position,direction=vector.new(-1,0,0),base_force=right_face_equivalent_thrusters.x_neg_dir.total_thrust}
	new_thruster_table[9] = {radius=right_face_equivalent_thrusters.y_neg_dir.equivalent_position,direction=vector.new(0,-1,0),base_force=right_face_equivalent_thrusters.y_neg_dir.total_thrust}
	new_thruster_table[10] = {radius=right_face_equivalent_thrusters.y_pos_dir.equivalent_position,direction=vector.new(0,1,0),base_force=right_face_equivalent_thrusters.y_pos_dir.total_thrust}

	-- local h = fs.open("./input_thruster_table/NEW_thruster_table.json","w")
	-- h.writeLine(JSON:encode_pretty(new_thruster_table))
	-- h.flush()
	-- h.close()

	return new_thruster_table
end

function drone:powerThrusters(component_redstone_power)
	if(type(component_redstone_power) == "number")then
		--left side
		self.RSIBow.setAnalogOutput("up", component_redstone_power)      	-- +Z
		self.RSIBow.setAnalogOutput("south", component_redstone_power)   	-- +X
		self.RSIBow.setAnalogOutput("north", component_redstone_power)   	-- -X
		self.RSIBow.setAnalogOutput("east", component_redstone_power)		-- -Y
		self.RSIBow.setAnalogOutput("west", component_redstone_power)		-- +Y
		--right side
		self.RSIStern.setAnalogOutput("down", component_redstone_power)  	-- -Z
		self.RSIStern.setAnalogOutput("south", component_redstone_power) 	-- +X
		self.RSIStern.setAnalogOutput("north", component_redstone_power)	-- -X
		self.RSIStern.setAnalogOutput("east", component_redstone_power)		-- -Y
		self.RSIStern.setAnalogOutput("west", component_redstone_power)		-- +Y
	else
		--left side
		self.RSIBow.setAnalogOutput("up", component_redstone_power[1])      -- +Z
		self.RSIBow.setAnalogOutput("south", component_redstone_power[2])   -- +X
		self.RSIBow.setAnalogOutput("north", component_redstone_power[3])   -- -X
		self.RSIBow.setAnalogOutput("east", component_redstone_power[4])	-- -Y
		self.RSIBow.setAnalogOutput("west", component_redstone_power[5])	-- +Y
		--right side
		self.RSIStern.setAnalogOutput("down", component_redstone_power[6])  -- -Z
		self.RSIStern.setAnalogOutput("south", component_redstone_power[7]) -- +X
		self.RSIStern.setAnalogOutput("north", component_redstone_power[8]) -- -X
		self.RSIStern.setAnalogOutput("east", component_redstone_power[9])	-- -Y
		self.RSIStern.setAnalogOutput("west", component_redstone_power[10])	-- +Y
	end
end

function drone:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveY(),0)*default_ship_orientation
end

local customDrone = drone(instance_configs)

customDrone:run()