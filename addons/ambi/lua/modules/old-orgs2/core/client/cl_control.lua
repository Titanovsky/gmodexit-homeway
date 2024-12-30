local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local w = ScrW()
local h = ScrH()
local COLOR_PANEL = rgb( 0, 0, 0, 150 )

local function calcAllPlayersOrg( id )
    local max_players = 0
    for k, v in pairs( player.GetAll() ) do
        if tonumber( v:GetNWInt('amb_players_orgs_id') ) == id then max_players = max_players + 1 end
    end
    
    return max_players
end

local function collectStr( ... )
    local args = { ... }
    local str = args[1]..';'..args[2]..';'..args[3]..';'..args[4]

    return str
end

local function ranksMenuOpen( member )
    local id = tonumber( member:GetNWInt( 'amb_players_orgs_id' ) )

    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( 320, 240 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( true )
    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 4, 4, w-8, h-8, C.AMBI_BLACK ) 

        draw.SimpleText( member:Nick(), UI.SafeFont('22 Ambi'), w/2, 36, C.AMBI_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( member:GetNWString('amb_players_orgs_rank'), UI.SafeFont('18 Ambi'), w/2, 54, C.AMBI_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    for k, rank in pairs( AmbOrgs2.Orgs[id].Ranks ) do

        if k == 1 then continue end

        local btn = vgui.Create( 'DButton', frame )
        surface.SetFont(UI.SafeFont('22 Ambi'))
        btn:SetSize( surface.GetTextSize(rank) + 12, 32 )
        btn:SetPos( frame:GetWide()/2 - btn:GetWide()/2, 82 * k / 1.8 )
        btn:SetFont( UI.SafeFont('22 Ambi') )
        btn:SetTextColor( C.AMBI_WHITE )
        btn:SetText( rank )
        btn.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
            draw.RoundedBox( 0, 2, 2, w-4, h-4, C.AMBI_BLACK ) 
        end
        btn.DoClick = function()
            net.Start( 'amb_orgs_control_set_rank' )
                net.WriteEntity( member )
                net.WriteString( rank )
            net.SendToServer()
        end
    end
end

function AmbOrgs2.controlMenuOpen()

    if LocalPlayer():GetNWBool( 'amb_players_orgs' ) == false then chat.AddText('Доступ запрещён!') return end

    local id = tonumber( LocalPlayer():GetNWInt( 'amb_players_orgs_id' ) )
    local warehouse = AmbOrgs2.Orgs[id].Warehouse
    local leader = AmbOrgs2.Orgs[id].LeaderName

    local ranks_org = {}

    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( 620, 500 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( tostring( id )..' | '..LocalPlayer():GetNWString( 'amb_players_orgs_name' ) )
    frame:ShowCloseButton( true )

    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 4, 4, w-8, h-8, C.AMBI_BLACK ) 

        draw.SimpleText('ПАНЕЛЬ УПРАВЛЕНИЯ', UI.SafeFont('22 Ambi'), w/2, 24, C.AMBI_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.SimpleText('Онлайн: '..calcAllPlayersOrg( id ), UI.SafeFont('22 Ambi'), 24, h-82, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText('Лидер: '..leader, UI.SafeFont('22 Ambi'), 24, h-52, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( warehouse..'$', UI.SafeFont('22 Ambi'), 92, h-22, C.AMBI_GREEN, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText('Склад:', UI.SafeFont('22 Ambi'), 24, h-24, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local panel_ranks = vgui.Create( 'DPanel', frame )
    panel_ranks:SetSize( 260, 180 )
    panel_ranks:SetPos( frame:GetWide() - panel_ranks:GetWide() - 24, 48 )
    panel_ranks.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 2, 2, w-4, h-4, C.AMBI_BLACK ) 
    end

    for k, rank in pairs( AmbOrgs2.Orgs[id].Ranks ) do
        local te_rank = vgui.Create( 'DTextEntry', panel_ranks )
        te_rank:SetSize( 164, 32 )
        te_rank:SetPos( 8, -32 + 8 + 38 * k )
        te_rank:SetFont( UI.SafeFont('22 Ambi') )
        te_rank:SetValue( rank )
        ranks_org[k] = te_rank:GetValue()
        te_rank.OnChange = function( self )
            ranks_org[k] = self:GetValue()
        end
    end

    local send_ranks = vgui.Create( 'DButton', panel_ranks )
    send_ranks:SetSize( 64, 32 )
    send_ranks:SetPos( panel_ranks:GetWide() - send_ranks:GetWide() - 12, panel_ranks:GetTall()/2 - send_ranks:GetTall()/2)
    send_ranks:SetFont( UI.SafeFont('18 Ambi') )
    send_ranks:SetTextColor( C.AMBI_WHITE )
    send_ranks:SetText( 'send' )
    send_ranks.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 2, 2, w-4, h-4, C.AMBI_BLACK ) 
    end
    send_ranks.DoClick = function()

        if LocalPlayer():GetNWString('amb_players_orgs_rank') ~= AmbOrgs2.Orgs[id].Ranks[1] then frame:Remove() return end

        local r = collectStr( ranks_org[1],ranks_org[2],ranks_org[3],ranks_org[4] )
        if utf8.len( r ) > 100 then
            chat.AddText( 'Превышен лимит символов' )
            return
        else
            -- chat.AddText( collectStr( ranks_org[1],ranks_org[2],ranks_org[3],ranks_org[4] ) ) -- debug
            chat.AddText( 'Вы поменяли ранги!' )
            net.Start( 'amb_orgs_control_ranks' )
                net.WriteString( r )
                net.WriteUInt( id, 14 )
            net.SendToServer()
        end
    end

    local wrap_panel = vgui.Create( 'DPanel', frame )
    wrap_panel:SetSize( 300, 320 )
    wrap_panel:SetPos( 24, 48 )
    wrap_panel.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
    end

    local panel_members = vgui.Create( 'DScrollPanel', wrap_panel )
    panel_members:SetSize( wrap_panel:GetWide()-4, wrap_panel:GetTall()-4 )
    panel_members:SetPos( 2, 2 )
    panel_members.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_BLACK ) 
    end


    for _, v in ipairs( player.GetAll() ) do
        if ( tonumber( v:GetNWInt('amb_players_orgs_id') ) ~= id ) or v == LocalPlayer() then continue end

        local member = panel_members:Add( 'DPanel' )
        member:Dock( TOP )
        member:SetSize( panel_members:GetWide(), 64 )
	    member:DockMargin( 4, 4, 4, 4 )
        member.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, COLOR_PANEL ) 

            draw.SimpleText( v:Nick(), UI.SafeFont('18 Ambi'), 8, 12, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( v:GetNWString('amb_players_orgs_rank'), UI.SafeFont('18 Ambi'), 8, 32, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local uninvite = vgui.Create( 'DButton', member )
        timer.Simple( 0, function() uninvite:SetPos( member:GetWide() - uninvite:GetWide() - 4, member:GetTall() - uninvite:GetTall() - 4 ) end ) -- workaround
        uninvite:SetFont( UI.SafeFont('18 Ambi') )
        uninvite:SetTextColor( C.AMBI_RED )
        uninvite:SetText( 'uninvite' )
        uninvite.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, COLOR_PANEL )
        end
        uninvite.DoClick = function()
            chat.AddText('Вы выгнали игрока: '..v:Nick() )
            net.Start( 'amb_orgs_control_uninvite' )
                net.WriteUInt( v:EntIndex(), 8 )
            net.SendToServer()
        end

        local rank = vgui.Create( 'DButton', member )
        timer.Simple( 0, function() rank:SetPos( member:GetWide() - rank:GetWide() - 4, member:GetTall() - rank:GetTall() - 28 ) end ) -- workaround
        rank:SetFont( UI.SafeFont('18 Ambi') )
        rank:SetTextColor( AMB_COLOR_AMBITION )
        rank:SetText( 'rank' )
        rank.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, COLOR_PANEL )
        end
        rank.DoClick = function()
            ranksMenuOpen( v )
            frame:Remove()
        end
    end

    local wrap_panel1 = vgui.Create( 'DPanel', frame )
    wrap_panel1:SetSize( 260, 132 )
    wrap_panel1:SetPos( frame:GetWide() - wrap_panel1:GetWide() - 24, 48 + panel_ranks:GetTall() + 8 )
    wrap_panel1.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
    end

    local panel_potencial_ply = vgui.Create( 'DScrollPanel', wrap_panel1 )
    panel_potencial_ply:SetSize( wrap_panel1:GetWide()-4, wrap_panel1:GetTall()-4 )
    panel_potencial_ply:SetPos( 2, 2 )
    panel_potencial_ply.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_BLACK ) 
    end

    for k, v in ipairs( player.GetAll() ) do
        if v:GetNWBool('amb_players_orgs') or v == LocalPlayer() then continue end


        local ply = panel_potencial_ply:Add( 'DPanel' )
        ply:Dock( TOP )
        ply:SetSize( wrap_panel1:GetWide()-4, 52 )
	    ply:DockMargin( 2, 2, 2, 2 )
        ply.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, COLOR_PANEL ) 

            draw.SimpleText( v:Nick(), UI.SafeFont('22 Ambi'), 8, 12, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local invite = vgui.Create( 'DButton', ply )
        invite:SetPos( ply:GetWide() - invite:GetWide() - 4, ply:GetTall() - invite:GetTall() - 4 )
        timer.Simple( 0, function() invite:SetPos( ply:GetWide() - invite:GetWide() - 4, ply:GetTall() - invite:GetTall() - 4 ) end ) -- workaround
        invite:SetFont( UI.SafeFont('18 Ambi') )
        invite:SetTextColor( C.AMBI_WHITE )
        invite:SetText( 'invite' )
        invite.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, COLOR_PANEL )
        end
        invite.DoClick = function()
            net.Start('amb_invite_org_cmd')
                net.WriteEntity( v )
            net.SendToServer()
        end
    end

    local combo = vgui.Create( "DComboBox", frame )
    combo:SetSize( 100, 20 )
    combo:SetPos( frame:GetWide() - wrap_panel1:GetWide() - 24, 48 + panel_ranks:GetTall() + 8 + wrap_panel1:GetTall() + 8  )
    combo:AddChoice( "Зам. Ничего не может" )
    combo:AddChoice( "Зам. Может приглашать" )
    combo:AddChoice( "Зам. Может приглашать и увольнять" )
    if tonumber( AmbOrgs2.Orgs[id].OrgFlag ) > 0 then
        combo:SetValue( combo:GetOptionText( tonumber( AmbOrgs2.Orgs[id].OrgFlag ) ) )
    else
        combo:SetValue( "Flag" )
    end
    combo:SetSortItems( false )
    combo.OnSelect = function( self, index, value )
        if LocalPlayer():GetNWString('amb_players_orgs_rank') ~= AmbOrgs2.Orgs[id].Ranks[1] then frame:Remove() return end

        net.Start('amb_orgs_control_flags')
            net.WriteUInt( tonumber( index ), 3)
        net.SendToServer()
    end
end
concommand.Add( "ambi_org2_menu", AmbOrgs2.controlMenuOpen )

-- PrintTable( AmbOrgs2.Orgs ) -- debug
