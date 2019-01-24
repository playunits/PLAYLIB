if !PLAYLIB then return end

PLAYLIB.chatcommand = PLAYLIB.chatcommand or {}

PLAYLIB.chatcommand.commands = {}

if SERVER then -- Serverside Code here

	PLAYLIB.chatcommand.commands = {}

	function PLAYLIB.chatcommand.addCommand(name,response)
		if not PLAYLIB.chatcommand.commands then PLAYLIB.chatcommand.commands = {} end
		PLAYLIB.chatcommand.commands[name] = response
	end

	hook.Add("PlayerSay","PLAYLIB::ChatCommandCheck",function(ply,text,public)
		local cT = PLAYLIB.chatcommand.commands

		local tT = string.Split(text,' ')


		if cT[tT[1]] then
			if isfunction(cT[tT[1]]) then
				local func = cT[tT[1]]
				func(ply,tT[1],text)

			else
				local responseEdit = string.Replace(cT[tT[1]],"%pname",ply:Name())
				PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.chatcommand.PrefixColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - "..responseEdit})
			end
			return ""
		end

	end)
elseif CLIENT then -- Clientside Code here

end
