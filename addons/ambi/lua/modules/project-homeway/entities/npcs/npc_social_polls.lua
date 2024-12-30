local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_social_polls'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Social Polls'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/characters/gallaha.mdl',
    module = 'Homeway',
    date = '28.08.2024 7:15'
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
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local DISTANCE = 450 ^ 2
    local W, H = ScrW(), ScrH()

    local COLOR_SMALL_BLACK = Color( 56, 56, 56 )
    local COLOR_PANEL = Color( 0, 0, 0, 190 ) 

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 4, -20, 'Уильям Ханнэкен', UI.SafeFont( '40 Montserrat Medium' ), C.AMBI_BLOOD, 'center', 1, C.BLACK )
            Draw.SimpleText( 4, 10, 'Проводит соц. опросы за деньги', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    function Ambi.Homeway.OpenSurveys( tFreeSurveys )
        if not LocalPlayer():Alive() then return end

        local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
            if not LocalPlayer():Alive() then self:Remove() return end

            Draw.Blur( self, 2 )

            Draw.Box( w, h, 0, 0, COLOR_PANEL )
        end )
        frame.OnKeyCodePressed = function( self, nKey )
            self:Remove()
        end

        local close = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall(), 0, 0, nil, nil, nil, function()
            frame:Remove()
        end, function( self, w, h ) 
        end )

        local main = GUI.DrawPanel( frame, frame:GetWide() * .4, frame:GetTall() * .64, 0, 0, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

            Draw.SimpleText( w / 2, 6, 'Соц. Опросы', UI.SafeFont( '46 Montserrat' ), C.FLAT_RED, 'top-center' )
        end ) 
        main:Center()

        local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
        end )

        for i = 1, #tFreeSurveys do
            local id = tFreeSurveys[ i ]
            local item = Ambi.Statistic.Survey.table[ id ]
            local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 60, 4, ( i - 1 ) * ( 60 + 4 ) + 4, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )
    
                Draw.SimpleText( w / 2, h / 2, item.question, UI.SafeFont( '26 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center' )
            end )

            local buy = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
                frame:Remove()

                Ambi.Statistic.Survey.CallQuestion( id )
            end, function( self, w, h ) 
                --Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
            end )
        end
    end

    net.Receive( 'ambi_homeway_send_free_questions', function()
        Ambi.Homeway.OpenSurveys( net.ReadTable() )
    end )

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
    local tab = Ambi.Statistic.Survey.GetFreeQuestions( ePly )
    if not tab then ePly:Notify( 'Вы прошли все соц. опросы на данный момент!', 10, NOTIFY_ERROR ) return end

    ePly.survey_ready = true

    net.Start( 'ambi_homeway_send_free_questions' )
        net.WriteTable( tab )
    net.Send( ePly )
end

net.AddString( 'ambi_homeway_send_free_questions' )

Ents.Register( ENT.Class, 'ents', ENT )

hook.Add( '[Ambi.Statistic.Survey.GaveAnswer]', 'Ambi.Homeway.Reward', function( ePly, nID, nAnswerID, tSurvey )
    local money = math.random( 500, 3000 )

    Ambi.UI.Chat.SendAll( '~W~ ✅ Игрок ~HOMEWAY_BLUE~ '..ePly:Name()..' ~W~ прошёл соц. опрос и получил ~G~ '..money..'$' )
    Ambi.Homeway.NotifyAll( 'Соц. опросы можно пройти в Мэрии', 6 )

    ePly:AddMoney( money )
end )