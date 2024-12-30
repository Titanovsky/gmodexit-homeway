SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Honkai Impact" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Vollerei Starchasm"
SWEP.Trivia_Class = "Knife"
SWEP.Trivia_Desc = "That’s Seele Vollerei Starchasm Nyx's Sickle."
SWEP.Trivia_Manufacturer = "miHoYo"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Sharp Edge"
SWEP.Trivia_Country = "China"
SWEP.Trivia_Year = nil

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/bh_melee/c_shovel.mdl"
SWEP.WorldModel = "models/weapons/arccw/bh_melee/w_shovel.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(3, 1, 0),
    ang = Angle(-180, -180, 0)
}

SWEP.PrimaryBash = true

SWEP.MeleeDamage = 72
SWEP.MeleeRange = 48
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeTime = 0.5
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MeleeAttackTime = 0.1

SWEP.Melee2 = true
SWEP.Melee2Damage = 128
SWEP.Melee2Range = 48
SWEP.Melee2Time = 1
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Melee2AttackTime = 0.1

SWEP.MeleeHitSound = {
    "weapons/arccw/bh_melee/shovel/shovel_impact_flesh1.wav",
    "weapons/arccw/bh_melee/shovel/shovel_impact_flesh2.wav",
    "weapons/arccw/bh_melee/shovel/shovel_impact_flesh3.wav",
    "weapons/arccw/bh_melee/shovel/shovel_impact_flesh4.wav"
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
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 1.2
    },
    ["bash"] = {
        Source = {"swing_e_w", "swing_e_nw"},
        Time = 1,
        SoundTable = {{s = "weapons/arccw/bh_melee/shovel/shovel_swing_miss1.wav", "weapons/arccw/bh_melee/katana/shovel_swing_miss3.wav", t = 0}}
    },
    ["bash2"] = {
        Source = {"swing_w_e", "swing_nw_se"},
        Time = 1.2,
        SoundTable = {{s = "weapons/arccw/bh_melee/shovel/shovel_swing_miss2.wav", "weapons/arccw/bh_melee/katana/shovel_swing_miss4.wav", t = 0}}
    },
}

sound.Add({
	name = 			"Shovel.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 		"weapons/arccw/bh_melee/shovel/shovel_deploy_1.wav"
})

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 4, 0)

SWEP.HolsterPos = Vector(0, -1, 2)
SWEP.HolsterAng = Angle(-15, 0, 0)

SWEP.CustomizePos = Vector(10, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)