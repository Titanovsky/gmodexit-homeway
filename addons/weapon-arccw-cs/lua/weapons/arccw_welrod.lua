SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - CS+" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Infiltrator"
SWEP.TrueName = "Убивашка"
SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".45 caliber pistol designed to be as silent as absolutely possible. A bolt action allows it to reduce its report by eliminating bolt carrier noise."
SWEP.Trivia_Manufacturer = "Inter-Services Research Bureau"
SWEP.Trivia_Calibre = ".45 ACP"
SWEP.Trivia_Mechanism = "Bolt Action"
SWEP.Trivia_Country = "Great Britain"
SWEP.Trivia_Year = 1942

SWEP.Slot = 1

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.UseHands = true --

SWEP.ViewModel = "models/weapons/arccw/c_welrod.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_welrod.mdl"
SWEP.ViewModelFOV = 90

SWEP.Damage = 9999
SWEP.DamageMin = 9999 -- damage done at maximum range
SWEP.Range = 2500 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 50 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 8 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 12
SWEP.ReducedClipSize = 5

SWEP.Recoil = 8
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 1

SWEP.ManualAction = true

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "BOLT"
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 10

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 250 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "welrod" -- the magazine pool this gun draws from

SWEP.ShootVol = 120 -- volume of shoot sound
SWEP.ShootPitch = 170 -- pitch of shoot sound

SWEP.ShootSound = "vo/Citadel/eli_mygirl.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/mp5/mp5_01.wav"

