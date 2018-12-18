if !PLAYLIB then return end

PLAYLIB.workshop = PLAYLIB.workshop or {}

--[[
	The Link to open via the Console Command
]]--
PLAYLIB.workshop.workshopPage = "https://google.de"

--[[
	The Name of the Console Command
]]--
PLAYLIB.workshop.conCommandName = "workshop"

--[[
	Language Settings:
	PLAYLIB.workshop.PanelTitle = The Title of the Window
	PLAYLIB.workshop.PanelText = The text Displayed on the Middle of the Window. This is an RTF (Rich-Text-Field) so feel free to use \n etcpp.
	PLAYLIB.workshop.YesButton = The text of the Button to open the workshop Link
	PLAYLIB.workshop.NoButton = The text of the Button to stop the Window from showing up. (ex.: "Do not show again")
]]--
PLAYLIB.workshop.PanelTitle = "Workshop Inhalte downloaden?"
PLAYLIB.workshop.PanelText = "Wie gehts %pname ?\n Sieht so aus als wärst du das erste mal bei uns.\n Möchtest du unsere Workshop Inhalte herunterladen?"
PLAYLIB.workshop.YesButton = "Ja"
PLAYLIB.workshop.NoButton = "Nichtmehr anzeigen"

if SERVER then
	
elseif CLIENT then
	
end