-- Model adapted from this: https://steamcommunity.com/sharedfiles/filedetails/?id=646754302
-- Thanks!

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms" -- edit this if you like
SWEP.AdminOnly = false

SWEP.AutoIconAngle = Angle(90, 0, 0)

SWEP.PrintName = 'Гаусска'
SWEP.Trivia_Class = "Antimateriel Rifle"
SWEP.Trivia_Desc = "Advanced anti-materiel rifle developed following controversial tests at the 2020 Lingshan Incident. Its lethality is comparable to .50 BMG rounds, but has more power and less recoil."
SWEP.Trivia_Manufacturer = "CryNet Armories"
SWEP.Trivia_Calibre = "10mm Slug"
SWEP.Trivia_Mechanism = "Magnetic Acceleration"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 2025

SWEP.Slot = 4

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_gauss_rifle.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_gauss_rifle.mdl"
SWEP.ViewModelFOV = 75

SWEP.Damage = 500
SWEP.DamageMin = 90 -- damage done at maximum range
SWEP.Range = 1200 -- in METRES
SWEP.Penetration = 80
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 150 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.Tracer = "ToolTracer"
SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(28, 105, 222)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 12 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 2

SWEP.Recoil = 2.5
SWEP.RecoilSide = 2
SWEP.MaxRecoilBlowback = 0.7

SWEP.Delay = 60 / 120 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {"weapon_crossbow"}
SWEP.NPCWeight = 10

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 900 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250

SWEP.Primary.Ammo = "SniperPenetratedRound" -- what ammo type the gun uses
SWEP.MagID = "gauss_rifle" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 65 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw/gauss_rifle/gauss-1.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/m4a1/m4a1_01.wav"
SWEP.DistantShootSound = nil --"weapons/arccw/bfg/bfg_fire_distant.wav"

SWEP.MuzzleEffect = nil
SWEP.ShellModel = "models/shells/shell_338mag.mdl"
SWEP.ShellPitch = 60
SWEP.ShellScale = 2

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.95
SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 1

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-1.841, 0, 0.879),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.ActivePos = Vector(1, 4, 0.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(7, 6, -2)

SWEP.HolsterPos = Vector(6, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 55
SWEP.AttachmentElements = {
    ["extendedmag"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
    },
}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic", "optic_sniper", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "body", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-5, -4.5, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(180, 0, -90),
            wpos = Vector(10, 1, -8),
            wang = Angle(-5, 0, 180)
        },
        VMScale = Vector(1, 1, 1), --Vector(0.75, 0.75, 0.75),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
        Installed = "optic_gauss_scope",
        ExtraSightDist = 5,
    },
    {
        PrintName = "Capacitor",
        DefaultAttName = "Standard Capacitors",
        Slot = "gauss_rifle_capacitor",
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip", "bipod"},
        Bone = "body",
        Offset = {
            vpos = Vector(-14, -1, 0),
            vang = Angle(180, 0, -90),
            wpos = Vector(18, 1, -4),
            wang = Angle(-5, 0, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "body",
        Offset = {
            vpos = Vector(-20, -1.2, 0),
            vang = Angle(180, 0, -90),
            wpos = Vector(28, 1, -5),
            wang = Angle(-5, 0, 180)
        },
        ExtraSightDist = 15
    },
    {
        PrintName = "Munitions",
        DefaultAttName = "Iron Slugs",
        Slot = "gauss_rifle_bullet"
    },
    {
        PrintName = "Perk",
        Slot = {"perk", "go_perk"}
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "body", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-5, -1.5, 0.7), -- offset that the attachment will be relative to the bone
            vang = Angle(180, 0, -90),
            wpos = Vector(10, 2, -4),
            wang = Angle(-5, 0, 180)
        },
    },
}

SWEP.Hook_PreDoEffects = function(wep, fx)
    return true
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    local cap = wep.Attachments[2].Installed
    if anim and cap == "gauss_rifle_capacitor" then
        return anim .. "_turbo"
    end
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 4
    },
    ["draw"] = {
        Source = "draw",
        Time = 1.5,
        LHIK = false
    },
    ["fire"] = {
        Source = "shoot",
        Time = 1.2,
    },
    ["fire_turbo"] = {
        Source = "shoot_turbo",
        Time = 1.2,
    },
    ["fire_iron"] = {
        Source = "shoot_iron",
        Time = 1.2,
    },
    ["fire_iron_turbo"] = {
        Source = "shoot_iron",
        Time = 1.2 / 1.5,
    },
    ["reload"] = {
        Source = "reload",
        Time = 5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {25, 50, 70, 100, 115},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 1,
    },
}

