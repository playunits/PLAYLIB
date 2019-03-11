if !PLAYLIB then return end

PLAYLIB.string = PLAYLIB.string or {}

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end

function PLAYLIB.string.starts(str,char)
	return string.sub(str,1,string.len(char))==char
end

function PLAYLIB.string.contains(stringToSearchIn,stringToFind)
  local start,stop = string.find(string.lower(stringToSearchIn),string.lower(stringToFind))

  if not start and not stop then
      return false
  else
      return true
  end
end

function PLAYLIB.string.multiReplace(replaceString,tbl)
	local res = replaceString
	for i=1,table.Count(tbl) do
		if i%2 != 1 then continue end
		res = string.Replace(res,tbl[i],tbl[i+1])
	end

	return res
end

string.multiReplace = PLAYLIB.string.multiReplace
