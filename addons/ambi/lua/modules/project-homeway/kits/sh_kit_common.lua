local Add = Ambi.Kit.Add
local MINUTE = 60
local HOUR = MINUTE * 60
local DAY = HOUR * 24

Add( 'money', '', false, HOUR * 4, function( ePly ) 
    ePly:AddInvItemOrDrop( 'chest_money', 2 )
    ePly:Notify( 'Сундук в вашем инвентаре', 8 )

    return true
end )