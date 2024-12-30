local RegEntity, C = Ambi.Packages.Out( 'regentity, colors' )
local ENT = {}

ENT.Class       = 'daily_img'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Daily Img'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Imgs'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_wasteland/kitchen_counter001d.mdl',
    date = '19.07.2024 21:07'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 600 * 600
    local COLOR_PANEL = Color( 0, 0, 0, 220 ) 
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 8 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 24 + sin), Angle(0, rot, 90), 0.1)
            Draw.Box( 200, 54, -100, -20, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 200 - 8, 54 - 8, -100 + 4, -20 + 4, C.HOMEWAY_BLUE_DARK, 8 )
            Draw.SimpleText( 4, 4, 'Станок', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
            Draw.Material( 64, 64, -30, -120, CL.Material( 'nav_icon8' ), C.HOMEWAY_BLUE )
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if self.reload then ePly:Notify( 'Станок на разогреве', 2, NOTIFY_ERROR ) return end
    if ePly.factory_prefab then ePly:Notify( 'У вас уже есть заготовка', 4, NOTIFY_ERROR ) return end
    if ePly.factory_weapon then ePly:Notify( 'Ты сделал оружие, отнеси его на склад', 4, NOTIFY_ERROR ) return end
    if timer.Exists( 'Ambi.Homeway.FactoryRelax:'..ePly:SteamID() ) then ePly:Notify( 'Отдыхай '..math.Round( timer.TimeLeft( 'Ambi.Homeway.FactoryRelax:'..ePly:SteamID() ) )..' секунд или сходи на Шахту', 9, NOTIFY_ERROR ) return end

    ePly:SendLua( 'Ambi.Homeway.OpenFactoryMachineMenu('..self:EntIndex()..')' )
    
    ePly.factory_count = ( ePly.factory_count or 0 ) + 1
    if ( ePly.factory_count >= 50 ) then
        timer.Create( 'Ambi.Homeway.FactoryRelax:'..ePly:SteamID(), 60 * 5, 1, function() end )
    end
end

function ENT:Reload()
    self.reload = false
    self:SetColor( C.ABS_WHITE )
end

function ENT:StartReload()
    self.reload = true
    self:SetColor( C.FLAT_RED )

    timer.Simple( Ambi.Homeway.Config.factory_machine_delay, function()
        if IsValid( self ) then self:Reload() end
    end )
end

RegEntity.Register( ENT.Class, 'ents', ENT )