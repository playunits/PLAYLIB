if !PLAYLIB then return end

PLAYLIB.easy_database = PLAYLIB.easy_database or {}

if SERVER then
  util.AddNetworkString("PLAYLIB.easy_database:RequestData")
  util.AddNetworkString("PLAYLIB.easy_database:SendData")

  net.Receive("PLAYLIB.easy_database:RequestData",function(len,ply)
    local name = net.ReadString()
    if not name or name == "" then // Case Name is invalid

    else
      local data = PLAYLIB.easy_database:SelectAllFromTable(name)
      if type(data) == "string" then //Case Error

        if PLAYLIB.string.contains(data,"no such table") then
          net.Start("PLAYLIB.easy_database:SendData")
          net.WriteString(string.Replace(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["TableNotFoundTitle"],"%name",name))
            net.WriteTable({[1]="Error"})
            net.WriteTable( { [1]={["Error"]=string.Replace(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["TableNotFoundEntry"],"%name",name)}})
          net.Send(ply)
        end
      elseif not data or data == {} then // Case no result
        net.Start("PLAYLIB.easy_database:SendData")
        net.WriteString(string.Replace(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["TableEmptyTitle"],"%name",name))
          net.WriteTable({[1]="Empty"})
          net.WriteTable( { [1]={["Empty"]=string.Replace(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["TableEmptyEntry"],"%name",name)}})
        net.Send(ply)
      else
        local keys = table.GetKeys(data[1])
        net.Start("PLAYLIB.easy_database:SendData")
          net.WriteString(string.multiReplace(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["TableFound"],{"%name",name,"%resultCount",table.Count(data),"%keysCount",table.Count(keys)}))
          net.WriteTable(keys)
          net.WriteTable(data)
        net.Send(ply)
      end
    end
  end)
elseif CLIENT then

end
