if !PLAYLIB then return end

PLAYLIB.holo = PLAYLIB.holo or {}

if SERVER then
	PLAYLIB.holo.Prefix = "PLAYLIB"
	PLAYLIB.holo.PrefixColor = Color(250,128,114)
elseif CLIENT then
	
end

PLAYLIB.holo.BoneList = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Anim_Attachment_RH",
	"ValveBiped.Anim_Attachment_LH",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Shoulder",
	"ValveBiped.Bip01_R_Elbow",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Shoulder",
	"ValveBiped.Bip01_L_Elbow",
	"ValveBiped.Bip01_L_Toe0",
	"ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_L_UpperArm"
}
