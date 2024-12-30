net.AddString( 'ambi_homeway_use_casino', function( _, ePly ) 
    if ePly.dont_use_casino then return end

    local is_red = net.ReadBool()
    local money = net.ReadUInt( 15 )
    if ( money > 25000 ) then return end
    if ( money <= 0 ) then return end
    if ( ePly:GetMoney() < money ) then return end

    local casino = net.ReadEntity()
    if not IsValid( casino ) then return end
    --todo distance check
    --todo check class

    ePly:AddMoney( -money )
    ePly.dont_use_casino = true

    casino:EmitSound( 'ambi/money/send1.ogg' )

    timer.Simple( 3, function()
        if not IsValid( ePly ) then return end
        ePly.dont_use_casino = false

        local rand = math.random( 0, 100 )
        local random_is_red = tobool( rand >= 50 )

        local color = random_is_red and 'R' or 'B'
        local text = random_is_red and 'Красное' or 'Синее'

        if ( random_is_red == is_red ) then
            money = money * 2

            ePly:ChatSend( '~G~ • ~W~ Выпало ~'..color..'~ '..text..' ~W~ и выйграли: ~G~ '..money..'$' )
            ePly:AddMoney( money )

            casino:EmitSound( 'ambi/other/donationalerts.mp3' )
        else
            ePly:ChatSend( '~R~ • ~W~ Выпало ~'..color..'~ '..text..' ~W~ и проиграли!' )
        end

        hook.Call( '[Ambi.Homeway.UsedCasino]', nil, ePly )
    end )
end )