if !PLAYLIB then return end

PLAYLIB.easy_database = PLAYLIB.easy_database or {}
PLAYLIB.easy_database.language = PLAYLIB.easy_database.language or {}

PLAYLIB.easy_database.LangUsed = "DE"

local lang = {}
lang["SelectPreset"] = "Select your Preset..."
lang["NoPresets"] = "No Presets yet!"
lang["StandardTitle"] = "Enter a Database Table Name below to see the Entries"
lang["GetData"] = "Get Data"
lang["PopupSubmit"] = "Submit"
lang["PopupAbort"] = "Abort"
lang["PopupPlaceholder"] = "Preset Name here..."
lang["PopupRemovalTitle"] = "Enter the Preset to be removed!"
lang["PopupCreationTitle"] = "Enter the Preset to be added!"
lang["TableNotFoundTitle"] = "Table with the Name '%name' could not be found!"// Replacements: %name -> Entered Name
lang["TableNotFoundEntry"] = "Table not found!"// Replacements: %name -> Entered Name
lang["TableEmptyTitle"] = "Table with the Name '%name' is Empty!"// Replacements: %name -> Entered Name
lang["TableEmptyEntry"] = "%name has no Contents!"// Replacements: %name -> Entered Name
lang["TableFound"] = "Found %resultCount Results in %name with %keysCount Keys!"// Replacements: %name -> Entered Name | %resultCount -> Amount of received Results | %keysCount -> Amount of Keys
PLAYLIB.easy_database.language["EN"] = lang

lang["SelectPreset"] = "Wähle dein Preset..."
lang["NoPresets"] = "Keine Presets!"
lang["StandardTitle"] = "Gib einen Datenbank Namen unten ein!"
lang["GetData"] = "Anzeigen"
lang["PopupSubmit"] = "Abgeben"
lang["PopupAbort"] = "Abbrechen"
lang["PopupPlaceholder"] = "Preset Name hier..."
lang["PopupRemovalTitle"] = "Das zu entfernende Preset hier eingeben!"
lang["PopupCreationTitle"] = "Das zu hinzufügende Preset hier eingeben!"
lang["TableNotFoundTitle"] = "Eintrag mit dem Namen '%name' wurde nicht gefunden!"// Replacements: %name -> Entered Name
lang["TableNotFoundEntry"] = "Eintrag nicht gefunden!"// Replacements: %name -> Entered Name
lang["TableEmptyTitle"] = "Eintrag mit dem Namen '%name' ist leer!"// Replacements: %name -> Entered Name
lang["TableEmptyEntry"] = "%name hat keinen Inhalt!"// Replacements: %name -> Entered Name
lang["TableFound"] = "%resultCount Ergebnisse in %name mit %keysCount Schlüsseln gefunden!"// Replacements: %name -> Entered Name | %resultCount -> Amount of received Results | %keysCount -> Amount of Keys
PLAYLIB.easy_database.language["DE"] = lang
