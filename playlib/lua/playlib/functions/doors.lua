if !PLAYLIB then return end

PLAYLIB.doors = PLAYLIB.doors or {}

--if !DarkRP then return end

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here
    
end

function PLAYLIB.doors.lockWithDoorTeam(team)
	if not PLAYLIB.doors.getAllDoors() then return end
	for index,ent in pairs(PLAYLIB.doors.getAllDoors()) do
		if ent:hasDoorTeams() then
			if table.HasValue(ent:getKeysDoorTeams(),team) then
				ent:Fire("lock")
			end
		end
	end
end

function PLAYLIB.doors.lockWithDoorGroup(group)
	if not PLAYLIB.doors.getAllDoors() then return end
	for index,ent in pairs(PLAYLIB.doors.getAllDoors()) do
		if ent:hasDoorGroup() then
			print("PLAYLIB - HAS DOOR GROUP")
			if ent:getKeysDoorGroup() == group then
				print("PLAYLIB - HAS MATCHING DOOR GROUP")
				ent:Fire("lock")
			end
		end
	end
end

function PLAYLIB.doors.hasDoorTeams(ent)
	if not IsValid(ent) then return false end
	if not ent:isDoor() then return false end
	
	if type(ent:getKeysDoorTeams()) == "table" then
		return true
	end

	return false
end

function PLAYLIB.doors.hasDoorGroup(ent)
	if not IsValid(ent) then return false end
	if not ent:isDoor() then return false end
	
	if type(ent:getKeysDoorGroup()) == "string" then
		return true
	end

	return false
end

function PLAYLIB.doors.isDoor(ent)
 if not IsValid(ent) then return false end
    local class = ent:GetClass()

    if class == "func_door" or
        class == "func_door_rotating" or
        class == "prop_door_rotating" or
        class == "func_movelinear" or
        class == "prop_dynamic" then
        return true
    end
    return false
end

function PLAYLIB.doors.getAllDoors()
	local retval = {}
	for index,ent in pairs(ents.GetAll()) do
		if ent:isDoor() then
			table.insert(retval,ent)
		end
	end
	return retval
end


local ENTITY = FindMetaTable("Entity")

function ENTITY:isDoor()
	return PLAYLIB.doors.isDoor(self)
end

function ENTITY:hasDoorTeams()
	return PLAYLIB.doors.hasDoorTeams(self)
end

function ENTITY:hasDoorGroup()
	return PLAYLIB.doors.hasDoorGroup(self)
end