SWEP.MuzzleEffect = "muzzleflash_suppressed"
SWEP.ShellModel = "models/maxofs2d/logo_gmod_b.mdl"
SWEP.ShellScale = 0.05

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.175

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.81, 5, 1.3),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(1, 8, -2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(3.5, 6, -2)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.AttachmentBodygroups = {}
-- ["name"] = {ind = 1, bg = 1}
-- same as ACT3

SWEP.ExtraSightDist = 9

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp", -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -2.25, 6), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(1.829, 0.676, -2.916),
            wang = Angle(-9, 0, 180)
        },
        Installed = 'optic_delta',
        VMScale = Vector(1, 1, 1), --Vector(0.75, 0.75, 0.75),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "Standard Barrel",
        Slot = "barrel",
    },
    {
        PrintName = "Underbarrel",
        Slot = "foregrip_pistol",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0, -0.5, 5),
            vang = Angle(90, 0, -90),
            wpos = Vector(7.238, 1.641, -2.622),
            wang = Angle(90, -4.211, 0)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac_pistol",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0, -0.5, 12), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(11.711, 0.67, -2.864),
            wang = Angle(-9, 0, 180)
        },
        Installed = 'tac_rainbow',
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "No Stock",
        InstalledEles = {"stock"},
    },
    {
        PrintName = "Ammo Type",
        Slot = "ammo_bullet"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "Weapon_Bolt", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.225, -0.125, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, -90),
            wpos = Vector(7.5, 1, -3.5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["ready"] = {
        Source = "ready",
        Time = 0.25
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.75,
        SoundTable = {
            {
            s = "weapons/arccw/hkp2000/hkp2000_draw.wav",
            t = 0
            }
        }
    },
    ["cycle"] = {
        Source = "cycle",
        Time = 0.5,
        ShellEjectAt = 0.5,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["fire"] = {
        Source = "shoot",
        Time = 0.25,
    },
    ["fire_iron"] = {
        Source = "shoot_iron",
        Time = 0.35,
    },
    ["reload"] = {
        Source = "reload_part",
        Time = 1,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.25,
        LHIKOut = 0.75,
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 1.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.25,
        LHIKOut = 0.75,
    },
}

-- function SWEP:DrawWorldModel( flags )
-- 	self:DrawModel( flags )

--     local mdl = self:GetWeaponWorldModel()
--     if not IsValid( mdl ) then return end

--     self:SetMaterial( 'lights/white' )
--     self:SetColor( HSVToColor(  ( CurTime() * 35 ) % 360, 1, 1 ) )
-- end

function SWEP:Hook_OnDeploy()
    if CLIENT then return end
    if self.has_first_time then return end

    timer.Simple( 0.25, function()
        if not IsValid( self ) then return end

        self:Attach( 1, 'optic_delta' )
        self:Attach( 4, 'tac_rainbow' )
    end )

    self.has_first_time = true
end

if CLIENT then return end

local RANDOM_SOUNDS = {
    'ambi/csz/other/ultrakill.ogg',
    'ambi/csz/other/female_holyshit.ogg',
    'ambi/csz/other/female_wickedsick.ogg',
    'ambi/csz/other/rampage.ogg',
    'ambi/csz/other/monsterkill.ogg',
    'ambi/csz/other/perfect.ogg',
}

KillWelrod = KillWelrod or {}

hook.Add( 'PlayerDeath', 'Ambi.Homeway.ArcCW_Welrod', function( eVictim, eInf, eAttacker ) 
    if not IsValid( eAttacker ) or not eAttacker:IsPlayer() then return end
    
    local wep = eAttacker:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if ( wep:GetClass() ~= 'arccw_welrod' ) then return end

    KillWelrod[ eAttacker:SteamID() ] = KillWelrod[ eAttacker:SteamID() ] or 0
    KillWelrod[ eAttacker:SteamID() ] = KillWelrod[ eAttacker:SteamID() ] + 1

    local snd = table.Random( RANDOM_SOUNDS )
    eAttacker:EmitSound( snd, 90, nil, nil, CHAN_WEAPON )
    eAttacker:ChatSend( '~W~ 🎯 Ты уебал ~R~ '..KillWelrod[ eAttacker:SteamID() ]..' ~W~ существ Убивашкой' )

    eVictim:ChatSend( '~W~ 💀 Тебя захуярили ~R~ Убивашкой ~W~ [F6]' )

    hook.Call( '[Ambi.Homeway.ArcCWKillWelrod]', nil, eAttacker, eVictim )
end )

hook.Add( 'OnNPCKilled', 'Ambi.Homeway.ArcCW_Welrod', function( eVictim, eInf, eAttacker ) 
    if not IsValid( eAttacker ) or not eAttacker:IsPlayer() then return end

    local wep = eAttacker:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if ( wep:GetClass() ~= 'arccw_welrod' ) then return end

    KillWelrod[ eAttacker:SteamID() ] = KillWelrod[ eAttacker:SteamID() ] or 0
    KillWelrod[ eAttacker:SteamID() ] = KillWelrod[ eAttacker:SteamID() ] + 1

    local snd = table.Random( RANDOM_SOUNDS )
    eAttacker:EmitSound( snd, 90, nil, nil, CHAN_WEAPON )
    eAttacker:ChatSend( '~W~ 🎯 Ты уебал ~R~ '..KillWelrod[ eAttacker:SteamID() ]..' ~W~ существ Убивашкой' )

    hook.Call( '[Ambi.Homeway.ArcCWKillWelrod]', nil, eAttacker, eVictim )
end )

hook.Add( 'EntityTakeDamage', 'Ambi.Homeway.ArcCW_Welrod', function( eTarget, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
    if not IsValid( attacker ) or not attacker:IsPlayer() then return end

    local wep = attacker:GetActiveWeapon()
    if not IsValid( wep ) then return end
    if ( wep:GetClass() ~= 'arccw_welrod' ) then return end
    
    local can = eTarget:IsPlayer() or eTarget:IsNPC()
    if not can then return end
    
    if eTarget.can_take_damage_welrod then return end
    eTarget.can_take_damage_welrod = true

    local dmg = dmgInfo:GetDamage()
    dmgInfo:SetDamage( 0 )

    local knockbackDirection = ( eTarget:GetPos() - dmgInfo:GetDamagePosition() ):GetNormalized() * 600

    --eTarget:SetVelocity( eTarget:GetVelocity() * Vector( -1, -1, -1 ) )
    eTarget:SetVelocity( knockbackDirection + Vector( 0, 0, 1200 ) )

    local dmginfo = dmgInfo

    timer.Simple( .15, function() 
        if not IsValid( eTarget ) then return end
        if not IsValid( attacker ) then return end

        eTarget:TakeDamage( 9999, attacker, wep )

        eTarget.can_take_damage_welrod = false
    end )
end )