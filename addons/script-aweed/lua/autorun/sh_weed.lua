

SMOKEPUFFS_TABLE = {}
local nSmoke = 0

hook.Add("Think","SmokePuffs",function()
    if(#SMOKEPUFFS_TABLE > 0 && nSmoke < CurTime()) then
        nSmoke = CurTime()+1
        for k,v in pairs(SMOKEPUFFS_TABLE) do
            if(v[2] > 0) then
                v[2] = v[2] - 1
                if(v[2] <= 0) then
                    table.RemoveByValue(SMOKEPUFFS_TABLE,v)
                end
            end
        end
    end
end)
