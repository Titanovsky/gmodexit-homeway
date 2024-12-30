local RegEnt, C = Ambi.RegEntity, Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------
local SWEP = {}
SWEP.Primary = {}
SWEP.Secondary = {}

SWEP.Class          = 'money_checker'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'Homeway'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'Money Checker'                   
SWEP.Author         = 'Ambi'
SWEP.Instructions   = 'ПКМ - Проверить деньги'
SWEP.Slot           = 1    
SWEP.SlotPos        = 9
SWEP.DrawCrosshair  = false
SWEP.DrawAmmo  = false
SWEP.Weight         = 5 
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV   = 62
SWEP.AnimPrefix     = 'rpg'

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = ''

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = ''

SWEP.UseHands=true

if CLIENT then
    function SWEP:DrawWorldModel( flags )
        --self:DrawModel( flags )
    end
end

function SWEP:Initialize()
    self:SetHoldType( 'normal' )
end

function SWEP:Deploy()
    return true
end

function SWEP:PreDrawViewModel(vm)
    return true
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    if CLIENT then return end

    local owner = self:GetOwner()
   
    local ent = owner:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPlayer() or ent:GetPos():DistToSqr(owner:GetPos()) > 200 ^ 2 then
        return
    end

    owner:ChatSend( '~W~ У игрока ~FLAT_GREEN~ '..ent:Name()..' ~W~ в наличии ~FLAT_GREEN~ '..string.Comma( ent:GetMoney() )..'$' )
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )