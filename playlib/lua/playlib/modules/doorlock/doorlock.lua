if !PLAYLIB then return end

PLAYLIB.doorlock = PLAYLIB.doorlock or {}

if SERVER then
	
	

elseif CLIENT then

end


	
	
	

hook.Add("InitPostEntity","PLAYLIB::DoorLock",function()
	timer.Simple(10,function()

		if #PLAYLIB.doorlock.lockGroup > 0 then 
			for i=1,#PLAYLIB.doorlock.lockGroup do
				PLAYLIB.doors.lockWithDoorGroup(PLAYLIB.doorlock.lockGroup[i])
			end
		end

		if #PLAYLIB.doorlock.lockTeams > 0 then
			for i=1,#PLAYLIB.doorlock.lockTeams do
				PLAYLIB.doors.lockWithDoorTeam(PLAYLIB.doorlock.lockTeams[i])
			end
		end
		
		

	end) 
	
end)

