if !PLAYLIB then return end

PLAYLIB.chatadverts = PLAYLIB.chatadverts or {}

if SERVER then
	PLAYLIB.chatadverts.AdvertText = {
		{Color(255,100,0)  ,"┌─────── ",Color(100,255,0),"★ gUnion.de ★",Color(255,100,0)," ───────┐"},
		{Color(255,255,255),"⋙ Das Charaktersystem öffnet ihr mit F6"},
		{Color(255,255,255),"⋙ Die Kollektion findet ihr unter /kollektion"},
		{Color(255,255,255),"⋙ Mit !steam könnt ihr unserer Steam-Gruppe beitreten!"},
		{Color(255,255,255),"⋙ Unter !forum findest du den Forumlink"},
		{Color(255,255,255),"⋙ Unter !ts findest du unsere TeamSpeak Adresse"},
		{Color(255,255,255),"⋙ Nutzt bei Problemen den @ Chat"},
		{Color(255,100,0)  ,"└─────── ",Color(100,255,0),"★ gUnion.de ★",Color(255,100,0)," ───────┘"},
	}

	PLAYLIB.chatadverts.AdvertTime = 360
elseif CLIENT then

end
