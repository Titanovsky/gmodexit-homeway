local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()
local Add = Ambi.MultiHUD.Add

local COLOR_SMALL_BLACK = Color( 56, 56, 56 )
local DISTANCE = 120 ^ 2

local enable_show_button_e = CreateClientConVar( 'ambi_hw_show_button_e', '1', true )

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add( 3, 'Homeway HUD', 'Homeway', function()
    if Ambi.Homeway.HasF4Menu() then return end
    if IsValid( Ambi.Homeway.tab ) then return end
    if not LocalPlayer():IsAuth() then return end
    if LocalPlayer():IsJail() then return end
    if not LocalPlayer():Alive() then return end

    if timer.Exists( 'Ambi.Homeway.JobGod' ) then
        Draw.Box( W, 40, 0, 150, C.HOMEWAY_BLACK )

        local time = math.Round( timer.TimeLeft( 'Ambi.Homeway.JobGod' ) )

        Draw.SimpleText( W / 2, 155, 'Бессмертие:  '..time..' секунд', UI.SafeFont( '28 Montserrat' ), C.HOMEWAY_BLUE, 'top-center', 1, C.ABS_BLACK )
    end

    if timer.Exists( 'Ambi.Homeway.ShowPropsLimit' ) then
        local limit = LocalPlayer():GetPropsLimit()
        local props = LocalPlayer():GetCount( 'props' )
        local text = props..' / '..limit
        local ww = Draw.GetTextSizeX( UI.SafeFont( '32 Montserrat' ), text ) + 16
        Draw.Box( ww, 38, 8, H / 2 - 120, C.HOMEWAY_BLACK, 6 )
        Draw.SimpleText( 15, H / 2 - 120, text, UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
    end

    local hp, max = LocalPlayer():IsPlayingInComputerClub() and LocalPlayer():GetPseudoHealth() or LocalPlayer():Health(), LocalPlayer():IsPlayingInComputerClub() and 100 or LocalPlayer():GetMaxHealth()
    if ( hp <= 30 ) then
        local value = 0.8
        
        if ( hp <= 5 ) then 
            value = 0 
            DrawMotionBlur( 0.2, 0.8, 0.03 )
        elseif ( hp <= 10 ) then 
            value = 0.4 
            DrawMotionBlur( 0.4, 0.8, 0.01 )
        elseif ( hp <= 20 ) then 
            value = 0.6 
        end

        DrawColorModify{  
            [ "$pp_colour_addr" ] = 0,
            [ "$pp_colour_addg" ] = 0,
            [ "$pp_colour_addb" ] = 0,
            [ "$pp_colour_brightness" ] = 0,
            [ "$pp_colour_contrast" ] = 1,
            [ "$pp_colour_colour" ] = value,
            [ "$pp_colour_mulr" ] = 0,
            [ "$pp_colour_mulg" ] = 0,
            [ "$pp_colour_mulb" ] = 0
        }
    end

    if ( LocalPlayer():GetTime() < 10 * 60 ) then
        Draw.SimpleText( 4, H / 2 - 20 * 6, 'ПУ и ФБР берут оружия с завода', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 - 20 * 5, 'Мафия рейдит ФБР и ПУ', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 - 20 * 4, '/help', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 - 20 * 3, 'Промокоды в F4', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 - 20 * 2, 'Квест на спавне', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 - 20 * 1, 'F6 - Донат', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2, 'F7 - Третье Лицо', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
        Draw.SimpleText( 4, H / 2 + 20, 'Надписи пропадут после 10 минут игры', UI.SafeFont( '16 Montserrat' ), C.AMBI_GRAY, 'top-left', 1, C.ABS_BLACK )
    end

    if Ambi.DarkRP.IsLockdown() then
        Draw.SimpleText( 4, 0, 'Ком. Час. Причина: '..Ambi.DarkRP.GetLockdownReason(), UI.SafeFont( '40 Montserrat' ), C.RED, 'top-left', 1, C.ABS_BLACK )
    end 
    
    -- Health
    if ( hp < 0 ) then return end
    
    local color = ( hp <= 30 ) and ColorAlpha( C.FLAT_RED, 200 + math.sin( 360 + CurTime() * 20 ) * 160 ) or C.HOMEWAY_BLUE
    local w = ( hp > max ) and 142 or ( 142 / max ) * hp

    Draw.Material( 44, 44, 4, H - 44 - 4, CL.Material( 'hw_hud1_hp2' ) )
    Draw.Box( 150, 32, 50, H - 32 - 8, C.HOMEWAY_BLACK, 6 )
    Draw.Box( 150 - 8, 32 - 8, 50 + 4, H - 32 - 8 + 4, COLOR_SMALL_BLACK, 6 )
    Draw.Box( w, 32 - 8, 50 + 4, H - 32 - 8 + 4, color, 6 )

    Draw.SimpleText( 125, H - 10, ( hp > 9999 ) and '9999+' or hp, UI.SafeFont( '32 Montserrat' ), C.WHITE, 'bottom-center', 1, C.ABS_BLACK )

    local armor, max = LocalPlayer():IsPlayingInComputerClub() and LocalPlayer():GetPseudoArmor() or LocalPlayer():Armor(), LocalPlayer():IsPlayingInComputerClub() and 100 or LocalPlayer():GetMaxArmor() 
    if ( armor > 0 ) then
        w = ( armor > max ) and 142 or ( 142 / max ) * armor

        Draw.Material( 44, 44, 4, H - 44 - 4 - 50, CL.Material( 'hw_hud1_armor1' ) )
        Draw.Box( 150, 32, 50, H - 32 - 8 - 50, C.HOMEWAY_BLACK, 6 )
        Draw.Box( 150 - 8, 32 - 8, 50 + 4, H - 32 - 8 + 4 - 50, COLOR_SMALL_BLACK, 6 )
        Draw.Box( w, 32 - 8, 50 + 4, H - 32 - 8 + 4 - 50, C.HOMEWAY_BLUE, 6 )

        Draw.SimpleText( 125, H - 60, armor, UI.SafeFont( '32 Montserrat' ), C.WHITE, 'bottom-center', 1, C.ABS_BLACK )
    end

    -- Job
    local text = LocalPlayer():GetJobName()
    local w = Draw.GetTextSizeX( UI.SafeFont( '32 Montserrat' ), text ) + 16
    Draw.Material( 44, 44, 210, H - 44 - 4, CL.Material( 'hw_hud1_job' ) )
    Draw.Box( w, 32, 210 + 46, H - 32 - 8, C.HOMEWAY_BLACK, 6 )
    Draw.SimpleText( 264, H - 10, text, UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'bottom-left', 1, C.ABS_BLACK )

    if LocalPlayer():IsWanted() then
        Draw.SimpleText( 250, H - 48, 'Вы в розыске!', UI.SafeFont( '24 Montserrat' ), C.FLAT_RED, 'bottom-left', 1, C.ABS_BLACK )
    end

    -- Money
    local text = string.Comma( LocalPlayer():GetMoney() )..'$'
    local ww = Draw.GetTextSizeX( UI.SafeFont( '32 Montserrat' ), text ) + 16
    Draw.Material( 44, 44, 210 + 46 + w + 10, H - 44 - 4, CL.Material( 'hw_hud1_wallet' ) )
    Draw.Box( ww, 32, 210 + 46 + w + 10 + 46, H - 32 - 8, C.HOMEWAY_BLACK, 6 )
    Draw.SimpleText( 264 + w + 56, H - 10, text, UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'bottom-left', 1, C.ABS_BLACK )

    local job_life = LocalPlayer():GetJobLife()
    if ( job_life > 0 ) then
        local www = Draw.GetTextSizeX( UI.SafeFont( '32 Montserrat' ), job_life ) + 16
        Draw.Box( www, 32, 210 + 46 + w + 10 + ww + 50, H - 32 - 8, C.HOMEWAY_BLACK, 6 )
        Draw.SimpleText( 264 + w + 56 + ww + 2, H - 10, job_life, UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'bottom-left', 1, C.ABS_BLACK )
    end

    if LocalPlayer():HasOrg() then
        Draw.SimpleText( W / 2, H - 4, AmbOrgs2.Orgs[ LocalPlayer():GetOrgID() ].Name, UI.SafeFont( '26 Montserrat' ), C.HOMEWAY_BLUE, 'bottom-center', 1, C.ABS_BLACK )
    end

    -- Ammunition --
    local wep = LocalPlayer():GetActiveWeapon()
    if IsValid( wep ) and not Ambi.Homeway.Config.hud_block_weapons[ wep:GetClass() ] then 
        local clip1, ammo1, ammo2 = wep:Clip1(), LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ), LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType() )
        if ( ammo1 == 0 and clip1 == 0 ) then return end

        local ammo = clip1..'  '..ammo1
        if ammo2 and ( ammo2 > 0 ) then 
            ammo = '('..ammo2..') '..clip1..'  '..ammo1
        end

        local color = C.HOMEWAY_BLUE
        local x = Draw.GetTextSizeX( UI.SafeFont( '44 Montserrat' ), ammo ) + 16

        Draw.Box( x, 45, W - x - 10, H - 45 - 8, C.HOMEWAY_BLACK, 6 )
        Draw.SimpleText( W - 16, H - 8, ammo, UI.SafeFont( '44 Montserrat' ), color, 'bottom-right' )
        Draw.Material( 44, 44, W - 44 - x - 14, H - 44 - 8, CL.Material( 'hw_hud1_ammo' ) )
    end

    -- Button Use
    if not enable_show_button_e:GetBool() then return end
    
    local obj = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( obj ) then return end
    if ( LocalPlayer():GetPos():DistToSqr( obj:GetPos() ) > DISTANCE ) then return end

    local desc = Ambi.Homeway.Config.show_use_button[ obj:GetClass() ]
    if not desc then return end

    Draw.SimpleText( W / 2, H / 2 + 64, 'Нажми [E]', UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
    Draw.SimpleText( W / 2, H / 2 + 64 + 32, desc, UI.SafeFont( '24 Montserrat Light' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
end )

net.Receive( 'ambi_homeway_show_prop_limit', function() 
    timer.Create( 'Ambi.Homeway.ShowPropsLimit', 2.25, 1, function() end )
end )

net.Receive( 'ambi_homeway_job_god_start', function() 
    timer.Create( 'Ambi.Homeway.JobGod', net.ReadUInt( 15 ), 1, function() end )
end )

net.Receive( 'ambi_homeway_job_god_remove', function() 
    timer.Remove( 'Ambi.Homeway.JobGod' )
end )