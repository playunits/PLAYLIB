if !PLAYLIB then return end

PLAYLIB.Logger = PLAYLIB.Logger or {}
PLAYLIB.Logger.Logs = PLAYLIB.Logger.Logs or {}

function PLAYLIB.Logger:Create(identifier)
	local path = "playlib/logger/"..identifier
	PLAYLIB.Logger.Logs[identifier] = {}
	PLAYLIB.Logger.Logs[identifier].LastLogCreatedOn = 0
	PLAYLIB.Logger.Logs[identifier].CurLog = nil

	if !file.Exists(path,"DATA") then
		file.CreateDir(path)
	end
end

function PLAYLIB.Logger:Log(identifier,text)
	if not PLAYLIB.Logger:Exists(identifier) then return end
	local time = os.date( "%H.%M.%S - %d.%m.%Y" , os.time() )
	local name = "playlib/logger/"..identifier.."/"..time..".txt"
	if PLAYLIB.Logger:TimeForNewLog(identifier) or PLAYLIB.Logger.Logs[identifier].CurLog == nil then
		file.Write(name,"")
		PLAYLIB.Logger.Logs[identifier].CurLog = name
		PLAYLIB.Logger.Logs[identifier].LastLogCreatedOn = SysTime()
	end

	file.Append(PLAYLIB.Logger.Logs[identifier].CurLog, "["..time.."] - "..text.."\n")
end

function PLAYLIB.Logger:TimeForNewLog(identifier)
	if SysTime() >= (PLAYLIB.Logger.Logs[identifier].LastLogCreatedOn+PLAYLIB.Logger.decay) then
		return true
	end

	return false
	
end

function PLAYLIB.Logger:Exists(identifier)
	local retval
	if PLAYLIB.Logger.Logs[identifier] then
		retval = true
	else
		retval = false
	end

	return retval
end