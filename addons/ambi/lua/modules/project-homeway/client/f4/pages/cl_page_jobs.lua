local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageJobs( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
    end )

    local jobs = GUI.DrawScrollPanel( panel, panel:GetWide() / 3, main:GetTall() - 32, 0, 32, function( self, w, h )
    end )

    local title_count_jobs = GUI.DrawPanel( panel, panel:GetWide() / 3, 32, 0, 0, function( self, w, h )
        Draw.SimpleText( w / 2, h / 2, 'Всего работ: '..#team.GetAllTeams(), UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'center', 1, C.ABS_BLACK )
    end )

    local job_info = GUI.DrawScrollPanel( panel, panel:GetWide() - jobs:GetWide(), main:GetTall(), jobs:GetWide(), 0, function( self, w, h )
        -- Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 ) -- debug

        Draw.SimpleText( 8, 4, self.header, UI.SafeFont( '38 Montserrat SemiBold' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
        --Draw.Text( 8, 64, self.desc, '22 Ambi', C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
    end )
    job_info.header = ''
    job_info.desc = ''

    local i = -1
    for class, job in SortedPairsByMemberValue( Ambi.DarkRP.GetJobs(), 'category' ) do
        if not job then continue end
        if ( job.can_join_command == false ) then continue end
        if not Ambi.DarkRP.Config.f4menu_show_restrict_items_and_jobs then
            -- local class = job.from 
            -- if class then
            --     if isstring( class ) then
            --         if ( LocalPlayer():Job() != class ) then continue end
            --     elseif isnumber( class ) then
            --         if ( LocalPlayer():Team() != class ) then continue end
            --     end
            -- end
        end

        i = i + 1

        local count_workers = #team.GetPlayers( job.index )

        local job_panel = GUI.DrawButton( jobs, jobs:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
            job_info:Clear()

            job_info.header = job.name
            job_info.desc = job.description

            if ( LocalPlayer():Job() ~= class ) then
                local join = GUI.DrawButton( job_info, 140, 52, 8, job_info:GetTall() - 52 - 4, nil, nil, nil, function()
                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                    if ( LocalPlayer():Job() == class ) then chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'Нельзя поменять работу на свою же работу!' ) return Ambi.Homeway.RemoveF4Menu() end
                    
                    if ( #job.models == 1 ) then
                        if timer.Exists( 'BlockF4MenuSetJob' ) then return end
                        timer.Create( 'BlockF4MenuSetJob', 1.25, 1, function() end )

                        Ambi.Homeway.RemoveF4Menu()

                        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                        net.Start( 'ambi_homeway_f4menu_set_job' )
                            net.WriteString( class )
                            net.WriteUInt( 1, 10 )
                        net.SendToServer()
                    else
                        job_info:Clear()
                        job_info.header = ''
                        job_info.desc = ''

                        local i = -1
                        for index, model in ipairs( job.models ) do
                            local name = string.Explode( '/', model )
                            name = name[ #name ]

                            name = string.Explode( '.', name )
                            name = name[ 1 ]

                            i = i + 1
                            local job_model = GUI.DrawButton( job_info, job_info:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
                                if timer.Exists( 'BlockF4MenuSetJob' ) then return end
                                timer.Create( 'BlockF4MenuSetJob', 1.25, 1, function() end )

                                Ambi.Homeway.RemoveF4Menu()

                                LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                                net.Start( 'ambi_homeway_f4menu_set_job' )
                                    net.WriteString( class )
                                    net.WriteUInt( index, 10 )
                                net.SendToServer()

                            end, function( self, w, h ) 
                                --Draw.Box( w, h, 0, 0, self.col )
                                Draw.SimpleText( 68, h / 2, name, UI.SafeFont( '24 Montserrat' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
                            end )
                            job_model.col = C.AMBI_WHITE

                            GUI.OnCursor( job_model, function()
                                job_model.col = ColorAlpha( C.ABS_BLACK, 100 )

                                LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
                            end, function() 
                                job_model.col = C.AMBI_WHITE
                            end )

                            GUI.DrawModel( job_model, 64, 64, 0, 0, model )
                        end
                    end
                end, function( self, w, h ) 
                    Draw.Box( w, h, 0, 0, self.col )
                    Draw.SimpleText( w / 2, h / 2, 'ВСТУПИТЬ', UI.SafeFont( '32 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
                end )
                join.col = COLOR_PANEL
            end

            local avatar = GUI.DrawModel3D( job_info, job_info:GetWide(), job_info:GetTall(), 84, -40, job.models[ 1 ] )

            local job_desc = GUI.DrawScrollPanel( job_info, 330, job_info:GetTall() - 160, 6, 46, function( self, w, h )
                --Draw.Box( w, h, 0, 0, COLOR_PANEL ) -- debug

                --Draw.Text( 4, 4, job.description, UI.SafeFont( '18 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
            end )
            job_desc:SetTooltip( job.description )

            local text = vgui.Create( 'RichText', job_desc )
            text:SetPos( 0, 0 )
            text:SetSize( job_desc:GetWide(), job_desc:GetTall() )
            text:AppendText( job.description )
            text.PerformLayout = function( self )
                self:SetFontInternal( UI.SafeFont( '26 Montserrat' ) )
                self:SetFGColor( C.ABS_WHITE )
            end
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, self.col ) -- debug

            Draw.SimpleText( 68, 4, job.name, UI.SafeFont( '26 Montserrat' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
            if job.money then Draw.SimpleText( 68, 32, job.money..'$', UI.SafeFont( '22 Montserrat' ), LocalPlayer():GetMoney() >= job.money and C.AMBI_GREEN or C.AMBI_RED, 'top-left', 1, C.ABS_BLACK ) end
            if job.level then Draw.SimpleText( 68, 32, job.level..' LVL', UI.SafeFont( '22 Montserrat' ), LocalPlayer():GetLevel() >= job.level and C.AMBI_GREEN or C.AMBI_RED, 'top-left', 1, C.ABS_BLACK ) end
            Draw.Box( w, 4, 0, h - 4, C.AMBI_RED )

            if job.max and ( job.max >= 1 ) then 
                Draw.SimpleText( w - 18, h - 8, count_workers..' / '..job.max, UI.SafeFont( '22 Montserrat' ), count_workers >= job.max and C.AMBI_RED or C.ABS_WHITE, 'bottom-right' ) 
            end
        end )
        job_panel.col = C.AMBI_WHITE
        --job_panel:SetTooltip( job.description )

        GUI.OnCursor( job_panel, function()
            job_panel.col = ColorAlpha( job.color, 100 )

            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
        end, function() 
            job_panel.col = C.AMBI_WHITE
        end )
        
        GUI.DrawModel( job_panel, 64, 64, 0, 0, job.models[ 1 ] )

        local line = GUI.DrawPanel( job_panel, job_panel:GetWide(), 8, 0, job_panel:GetTall() - 8, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, job.color )
        end )
    end
end