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

function PLAYLIB.table.contains(tbl,str)
	local found = {}
	for _,entry in SortedPairs(tbl) do
		entry = tostring(entry)
		if string.find(entry,str) then
			table.insert(found)
		end
	end

	if table.Count(found) <1 then
		return found
	else
		return found[1]
	end
end

table.contains = PLAYLIB.table.contains

function PLAYLIB.table.append(target,to_concat)
	local retval = table.Copy(target)

	for _,val in SortedPairs(to_concat) do
		table.insert(retval,val)
	end

	return retval
end

table.append = PLAYLIB.table.append
