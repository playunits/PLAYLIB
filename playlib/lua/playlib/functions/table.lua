if !PLAYLIB then return end

PLAYLIB.table = PLAYLIB.table or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.table.buildValString(table)
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
