if !PLAYLIB then return end

PLAYLIB.chatadverts = PLAYLIB.chatadverts or {}

if SERVER then
	
	timer.Create( "PLAYLIB::ChatAdverts", PLAYLIB.chatadverts.AdvertTime, 0, function()
		for index,ply in pairs(player.GetAll()) do
			for index,tbl in pairs(PLAYLIB.chatadverts.AdvertText) do
				PLAYLIB.misc.chatNotify(ply,tbl)
			end
		end
	end )

elseif CLIENT then

end
