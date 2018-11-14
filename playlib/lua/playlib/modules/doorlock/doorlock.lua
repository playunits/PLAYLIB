if !PLAYLIB then return end

PLAYLIB.doorlock = PLAYLIB.doorlock or {}

if SERVER then
	
	hook.Add("InitPostEntity","PLAYLIB::DoorLock",function()
		timer.Simple(20,function()

			local t = PLAYLIB.doorlock.lockTeams

			for k,v in pairs(t) do
				t[k] = PLAYLIB.darkrp.teamNameToNumber(v)
			end

			for index,group in pairs(PLAYLIB.doorlock.lockGroup) do
				print("PLAYLIB Locking for: "..group)
				PLAYLIB.doors.lockWithDoorGroup(group)
			end

			for index,team in pairs(t) do
				print("PLAYLIB Locking for: "..name)
				PLAYLIB.doors.lockWithDoorTeam(team)
			end 

			print("PLAYLIB Locked Doors")
		end) 
	
	end)	

elseif CLIENT then

end
	
			
			
	



