if !PLAYLIB then return end

PLAYLIB.chatcommand = PLAYLIB.chatcommand or {}

--[[
	Language:
	PLAYLIB.chatcommand.Prefix = The Prefix displayed in the Chat, on execution of the Command.
	PLAYLIB.chatcommand.PrefixColor = The Color of the displayed Prefix.
]]--
PLAYLIB.chatcommand.Prefix = "PLAYLIB"

PLAYLIB.chatcommand.PrefixColor = Color(250,128,114)

if SERVER then -- Serverside Code here


    --[[
		Adding Commands: (This has to be done Serverside!)



		Parameters:
			1. String - The Text to enter in order to execute the command.
			2. String or function
				String - The text to reply in the Text. %pname is going to be replaced by the Executing Players Name.
				function - The function to execute. Has the executing Player as an Argument

    ]]--
    --PLAYLIB.chatcommand.addCommand("!workshop",function(ply) PLAYLIB.workshop.showWorkshopPanel(ply,false) end)

    /*
    PLAYLIB.chatcommand.addCommand("!lroll",function(ply,cmd,msg)
       for index,player in pairs(ents.FindInSphere(ply:GetPos()),meter*10) do
         if !player:IsPlayer() then
            continue
          else
            PLAYLIB.misc.chatNotify(player,{Color(255,255,255),"[",PLAYLIB.chatcommand.PrefixColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - "..ply:Name().." hat eine "..tostring(math.random(0,100)).." gewürfelt."})
          end
       end
     end)
    */
    timer.Simple(2,function()

      PLAYLIB.chatcommand.addCommand("!workshop",function(ply,cmd,msg) ply:SendLua("gui.OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1619231332')") end)
      PLAYLIB.chatcommand.addCommand("!forum",function(ply,cmd,msg) ply:SendLua("gui.OpenURL('https://projectgaming.eu/forum/')") end)
      PLAYLIB.chatcommand.addCommand("!ts","Unseren Teamspeak findest du unter projectgaming.eu")

      PLAYLIB.chatcommand.addCommand("!groll",function(ply,cmd,msg)
        local nr = math.random(0,100)
         for index,player in pairs(player.GetAll()) do
           PLAYLIB.misc.chatNotify(player,{Color(255,255,255),"[",PLAYLIB.chatcommand.PrefixColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - "..ply:Name().." hat eine "..tostring(nr).." gewürfelt."})
         end
       end)

       PLAYLIB.chatcommand.addCommand("!lroll",function(ply,cmd,msg)
         local nr = math.random(0,100)
          for index,player in pairs(ents.FindInSphere(ply:GetPos(),53*10)) do
            if !player:IsPlayer() then
               continue
             else
               PLAYLIB.misc.chatNotify(player,{Color(255,255,255),"[",PLAYLIB.chatcommand.PrefixColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - "..ply:Name().." hat eine "..tostring(nr).." gewürfelt."})
             end
          end
        end)


  end)
elseif CLIENT then -- Clientside Code here

end
