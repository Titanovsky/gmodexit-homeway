local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageGuide( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
    end )

    local panel_questions = GUI.DrawScrollPanel( panel, panel:GetWide(), panel:GetTall() / 1.6, 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
    end )

    local panel_answer = GUI.DrawScrollPanel( panel, panel:GetWide(), panel:GetTall() - panel_questions:GetTall() - 8, 0, panel_questions:GetTall() + 8, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
        Draw.Box( w - 16, h - 16, 8, 8, C.HOMEWAY_BLUE_DARK, 6 )
    end )

    for i, phrase in SortedPairs( Ambi.Homeway.Config.help_text ) do
        local page = GUI.DrawButton( panel_questions, panel_questions:GetWide(), 36, 0, ( i - 1 ) * ( 36 + 4 ) + 4, nil, nil, nil, function( self )
            surface.PlaySound( 'ambi/ui/click_tower_unite.wav' )

            panel_answer:Clear()

            local text = vgui.Create( 'RichText', panel_answer )
            text:SetPos( 8, 8 )
            text:SetSize( panel_answer:GetWide() - 16, panel_answer:GetTall() - 16 )
            text:AppendText( phrase.answer )
            text.PerformLayout = function( self )
                self:SetFontInternal( UI.SafeFont( '32 Montserrat' ) )
                self:SetFGColor( C.HOMEWAY_WHITE )
            end
        end, function( self, w, h )
            -- Draw.Box( w, h, 0, 0, COLOR_GREEN, 6 )
            Draw.Box( w - 8, h, 4, 0, self.color_background, 6 )
            Draw.Text( 6, h / 2, i, UI.SafeFont( '36 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'center-left', 1, C.BLACK )
            Draw.Text( w / 2, h / 2, phrase.question, UI.SafeFont( '36 Montserrat' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
        end )
        page.color_background = C.HOMEWAY_BLUE_DARK

        GUI.OnCursor( page, function( self ) 
            surface.PlaySound( 'ambi/ui/hover7.wav' )
    
            self.color_background = ColorAlpha( C.HOMEWAY_BLUE_DARK, 100 )
        end, function( self ) 
            self.color_background = C.HOMEWAY_BLUE_DARK
        end )
    end
end