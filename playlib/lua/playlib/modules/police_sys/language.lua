
if !PLAYLIB then return end

PLAYLIB.police_sys = PLAYLIB.police_sys or {}

if SERVER then
	
elseif CLIENT then
	PLAYLIB.police_sys.Language = {}

	PLAYLIB.police_sys.Language["List.Title"] = "ST Einträge"
	PLAYLIB.police_sys.Language["Menu.File"] = "Datei"
	PLAYLIB.police_sys.Language["MenuFile.CreateNew"] = "Neuer Eintrag"
	PLAYLIB.police_sys.Language["List.ID"] = "NR."
	PLAYLIB.police_sys.Language["List.CreatorName"] = "Ersteller"
	PLAYLIB.police_sys.Language["List.TargetName"] = "Betroffener"
	PLAYLIB.police_sys.Language["List.CreationDate"] = "Datum"
	PLAYLIB.police_sys.Language["Menu.DeleteFile"] = "Eintrag löschen"
	PLAYLIB.police_sys.Language["Entry.Title"] = "Eintrag Nummer: %id"
	PLAYLIB.police_sys.Language["Entry.CreatorName"] = "Ersteller"
	PLAYLIB.police_sys.Language["Entry.TargetName"] = "Betroffener"
	PLAYLIB.police_sys.Language["Entry.CreationDate"] = "Datum"
	PLAYLIB.police_sys.Language["Entry.FileEntry"] = "Akten-Eintrag"
	PLAYLIB.police_sys.Language["Create.CreateNew"] = "Neuen Eintrag anlegen"
	PLAYLIB.police_sys.Language["Create.CreatorName"] = "Ersteller"
	PLAYLIB.police_sys.Language["Create.TargetName"] = "Betroffener"
	PLAYLIB.police_sys.Language["Create.SelectPlayer"] = "Wähle einen Spieler aus ..."
	PLAYLIB.police_sys.Language["Create.FileEntry"] = "Akten-Eintrag"
	PLAYLIB.police_sys.Language["Create.Characters"] = "%chars/%maxchars Buchstaben"
	PLAYLIB.police_sys.Language["Create.Submit"] = "Abgeben"
	PLAYLIB.police_sys.Language["Create.Presets"] = "Voreingestellt"
	PLAYLIB.police_sys.Language["Create.SelectPreset"] = "Voreinstellung auswählen"
	PLAYLIB.police_sys.Language["Create.PresetNone"] = "Keine Voreinstellung"
	PLAYLIB.police_sys.Language["Icon.NewEntry"] = "icon16/folder_add.png"
	PLAYLIB.police_sys.Language["Icon.DeleteEntry"] = "icon16/folder_delete.png"

	PLAYLIB.police_sys.Language["Presets"] = {
		"Unerlaubter Schusswaffengebrauch",
		"Fliegen ohne Erlaubnis",
		"Ist ein Spacken"
	}
end