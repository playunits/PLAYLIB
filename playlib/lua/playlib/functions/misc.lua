if !PLAYLIB then return end

PLAYLIB.misc = PLAYLIB.misc or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

/*
Sends the Player a Chat Notification, with Color.

@Args ply (User Argument) = The Player to notify.
@Args vararg (Table) Structure = {Color(r,g,b),string,Color(r,g,b),string ...}
*/

function PLAYLIB.misc.chatNotify(ply,vararg)
    local _c = {}
    local _t = {}

    for i=1,#vararg do 
        if i % 2 == 0 then
           table.insert(_t,vararg[i]) 
        else
            table.insert(_c,vararg[i]) 
        end
    end

    local retval = ""

    for i=1,#_c do
        if i == #_c then
            retval = retval.."Color("..tostring(_c[i].r)..","..tostring(_c[i].g)..","..tostring(_c[i].b).."),'".._t[i].."'"
        else
            retval = retval.."Color("..tostring(_c[i].r)..","..tostring(_c[i].g)..","..tostring(_c[i].b).."),'".._t[i].."',"
        end
    end 

    if SERVER then
        ply:SendLua("chat.AddText("..retval..")")
    end
    
end

/*
Sends the Player a Notification and plays a sound.

@Args ply (User Argument) = The User to notify.
@Args text (string Argument) = The Notification Text.
@Args type (NOTIFY_ENUMS Argument) = The Notification Image to Display.
@Args length (integer Argument) = The Lenght of the Message to display
@Args sound (string Argument) = The Soundpath of the Sound to play. 
*/

function PLAYLIB.misc.notify(ply,text,type,length,sound)
    ply:SendLua("notification.AddLegacy('"..text.."',"..type..","..length..")")
    if sound then
        ply:SendLua("LocalPlayer():EmitSound(Sound('"..sound.."'))")
    end
    
end