sound.Add({
    name = "ArcCW_Gauss_Rifle.Draw",
    channel = CHAN_WEAPON,
    volume = 1.0,
    sound = "weapons/arccw/gauss_rifle/draw.wav"
})

sound.Add({
    name = "ArcCW_Gauss_Rifle.Boltback",
    channel = CHAN_WEAPON,
    volume = 1.0,
    sound = "weapons/arccw/gauss_rifle/boltback.wav"
})

sound.Add({
    name = "ArcCW_Gauss_Rifle.Boltforward",
    channel = CHAN_WEAPON,
    volume = 1.0,
    sound = "weapons/arccw/gauss_rifle/boltforward.wav"
})

sound.Add({
    name = "ArcCW_Gauss_Rifle.Clipout",
    channel = CHAN_WEAPON,
    volume = 1.0,
    sound = "weapons/arccw/gauss_rifle/clipout.wav"
})

sound.Add({
    name = "ArcCW_Gauss_Rifle.Clipin",
    channel = CHAN_WEAPON,
    volume = 1.0,
    sound = "weapons/arccw/gauss_rifle/clipin.wav"
})

local cvar = CreateConVar("arccw_gauss_rifle_op", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable to make the Gauss Rifle very overpowered. Set to 2 to also make it admin only.", 0, 2)
if cvar:GetInt() > 0 then
    SWEP.AdminOnly = (cvar:GetInt() > 1)
    SWEP.Recoil = 2.5
    SWEP.RecoilSide = 1
    SWEP.HipDispersion = 300
    SWEP.MoveDispersion = 150
    SWEP.SpeedMult = 0.9
    SWEP.SightedSpeedMult = 0.6
    SWEP.SightTime = 0.3
end

if CLIENT then return end

function SWEP:Hook_OnDeploy()
    if self.has_first_time then return end

    timer.Simple( 0.25, function()
        if not IsValid( self ) then return end

        self:Attach( 1, 'optic_gauss_scope' )
    end )

    self.has_first_time = true
end

KillGauss = KillGauss or {}

hook.Add( 'PlayerDeath', 'Ambi.Homeway.ArcCW_Gauss', function( eVictim, eInf, eAttacker ) 
    if not IsValid( eAttacker ) or not eAttacker:IsPlayer() then return end
    
    local wep = eAttacker:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if ( wep:GetClass() ~= 'arccw_gauss_rifle' ) then return end

    KillGauss[ eAttacker:SteamID() ] = KillGauss[ eAttacker:SteamID() ] or 0
    KillGauss[ eAttacker:SteamID() ] = KillGauss[ eAttacker:SteamID() ] + 1

    eAttacker:ChatSend( '~W~ 🧿 Ты аннигилировал ~R~ '..KillGauss[ eAttacker:SteamID() ]..' ~W~ существ Гаусской' )
    eVictim:ChatSend( '~W~ 💀 Тебя аннигилировали ~R~ Гаусской ~W~ [F6]' )

    hook.Call( '[Ambi.Homeway.ArcCWKillGauss]', nil, eAttacker, eVictim )
end )

hook.Add( 'OnNPCKilled', 'Ambi.Homeway.ArcCW_Gauss', function( eVictim, eInf, eAttacker ) 
    if not IsValid( eAttacker ) or not eAttacker:IsPlayer() then return end

    local wep = eAttacker:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if ( wep:GetClass() ~= 'arccw_gauss_rifle' ) then return end

    KillGauss[ eAttacker:SteamID() ] = KillGauss[ eAttacker:SteamID() ] or 0
    KillGauss[ eAttacker:SteamID() ] = KillGauss[ eAttacker:SteamID() ] + 1

    eAttacker:ChatSend( '~W~ 🧿 Ты аннигилировал ~R~ '..KillGauss[ eAttacker:SteamID() ]..' ~W~ существ Гаусской' )

    hook.Call( '[Ambi.Homeway.ArcCWKillGauss]', nil, eAttacker, eVictim )
end )