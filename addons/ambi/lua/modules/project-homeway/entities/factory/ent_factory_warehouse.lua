local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'factory_warehouse'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Warehouse'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Factory'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_nuke/crate_extrasmall.mdl',
    date = '19.07.2024 20:10'
}

function ENT:GetWeapon( sClass )
    return self[ 'nw_'..sClass ] or 0
end

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 600 * 600
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 8 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 16 + sin), Angle(0, rot, 90), 0.1)
            Draw.Box( 200, 54, -100, -20, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 200 - 8, 54 - 8, -100 + 4, -20 + 4, C.HOMEWAY_BLUE_DARK, 8 )
            Draw.SimpleText( 4, 4, 'Склад', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
        cam.End3D2D()

        cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 42 + self:GetAngles():Right() * 20 + self:GetAngles():Forward() * 25, self:GetAngles() + Angle( 0, 90, 90 ), 0.1)
            Draw.Box( 400, 340, 0, 0, C.HOMEWAY_BLACK, 6 )

            local i = 0
            for class, tab in pairs( Ambi.Homeway.Config.factory_items ) do
                i = i + 1

                Draw.SimpleText( 12, 40 * ( i - 1 ), i..'. '..tab.header..'  x'..self:GetWeapon( class ), UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-left', 1, C.BLACK )
            end
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    local index = self:EntIndex()
    timer.Create( 'Ambi.Homeway.FillFactoryWarehouse:'..index, Ambi.Homeway.Config.factory_auto_fill, 0, function() 
        if not IsValid( self ) then timer.Remove( 'Ambi.Homeway.FillFactoryWarehouse:'..index ) return end

        local wep = table.Random( table.GetKeys( Ambi.Homeway.Config.factory_items ) )

        self:AddWeapon( wep, math.random( 1, 5 ) )
    end )
end

function ENT:OnRemove()
    timer.Remove( 'Ambi.Homeway.FillFactoryWarehouse:'..self:EntIndex() )
end

function ENT:SpawnBox( ePly )
    if timer.Exists( 'Ambi.Homeway.FactoryWarehouseSpawnBoxDelay' ) then ePly:Notify( 'Подождите '..math.Round( timer.TimeLeft( 'Ambi.Homeway.FactoryWarehouseSpawnBoxDelay' ) )..' секунд', 4, NOTIFY_ERROR ) return end

    local can = false
    for class, item in pairs( Ambi.Homeway.Config.factory_items ) do
        if ( self:GetWeapon( class ) > 0 ) then can = true break end
    end
    if not can then return end

    local wh
    for _, obj in ipairs( ents.FindByClass( 'warehouse' ) ) do
        if ( ePly:GetJob() == 'j_sheriff' ) and obj:GetWarehouse() == 'police' then
            wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )
        elseif ( ePly:GetJob() == 'j_fbi_leader' ) and obj:GetWarehouse() == 'fbi' then
            wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )
        end
    end
    if not wh then return end

    local box = ents.Create( 'factory_box' )
    box:SetPos( self:GetPos() + Vector( 0, 0, 30 ) )
    box:Spawn()

    for i, item in ipairs( wh.items ) do
        local max = item.max or 999
        local count = math.min( self:GetWeapon( item.class ), max )

        if ( count > 0 ) then 
            self:SetWeapon( item.class, self:GetWeapon( item.class ) - count )
            box:SetWeapon( item.class, count ) 
        end
    end

    for _, ply in ipairs( player.GetAll() ) do
        ply:Notify( ePly:GetJobTable().name..' начал перевозку оружия из Завода', 22 )
        ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..ePly:GetJobTable().name..' начал перевозку оружия из Завода' )
    end

    timer.Create( 'Ambi.Homeway.FactoryWarehouseSpawnBoxDelay', Ambi.Homeway.Config.factory_warehouse_spawn_box_delay, 1, function() end )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if ( ePly:GetJob() == 'j_sheriff' ) or ( ePly:GetJob() == 'j_fbi_leader' ) then self:SpawnBox( ePly ) return end
    if not ePly.factory_weapon then ePly:Notify( 'Сначала сделайте оружие', 4, NOTIFY_ERROR ) return end

    local class = ePly.factory_weapon
    local info = Ambi.Homeway.Config.factory_items[ ePly.factory_weapon ]

    ePly:ChatSend( '~G~ • ~W~ Ты отнёс ~G~ '..info.header, 6, 2 )

    local reward = info.cost

    ePly:Notify( '+'..reward..'$', 4, 2 )
    ePly:AddMoney( reward )

    if ( ePly:GetJob() == 'j_fc_worker' ) then
        ePly:Notify( 'Премия заводчанину +'..Ambi.Homeway.Config.factory_bonus..'$', 7, 2 )
        ePly:AddMoney( Ambi.Homeway.Config.factory_bonus )
    end

    self:AddWeapon( ePly.factory_weapon, 1 )
    ePly.factory_weapon = nil

    hook.Call( '[Ambi.Homeway.FactoryPutWarehouse]', nil, ePly, self, info, class )
end

function ENT:SetWeapon( sClass, nCount )
    self[ 'nw_'..sClass ] = nCount
end

function ENT:AddWeapon( sClass, nCount )
    self:SetWeapon( sClass, self:GetWeapon( sClass ) + nCount )
end

RegEntity.Register( ENT.Class, 'ents', ENT )