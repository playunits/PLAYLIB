hook.Add( "PlayerSay", "Mood", function( sender, text, teamChat )
	text = string.lower( text )
	if PLAYLIB.string.starts(text, "!") or PLAYLIB.string.starts(text, "/")  then
		return ""
	end
end )
