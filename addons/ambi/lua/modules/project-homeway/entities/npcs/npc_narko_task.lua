local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_narko_task'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Барыга'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/humans/Group03/male_03.mdl',
    module = 'Homeway',
    date = '11.09.2024 6:55'
}

function ENT:PlayAnimation(animation)
    local sequence = self:LookupSequence(animation)
    if not sequence then return end
    
    if sequence then
        self:ResetSequence(sequence)
        self:SetCycle(0)
        self:SetPlaybackRate(4)  -- Устанавливаем скорость воспроизведения
    end
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 450 ^ 2

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 4, -20, 'Барыга', UI.SafeFont( '40 Montserrat Medium' ), C.AMBI_GRAY, 'center', 1, C.BLACK )
            Draw.SimpleText( 4, 10, 'Даёт нелегальные задания и скупает траву', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Hull( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_BBOX, COLLISION_GROUP_PLAYER, false, false, true )
    Ents.Capability( self, CAP_ANIMATEDFACE )
    Ents.Capability( self, CAP_TURN_HEAD )
end

function ENT:Use( ePly )
    if not ePly:GetJobTable().crime then ePly:Notify( 'Ты не в криминале', 5, NOTIFY_ERROR ) return end
    if ePly.narko_task and not ePly.has_narko_obj then ePly:Notify( 'У тебя уже есть задание', 5, NOTIFY_ERROR ) return end

    if ePly.has_narko_obj then
        ePly:SetDelay( 'NarkoTask', Ambi.Homeway.Config.narko_delay )

        ePly.narko_task = nil
        ePly.has_narko_obj = nil

        local money = math.random( Ambi.Homeway.Config.narko_money.min, Ambi.Homeway.Config.narko_money.max )

        ePly:ChatSend( '~AMBI_GRAY~ [Барыга] ~W~ Твои ~G~ '..money..'$ ~W~ , нужны будут деньги, обращайся 😉' )
        ePly:Notify( 'Вы успешно сделали задание и не попались!', 6, NOTIFY_ACCEPT )

        hook.Call( '[Ambi.Homeway.NarkoWin]', nil, ePly, money )
    else
        if ePly:GetDelay( 'NarkoTask' ) then ePly:Notify( 'Подожди '..ePly:GetDelay( 'NarkoTask' )..' секунд', 5, NOTIFY_ERROR ) return end

        local spawn = table.Random( Ambi.Homeway.Config.narko_spawns )
        
        local obj = ents.Create( 'ent_narko_obj' )
        obj:SetPos( spawn.pos )
        obj:SetAngles( spawn.ang )
        obj:Spawn()
        obj.ply = ePly 

        ePly.narko_task = true

        ePly:SetESPMarker( 'Пакетик', spawn.pos, 'icon16/box.png' )

        ePly:ChatSend( '~AMBI_GRAY~ [Барыга] ~W~ Доставь небольшой груз ко мне и побыстрей!' )
        ePly:Notify( 'Вы взяли задание', 4 )
    end
end

Ents.Register( ENT.Class, 'ents', ENT )