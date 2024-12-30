--[[
	Цены в .Add указываются в рублях
	pl:IGSFunds()*0.04 (проценты)
	pl:AddIGSFunds
]]

IGS.LVL.Add( 500, 'Хороший человек' )
	:SetBonus( function( ePly )
		ePly:SetHealth( 200 )
		ePly:SetArmor( 255 )
	end)
:SetDescription( '' )