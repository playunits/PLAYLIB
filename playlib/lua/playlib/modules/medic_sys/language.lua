
if !PLAYLIB then return end

PLAYLIB.medic_sys = PLAYLIB.medic_sys or {}

if SERVER then
	
elseif CLIENT then
	PLAYLIB.medic_sys.Language = {}

	PLAYLIB.medic_sys.Language["List.Title"] = "Medizinische Einträge"
	PLAYLIB.medic_sys.Language["Menu.File"] = "Datei"
	PLAYLIB.medic_sys.Language["MenuFile.CreateNew"] = "Neuer Eintrag"
	PLAYLIB.medic_sys.Language["List.ID"] = "NR."
	PLAYLIB.medic_sys.Language["List.CreatorName"] = "Ersteller"
	PLAYLIB.medic_sys.Language["List.TargetName"] = "Patient"
	PLAYLIB.medic_sys.Language["List.CreationDate"] = "Datum"
	PLAYLIB.medic_sys.Language["Menu.DeleteFile"] = "Eintrag löschen"
	PLAYLIB.medic_sys.Language["Entry.Title"] = "Eintrag Nummer: %id"
	PLAYLIB.medic_sys.Language["Entry.CreatorName"] = "Ersteller"
	PLAYLIB.medic_sys.Language["Entry.TargetName"] = "Patient"
	PLAYLIB.medic_sys.Language["Entry.CreationDate"] = "Datum"
	PLAYLIB.medic_sys.Language["Entry.FileEntry"] = "Akten-Eintrag"
	PLAYLIB.medic_sys.Language["Create.CreateNew"] = "Neuen Eintrag anlegen"
	PLAYLIB.medic_sys.Language["Create.CreatorName"] = "Ersteller"
	PLAYLIB.medic_sys.Language["Create.TargetName"] = "Patient"
	PLAYLIB.medic_sys.Language["Create.SelectPlayer"] = "Wähle einen Spieler aus ..."
	PLAYLIB.medic_sys.Language["Create.FileEntry"] = "Akten-Eintrag"
	PLAYLIB.medic_sys.Language["Create.Characters"] = "%chars/%maxchars Buchstaben"
	PLAYLIB.medic_sys.Language["Create.Submit"] = "Abgeben"
	PLAYLIB.medic_sys.Language["Icon.NewEntry"] = "icon16/folder_add.png"
	PLAYLIB.medic_sys.Language["Icon.DeleteEntry"] = "icon16/folder_delete.png"
end