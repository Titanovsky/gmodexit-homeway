local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local w = ScrW()
local h = ScrH()

local adversary = Entity( 1 )
local award = 16
local health = 32
local armor = 64
local gun = 'gmod_tool'

function Ambi.Duel.OpenRegister()
    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( 460, 400 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame.Paint = function( self, w, h )
        draw.RoundedBox( 4, 0, 0, w, h, C.AMBI )
        draw.RoundedBox( 4, 4, 4, w - 8, h - 8, C.AMBI_BLACK )

        draw.SimpleText( '[ 0 > HP > '..Ambi.Duel.Config.max_health..' ]', UI.SafeFont( '18 Ambi' ), w / 2, 46 * 3.2, C.AMBI_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( '[ Armor > 255 ]', UI.SafeFont( '18 Ambi' ), w / 2, 46 * 3.8, C.AMBI_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.SimpleText( 'HP', UI.SafeFont( '22 Ambi' ), 22, 46 * 4.5, C.AMBI_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( 'Armor', UI.SafeFont( '22 Ambi' ), 12, 46 * 5.5, C.AMBI_BLUE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( '$', UI.SafeFont( '22 Ambi' ), 28, 46 * 6.5, C.AMBI_GREEN, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local combo_adversary = vgui.Create( 'DComboBox', frame )
    combo_adversary:SetSize( 320, 44 )
    combo_adversary:SetPos( frame:GetWide() / 2 - combo_adversary:GetWide() / 2, 46 )
    combo_adversary:SetFont( UI.SafeFont( '22 Ambi' ) )
    combo_adversary:SetValue( 'Choose the adversary' )
    combo_adversary.OnSelect = function( self, index, value )
        adversary = Ambi.Duel.FindName( value )
    end

    for _, ply in ipairs( player.GetAll() ) do
        if ply ~= LocalPlayer() then
            combo_adversary:AddChoice( ply:Nick() )
        end
    end

    local combo_gun = vgui.Create( 'DComboBox', frame )
    combo_gun:SetSize( 320, 44 )
    combo_gun:SetPos( frame:GetWide() / 2 - combo_gun:GetWide() / 2, 46 * 2 )
    combo_gun:SetFont( UI.SafeFont( '22 Ambi' ) )
    combo_gun:SetValue( 'Choose a weapon' )
    combo_gun.OnSelect = function( self, index, value )
	    gun = value
    end

    for _, weapon in pairs( Ambi.Duel.Config.access_guns ) do
        combo_gun:AddChoice( weapon )
    end

    local te_health = vgui.Create( 'DTextEntry', frame )
    te_health:SetSize( 320, 44 )
    te_health:SetPos( frame:GetWide() / 2 - te_health:GetWide() / 2, 46 * 4 )
    te_health:SetFont( UI.SafeFont( '22 Ambi' ) )
    te_health:SetValue( '' )
    te_health:SetNumeric( true )
    te_health.OnChange = function( self )
        health = tonumber( te_health:GetValue() )
    end

    local te_armor = vgui.Create( 'DTextEntry', frame )
    te_armor:SetSize( 320, 44 )
    te_armor:SetPos( frame:GetWide() / 2 - te_health:GetWide() / 2, 46 * 5 )
    te_armor:SetFont( UI.SafeFont( '22 Ambi' ) )
    te_armor:SetValue( '' )
    te_armor:SetNumeric( true )
    te_armor.OnChange = function( self )
        armor = tonumber( self:GetValue() )
    end

    local te_award = vgui.Create( 'DTextEntry', frame )
    te_award:SetSize( 320, 44 )
    te_award:SetPos( frame:GetWide() / 2 - te_health:GetWide() / 2, 46 * 6 )
    te_award:SetFont( UI.SafeFont( '22 Ambi' ) )
    te_award:SetValue( '' )
    te_award:SetNumeric( true )
    te_award.OnChange = function( self )
        award = tonumber( self:GetValue() )
    end

    local send = vgui.Create( 'DButton', frame )
    send:SetSize( 320, 44 )
    send:SetPos( frame:GetWide() / 2 - te_health:GetWide() / 2, 46 * 7.2 )
    send:SetFont( UI.SafeFont( '22 Ambi' ) )
    send:SetTextColor( C.ABS_WHITE )
    send:SetText( 'Go Duel' )
    send.Paint = function( self, w, h )
        draw.RoundedBox( 4, 0, 0, w, h, C.AMBI )
        draw.RoundedBox( 4, 2, 2, w - 4, h - 4, C.AMBI_BLACK )
    end
    send.DoClick = function( self )
        frame:Remove()

        if Ambi.Duel.ValidationData() then return Ambi.Duel.CollectInfo() end
    end
end
concommand.Add( 'ambi_duel', Ambi.Duel.OpenRegister )

function Ambi.Duel.CollectInfo()
    net.Start( 'ambi_duel' )
        net.WriteEntity( adversary )
        net.WriteUInt( award, 17 )
        net.WriteUInt( health, 17 )
        net.WriteUInt( armor, 17 )
        net.WriteString( gun )
    net.SendToServer()
end

function Ambi.Duel.FindName( sName )
    for _, v in ipairs( player.GetAll() ) do
        if ( v:Nick() == sName ) then return v end
    end

    return nil
end

function Ambi.Duel.ValidationData()
    if ( adversary == LocalPlayer() ) or ( adversary:IsPlayer() == false ) then return false end
    if ( award < Ambi.Duel.Config.min_award ) or ( award > Ambi.Duel.Config.max_award ) then return false end
    if ( armor < 0 ) or ( armor > 255 ) then return false end
    if ( health < 0 ) or ( health > Ambi.Duel.Config.max_health ) then return false end

    return true
end