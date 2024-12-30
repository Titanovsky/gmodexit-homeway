local RegEnt = Ambi.Packages.Out( 'regentity' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = Ambi.BoomBox.Config.ent_class
ENT.Type	    = 'anim'

ENT.PrintName	= 'Бумбокс'
ENT.Author		= 'Ambi'
ENT.Category	= 'BoomBox'
ENT.Spawnable   =  true
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Stats = {
    module = 'BoomBox',
    date = '09.03.2023 08:05'
}

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, Ambi.BoomBox.Config.ent_model )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( Ambi.BoomBox.Config.ent_health )
    self:SetPlayRadio( false )
end

function ENT:SetPlayRadio( bEnable, nRadio )
    self.nw_Radiostation = nRadio
    self.nw_PlayRadio = bEnable

    hook.Call( '[Ambi.BoomBox.SetPlayRadio]', nil, self, bEnable, nRadio )
end

function ENT:OnTakeDamage( damageInfo )
    if not Ambi.BoomBox.Config.ent_damage_enable then return end

    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:GetUser()
    return self.user_player
end

function ENT:SetUser( ePly )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end

    self.user_player = ePly
    ePly.owned_boombox = self

    hook.Call( '[Ambi.BoomBox.SetUser]', nil, self, ePly )
end

function ENT:RemoveUser( ePly )
    self.user_player = nil
    if ePly then ePly.owned_boombox = nil end

    hook.Call( '[Ambi.BoomBox.RemovedUser]', nil, self, ePly )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not Ambi.BoomBox.Config.enable then ePly:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Система BoomBox отключена!' ) return end
    if self:GetUser() then ePly:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'В этот бумбокс уже смотрит '..self:GetUser():Nick() ) return end
    if ( hook.Call( '[Ambi.BoomBox.CanUse]', nil, self, ePly ) == false ) then return end

    self:SetUser( ePly )
    
    net.Start( 'ambi_boombox_open_menu' )
        net.WriteEntity( self )
    net.Send( ePly )

    hook.Call( '[Ambi.BoomBox.Used]', nil, self, ePly )
end

RegEnt.Register( ENT.Class, 'ents', ENT )