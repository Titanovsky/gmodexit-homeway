local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'rock'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Rock'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/rust/env_node_stone_1.mdl',
    date = '19.07.2024 21:00'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800 ^ 2
    
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

    function ENT:DrawTranslucent( nFlags )
        self:DrawShadow( false )

        self:Draw( nFlags )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 8 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 6 + sin), Angle(0, rot, 90), 0.1)
            Draw.Box( 200, 54, -100, -20, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 200 - 8, 54 - 8, -100 + 4, -20 + 4, C.HOMEWAY_BLUE_DARK, 8 )
            Draw.SimpleText( 4, 4, 'Камушек', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
            Draw.Material( 64, 64, -30, -120, CL.Material( 'nav_icon7' ), C.HOMEWAY_BLUE )
        cam.End3D2D()
    end

    function ENT:Initialize()
        self:SetRenderMode( 1 )
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

local models = {
    'models/rust/env_node_metal_1.mdl',
    'models/rust/env_node_stone_1.mdl',
    'models/rust/env_node_sulfur_1.mdl'
}
function ENT:Initialize()
    RegEntity.Initialize( self, table.Random( models ) )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetRenderMode( 1 )
    self:SetHealth( 100 )
end

function ENT:StartReload()
    self.reload = true
    self:SetColor( ColorAlpha( self:GetColor(), 100 ) )
    self:SetModelScale( 1 )

    timer.Simple( Ambi.Homeway.Config.mine_reload_rock, function()
        if IsValid( self ) then self:Reload() end
    end )
end

function ENT:Reload()
    if not IsValid( self ) then return end

    self:SetHealth( 100 )

    self.reload = false

    local model = table.Random( models )
    self:SetModel( model )
    self:SetModelScale( 1 )

    self:SetColor( ColorAlpha( self:GetColor(), 255 ) )

    local stars = EffectData()
        stars:SetOrigin( self:GetPos() )
        stars:SetNormal( Vector( 1, 1, 1 ) )
    util.Effect( "trampoline_stars", stars )

    self:EmitSound( 'ambient/materials/rock3.wav' )
end

local REWARDS = {
    'stone',
    'stone',
    'stone',
    'stone',
    'stone',
    'stone',
    'stone',
    'charcoal',
    'charcoal',
    'charcoal',
    'charcoal',
    'ore_iron',
    'ore_iron',
    'ore_iron',
    'ore_iron',
    'ruby'
}

function ENT:Farm( ePly )
    --local has_farm = tobool( math.random( 0, 100 ) >= 75 )
    --if not has_farm then return end

    local rand_reward = table.Random( REWARDS )
    ePly:AddInvItemOrDrop( rand_reward, 1 )

    local name = Ambi.Inv.GetItem( rand_reward ).name

    ePly:Notify( '+'..name, 2, 2, true )

    ePly.mine_count = ( ePly.mine_count or 0 ) + 1
    if ( ePly.mine_count >= Ambi.Homeway.Config.mine_work_delay_count ) then
        timer.Create( 'Ambi.Homeway.MineRelax:'..ePly:SteamID(), Ambi.Homeway.Config.mine_work_delay, 1, function() 
            if IsValid( ePly ) then ePly.mine_count = 0 end
        end )
    end
end

local sounds = {
    'physics/concrete/rock_impact_hard1.wav',
    'physics/concrete/rock_impact_hard2.wav',
    'physics/concrete/rock_impact_hard3.wav',
    'physics/concrete/rock_impact_hard4.wav',
    'physics/concrete/rock_impact_hard5.wav',
    'physics/concrete/rock_impact_hard6.wav',
    'physics/concrete/rock_impact_soft1.wav',
    'physics/concrete/rock_impact_soft2.wav',
    'physics/concrete/rock_impact_soft3.wav',
}

function ENT:OnTakeDamage( dmgInfo )
    if self.reload then return end

    local attacker = dmgInfo:GetAttacker()
    if not attacker:IsPlayer() then return end
    if ( attacker:GetJob() ~= 'j_miner' ) then return end
    if not dmgInfo:GetInflictor() then return end
    if ( dmgInfo:GetInflictor():GetClass() ~= 'wep_mine_laser_knife' ) then return end
    if timer.Exists( 'Ambi.Homeway.MineRelax:'..attacker:SteamID() ) then attacker:Notify( 'Отдыхай '..math.Round( timer.TimeLeft( 'Ambi.Homeway.MineRelax:'..attacker:SteamID() ) )..' секунд или сходи на Завод', 2, NOTIFY_ERROR ) return end

    self:SetHealth( self:GetHealth() - dmgInfo:GetDamage() )
    self:SetModelScale( self:GetModelScale() - self:GetModelScale() * 0.01 )

    if not timer.Exists( 'Ambi.Homeway.RockInpactSound:'..self:EntIndex() ) then
        if not IsValid( self ) then return end

        timer.Create( 'Ambi.Homeway.RockInpactSound:'..self:EntIndex(), 0.5, 1, function() end )

        local impact_snd = table.Random( sounds )
        self:EmitSound( impact_snd )

        util.ScreenShake( self:GetPos(), 1, 3, 2, 500 )

        local ed = EffectData()
		ed:SetEntity( self )
		util.Effect( "entity_remove", ed, true, true )

        if IsValid( attacker ) then
            self:Farm( attacker )
        end
    end

    if ( self:GetHealth() <= 0 ) then
        self:StartReload()

        hook.Call( '[Ambi.Homeway.MineDestroyRock]', nil, attacker, self )
    end
end

RegEntity.Register( ENT.Class, 'ents', ENT )