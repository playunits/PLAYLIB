if !PLAYLIB then return end

PLAYLIB.chatadverts = PLAYLIB.chatadverts or {}

if SERVER then
	PLAYLIB.chatadverts.AdvertText = {
		{Color(255,255,255),"┌────────────────────────┐"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!rewards",Color(255,255,255), " öffnet sich unser Steam Referral Addon"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!workshop",Color(255,255,255)," öffnet sich unsere Kollektion als Link"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!forum",Color(255,255,255)," öffnet sich unser Forum als Link"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!ts",Color(255,255,255)," erhaltet ihr unsere Teamspeak IP"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!kartellmünzen",Color(255,255,255)," kommst du in unseren Kartellmünzen Shop"},
		{Color(255,255,255),"Mit ",Color(255,0,0),"!uptime",Color(255,255,255)," siehst du wie lange der Server online ist"},
		{Color(255,255,255),"Mit drücken von ",Color(255,0,0),"G",Color(255,255,255)," änderst du deine Sprachlautstärke"},
		{Color(255,255,255),"└────────────────────────┘"},
	}

	PLAYLIB.chatadverts.AdvertTime = 600
elseif CLIENT then

end

--lua_run PLAYLIB.misc.chatNotify(player.GetAll()[1],{Color(0,0,0),"test"})
