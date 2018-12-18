if !PLAYLIB then return end

PLAYLIB.captcha = PLAYLIB.captcha or {}

PLAYLIB.captcha.questions = {
	[1] = {"1 Euro sind umgerechnet ____ Cent?","100"},
	[2] = {"Wie nennt man gefrorenes Wasser?","Eis"},
	[3] = {"Wie lauten die letzten drei Buchstaben des Wortes >Internet<?","net"},
	[4] = {"Welches bekannte Farmtier produziert Milch? (ohne Artikel)","Kuh"},
	[5] = {"Was dreht sich um die Erde? (ohne Artikel)","Mond"},
	[6] = {"Wieviel Beine hat der Mensch? (Zahl ausschreiben)","Zwei"}
}

PLAYLIB.captcha.startTries = 3

PLAYLIB.captcha.PanelTitle = "Captcha - Du hast noch %tries Versuche!"
PLAYLIB.captcha.SubmitText = "Abgeben"
PLAYLIB.captcha.DisconnectText = "Disconnect"

PLAYLIB.captcha.CaptchaSuccess = "Du hast das Captcha gelöst!"
PLAYLIB.captcha.CaptchaFail  = "Du hast das Capcha nicht gelöst!"

PLAYLIB.captcha.Prefix = "PLAYLIB"
PLAYLIB.captcha.PrefixColor = Color(250,128,114) 


if SERVER then
	
elseif CLIENT then
	
end