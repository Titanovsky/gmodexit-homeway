--todo refactore
local x_main, y_main = 240, 240
local COLOR_APLHA = Color(0,0,0,0)
local chat_x, chat_y = chat.GetChatBoxPos()

net.Receive( 'ambi_image_send_all', function()
	local url = net.ReadString()

	local img = vgui.Create( 'DHTML' )
	img:SetSize( x_main, y_main )
	img:SetPos( chat_x, chat_y - 320 )
	img:SetHTML( "<body style='overflow: hidden;'> <img src="..url.." style='   width: " .. x_main .. " ;  max-height:".. y_main ..";'> </body>" )

	timer.Simple( 8, function() 
		if ValidPanel( img ) then img:Remove() end
	end )
end )