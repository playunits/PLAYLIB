if !PLAYLIB then return end

PLAYLIB.widget_disabler = PLAYLIB.widget_disabler or {}

if SERVER then
	

	hook.Add( "PreGamemodeLoaded", "PLAYLIB::DisableWidgets", function()
		MsgN( "[PLAYLIB] Disabling Widgets" )
		function widgets.PlayerTick()
		end
		hook.Remove( "PlayerTick", "TickWidgets" )
		MsgN( "[PLAYLIB] Widgets succesfully disabled!" )
	end )


elseif CLIENT then
	
end

