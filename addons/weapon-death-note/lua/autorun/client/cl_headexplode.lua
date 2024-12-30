

net.Receive( "deathnote_dm_headexplodec", function( len, pl ) -- This file is just for the Client rescaleing of the head for the head explode death (IF more Client sided code for deathtypes it mostly likely going in this file and the file will be renamed)
	local ply = net.ReadEntity()
	local target = net.ReadEntity()
	HeadExplodeClient(ply,target)
end )

function  HeadExplodeClient(ply,target)
	if SERVER then return end
	HeadBone = target:LookupBone("ValveBiped.Bip01_Head1") 
	if HeadBone == nil then -- Do nothing if no bone was found
		return
	end
	local HeadSize = 1
	-- Count = 0 -- Here to work out how long i need to set kill time 4 server(time*count+0.1)
	timer.Create( "HeadGrow", 0.025, 0, function()
		-- Count = Count + 1 -- Here to work out how long i need to set kill time 4 server(time*count+0.1)
		-- print("Count: "..Count) -- Here to work out how long i need to set kill time  4 server(time*count+0.1)
		if target:IsPlayer() then
			if not target:Alive() then
				HeadExplodeClientEnd(ply,target,false)
				return
			end
		end
		if not IsValid(target) then
			HeadExplodeClientEnd(ply,target,false)
			return
		end
		HeadSize = HeadSize + 0.05
		-- print(HeadSize)
		target:ManipulateBoneScale( HeadBone, Vector(HeadSize,HeadSize,HeadSize))
		if HeadSize >= 1.94 and not target:IsPlayer() then
			-- print("NPC Dead Head Fix")
			target:ManipulateBoneScale( HeadBone, Vector(0,0,0))
			timer.Remove("HeadGrow")
			return
		end
		if HeadSize >= 2 then
			-- print("Size is at 2 or over")
			timer.Remove("HeadGrow")
			timer.Simple( 2, function() HeadExplodeClientEnd(ply,target,true) end )
			timer.Simple( 0.11, function() 
				local Ragdoll = target:GetRagdollEntity()
				-- print("----------AFTER------")
				-- print(Ragdoll)
				-- print("----------BEFORE-----")
				if IsValid( Ragdoll ) then
					Ragdoll:ManipulateBoneScale( HeadBone, Vector(0,0,0))
				end
			end )
		end
	end)

end

function HeadExplodeClientEnd(ply,target,fastend)
	if IsValid(target) then
		target:ManipulateBoneScale( HeadBone, Vector(1,1,1))
		if fastend then return end
	end
	timer.Remove("HeadGrow")
end