local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 190 ) 
local COLOR_TEXT = Color(46, 46, 46)
local COLOR_PANEL_LIST = Color( 51, 54, 68)
local KEYS = {
    [ KEY_F4 ] = true,
    [ KEY_SPACE ] = true,
    [ KEY_W ] = true,
    [ KEY_A ] = true,
    [ KEY_D ] = true,
    [ KEY_S ] = true,
    [ KEY_ESCAPE ] = true,
    [ KEY_TAB ] = true,
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenPermaWeapons()
    if not LocalPlayer():Alive() then return end

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        if KEYS[ nKey ] then self:Remove() return end
    end

    local main = GUI.DrawPanel( frame, frame:GetWide() * .28, frame:GetTall() * .64, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        Draw.SimpleText( w / 2, 6, 'Perma Weapons', UI.SafeFont( '46 Montserrat' ), C.BLUE, 'top-center' )
    end ) 
    main:Center()

    local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    local i = 1
    for j, item in ipairs( Ambi.Homeway.Config.perma_weapons ) do
        if not LocalPlayer():CheckPermaWeapon( j ) then continue end

        local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 60, 4, ( i - 1 ) * ( 60 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 72, 4, item.header, UI.SafeFont( '26 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-left' )
        end )

        GUI.DrawModel( item_panel, 64, 64, 4, 0, weapons.Get( item.class ).WorldModel )

        local select = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            if LocalPlayer():HasWeapon( item.class ) then Ambi.Homeway.Notify( 'У вас уже есть это оружие', 5, NOTIFY_ERROR ) return end
            if not LocalPlayer():Alive() then Ambi.Homeway.Notify( 'Вы мертвы', 5, NOTIFY_ERROR ) return end

            net.Start( 'ambi_homeway_perma_weapon_choice' )
                net.WriteUInt( j, 7 )
            net.SendToServer()

            frame:Remove()
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
        end )

        i = i + 1
    end
end
concommand.Add( 'ambi_hw_perma_weapons', Ambi.Homeway.OpenPermaWeapons )