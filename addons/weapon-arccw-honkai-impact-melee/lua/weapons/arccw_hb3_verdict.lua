SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Honkai Impact" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Verdict"
SWEP.Trivia_Class = "Knife"
SWEP.Trivia_Desc = "That’s Raiden Mei The Herrscher Of Thunder's sword."
SWEP.Trivia_Manufacturer = "miHoYo"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Sharp Edge"
SWEP.Trivia_Country = "China"
SWEP.Trivia_Year = nil

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/bh_melee/c_verdict.mdl"
SWEP.WorldModel = "models/weapons/arccw/bh_melee/w_verdict.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(3, 1, 0),
    ang = Angle(-180, -180, 0)
}

SWEP.PrimaryBash = true

SWEP.MeleeDamage = 34
SWEP.MeleeRange = 38
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeTime = 0.5
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MeleeAttackTime = 0.1

SWEP.Melee2 = true
SWEP.Melee2Damage = 72
SWEP.Melee2Range = 38
SWEP.Melee2Time = 1
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Melee2AttackTime = 0.1

SWEP.MeleeHitSound = {
    "weapons/arccw/bh_melee/katana/melee_katana_01.wav",
    "weapons/arccw/bh_melee/katana/melee_katana_02.wav",
    "weapons/arccw/bh_melee/katana/melee_katana_03.wav"
}

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "knife"

SWEP.Primary.ClipSize = -1

SWEP.Attachments = {
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "body", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(7.5, -0.5, 0.7), -- offset that the attachment will be relative to the bone
            vang = Angle(-90, -270, 0),
        },
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 1.2
    },
    ["bash"] = {
        Source = {"swing_e_w", "swing_e_w_02"},
        Time = 1,
        SoundTable = {{s = "weapons/arccw/bh_melee/katana/katana_swing_miss1.wav", "weapons/arccw/bh_melee/katana/katana_swing_miss2.wav", t = 0}}
    },
    ["bash2"] = {
        Source = {"swing_w_e", "swing_w_e_02"},
        Time = 1.2,
        SoundTable = {{s = "weapons/arccw/bh_melee/katana/katana_swing_miss1.wav", "weapons/arccw/bh_melee/katana/katana_swing_miss2.wav", t = 0}}
    },
}

sound.Add({
	name = 			"Katana.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 		"weapons/arccw/bh_melee/katana/katana_deploy_1.wav"
})

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 0)

SWEP.CrouchPos = Vector(-20.658, -5.026, -2)
SWEP.CrouchAng = Angle(0, -28.844, -70)

SWEP.HolsterPos = Vector(0, -1, 2)
SWEP.HolsterAng = Angle(-15, 0, 0)

SWEP.CustomizePos = Vector(10, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)