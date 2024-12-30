local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_questgiver'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Quest Giver'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/npc/luka_nurse_npc.mdl',
    module = 'Homeway',
    date = '16.08.2024 13:56'
}

function ENT:PlayAnimation(animation)
    local sequence = self:LookupSequence(animation)
    if not sequence then return end
    
    if sequence then
        self:ResetSequence(sequence)
        self:SetCycle(0)
        self:SetPlaybackRate(1)  -- Устанавливаем скорость воспроизведения
    end
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

    local W, H = ScrW(), ScrH()
    local COLOR_PANEL = Color( 0, 0, 0, 220 ) 
    local DISTANCE = 450 ^ 2

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        self:PlayAnimation('Sit_Ground')

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' ) or 0
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 16 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 4, -20, 'Маркус', UI.SafeFont( '40 Montserrat Medium' ), C.AMBI, 'center', 1, C.BLACK )
            Draw.SimpleText( 4, 10, 'Помогает новичкам', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    function Ambi.Homeway.ShowQuest1Button()
        local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
            if not LocalPlayer():Alive() then self:Remove() return end
    
            Draw.Blur( self, 2 )
    
            Draw.Box( w, h, 0, 0, COLOR_PANEL )
    
            if not self.main then return end
        end )
        frame:SetAlpha( 0 )
        frame:AlphaTo( 255, 2, 1, function() end )
    
        local close = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall(), 0, 0, nil, nil, nil, function()
            frame:Remove()
        end, function( self, w, h ) 
        end )
        close:SetCursor( 'arrow' )
    
        local main = GUI.DrawPanel( frame, frame:GetWide() * .28, 140, 0, 0, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )
    
            Draw.SimpleText( w / 2, 16, 'Начать первый квест?', UI.SafeFont( '40 Montserrat SemiBold' ), C.WHITE, 'top-center' )
        end ) 
        main:Center()

        local accept = GUI.DrawButton( main, 110, 34, 16, main:GetTall() - 34 - 16, nil, nil, nil, function()
            frame:Remove()

            net.Start( 'ambi_homeway_quest1_accept' )
            net.SendToServer()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )

            Draw.SimpleText( w / 2, h / 2, 'Начать', UI.SafeFont( '32 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center' )
        end )

        local cancel = GUI.DrawButton( main, 110, 34, main:GetWide() - 110 - 16, main:GetTall() - 34 - 16, nil, nil, nil, function()
            frame:Remove()

            surface.PlaySound( 'ambi/homeway/quest1/2.ogg' )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )

            Draw.SimpleText( w / 2, h / 2, 'Похуй', UI.SafeFont( '32 Montserrat Medium' ), C.FLAT_RED, 'center' )
        end )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    --Ents.Hull( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_BBOX, COLLISION_GROUP_PLAYER, false, false, true )
    --Ents.Capability( self, CAP_ANIMATEDFACE )
    --Ents.Capability( self, CAP_TURN_HEAD )
end

function ENT:Use( ePly )
    if ePly:GetFinishedQuest( 'q_guide1' ) then ePly:Notify( 'Вы прошли первый квест', 4, NOTIFY_ERROR ) return end
    if ePly:GetQuest() then return end

    if timer.Exists( 'DelayMarkus' ) then return end
    timer.Create( 'DelayMarkus', 4, 1, function() end )

    self:EmitSound( 'ambi/ui/bell1.mp3' )
    self:EmitSound( 'ambi/homeway/quest1/1.ogg' )

    ePly:SendLua( 'Ambi.Homeway.ShowQuest1Button()' )
    ePly:ChatSend( '~AMBI~ [Маркус] ~W~ Хей, привет, ~AMBI~ '..ePly:Name()..' ~W~ , тебе помочь освоится в этом городе?' )
end

Ents.Register( ENT.Class, 'ents', ENT )