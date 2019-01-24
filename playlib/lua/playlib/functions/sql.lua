if !PLAYLIB then return end

PLAYLIB.sql = PLAYLIB.sql or {}

if SERVER then -- Serverside Code here
    function PLAYLIB.sql.query(sql,query, successfunc, errorfunc)
	if not sql then
		MySQLite.query(query, function(res)
			if successfunc then
				successfunc(res)
			end
		end,function(error)
			if errorfunc then
				errorfunc(error)
			end
			
		end)
	else
		local res = sql.Query(query)
		if successfunc then
			successfunc(res)
		end
	end
end

function PLAYLIB.sql.sqlStr(sql,str)
	if not sql then
		return MySQLite.SQLStr(str)
	else
		return sql.SQLStr(str)
	end
end
elseif CLIENT then -- Clientside Code here
    
end

