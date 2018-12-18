if !PLAYLIB then return end

PLAYLIB.chatcommand = PLAYLIB.chatcommand or {}

PLAYLIB.chatcommand.commands = {}

if SERVER then -- Serverside Code here

	PLAYLIB.logger.logs = {}

	function PLAYLIB.logger.addLogger(identifier)
		local path = "playlib/logger/"..identifier
		PLAYLIB.logger.logs[identifier].path = path
		PLAYLIB.logger.logs[identifier].lastLogFileTime = 0
		PLAYLIB.logger.logs[identifier].actualLog = nil

		if !file.Exists(path,"DATA") then
			file.CreateDir(path)
		end

		if PLAYLIB.logger.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Created Logger with identifier "..identifier.."!")
		end
	end

	function PLAYLIB.logger.log(identifier,text)
		if not PLAYLIB.logger.logs[identifier] then
			if PLAYLIB.logger.debug then
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Tried to log with non existing Logger: "..identifier.."!")
			end
		end
		local time = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
		local newfile = PLAYLIB.logger.logs[identifier].path..time..".txt"
		if PLAYLIB.logger.logs[identifier].actualLog == nil then
			file.Write(newfile,"")
			PLAYLIB.logger.logs[identifier].actualLog = newfile
			PLAYLIB.logger.logs[identifier].lastLogFileTime = os.time()
			if PLAYLIB.logger.debug then
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Created new Logfile for Identifier: "..identifier.." cause there existed none!")
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] New Logfile: "..PLAYLIB.logger.logs[identifier].actualLog.."!")
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] New Last Log Time: "..PLAYLIB.logger.logs[identifier].lastLogFileTime.."("..os.date( "%H:%M:%S - %d/%m/%Y" , PLAYLIB.logger.logs[identifier].lastLogFileTime )..")!")
			end

		elseif os.time>PLAYLIB.logger.logs[identifier].lastLogFileTime+PLAYLIB.logger.newLogFileAfter then
			local lasttime = PLAYLIB.logger.logs[identifier].lastLogFileTime
			file.Write(newfile,"")
			PLAYLIB.logger.logs[identifier].actualLog = newfile
			PLAYLIB.logger.logs[identifier].lastLogFileTime = os.time()
			if PLAYLIB.logger.debug then
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Created new Logfile for Identifier: "..identifier.." cause the last one was created "..os.time()-lasttime.." Seconds ago!")
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] New Logfile: "..PLAYLIB.logger.logs[identifier].actualLog.."!")
				MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] New Last Log Time: "..PLAYLIB.logger.logs[identifier].lastLogFileTime.."("..os.date( "%H:%M:%S - %d/%m/%Y" , PLAYLIB.logger.logs[identifier].lastLogFileTime )..")!")
			end

		end

		file.Append(PLAYLIB.logger.logs[identifier].actualLog,"["..os.date( "%H:%M:%S - %d/%m/%Y" , os.time() ).."] - "..text.."\n")

		if PLAYLIB.logger.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Added Text to Logfile "..PLAYLIB.logger.logs[identifier].actualLog.."!")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [LOGGER] Text: "..text.."!")
		end
	end

	function PLAYLIB.logger.createDataDir()
		if !file.Exists("playlib/logger","DATA") then
			file.CreateDir("playlib/logger")
		end
	end

elseif CLIENT then -- Clientside Code here

end

