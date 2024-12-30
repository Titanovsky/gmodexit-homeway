local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'prison_warehouse'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Prison Warehouse'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_nuke/crate_extrasmall.mdl',
    date = '09.09.2024 12:11'
}

function ENT:GetMetalPlanks()
    return self.nw_MetalPlanks or 0
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 1 + self:GetAngles():Right() * 1 + self:GetAngles():Forward() * 25, self:GetAngles() + Angle( 0, 90, 90 ), 0.1)
                Draw.Box( 400, 50, -190, -290, C.HOMEWAY_BLACK, 6 )
                Draw.SimpleText( -180, -280, 'Металл. Конструкции: '..self:GetMetalPlanks(), UI.SafeFont( '30 Montserrat' ), C.AMBI_GRAY, 'top-left' )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not ePly:IsArrested() then ePly:Notify( 'Эта работа только для заключённых', 4, NOTIFY_ERROR ) return end

    local count = ePly.metal_planks or 0

    if ( count > 0 ) then
        local money = 0

        for i = 1, count do
            money = money + math.random( Ambi.Homeway.Config.prison_work.min_reward, Ambi.Homeway.Config.prison_work.max_reward )
        end

        ePly.metal_planks = 0
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы положили '..count..' шт. ~G~ металл. конструкций' )
        ePly:Notify( 'Вы заработали '..money..'$', 3, NOTIFY_SUCCESS )
        ePly:AddMoney( money )

        local players = #player.GetHumans()
        if ( players > 1 ) then
            local bonus = players * Ambi.Homeway.Config.prison_work.bonus_for_player

            ePly:ChatSend( '~G~ +'..bonus..'$ ~W~ Бонус за игроков! Зовите больше людей 😉'  )
            ePly:AddMoney( bonus )
        end

        self:SetMetalPlanks( self:GetMetalPlanks() + count )

        for _, ply in ipairs( player.GetAll() ) do
            if ply:IsPolice() then 
                ply:ChatSend( '~G~ +'..money..'$ ~W~ от работы заключённого' )
            end
        end

        hook.Call( '[Ambi.Homeway.PutPrisonWarehouse]', nil, ePly, count, money )
    end
end

function ENT:SetMetalPlanks( nCount )
    self.nw_MetalPlanks = nCount or 0
end

Ents.Register( ENT.Class, 'ents', ENT )