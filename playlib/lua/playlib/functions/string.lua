if !PLAYLIB then return end

PLAYLIB.string = PLAYLIB.string or {}

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end

function PLAYLIB.string.starts(str,char)
	return string.sub(str,1,string.len(char))==char
end

function PLAYLIB.string.contains(stringToSearchIn,stringToFind)
  local start,stop = string.find(stringToSearchIn:lower(),stringToFind:lower())

  if not start and not stop then
      return false
  else
      return true
  end
end
