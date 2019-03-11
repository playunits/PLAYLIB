if !PLAYLIB then return end

PLAYLIB.table = PLAYLIB.table or {}

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end

-- Shared Code below here

function PLAYLIB.table.tableToString(table)
		local retval = "{"

		for i=1,#table do
			if i == #table then
				retval = retval..table[i]
			else
				retval = retval..table[i]..","
			end
		end

		return retval.."}"
	end

function PLAYLIB.table.removeByKey(t,key)
  local tbl = table.Copy(t)
  tbl[key] = nil
  return tbl
end

table.removeByKey = PLAYLIB.table.removeByKey
