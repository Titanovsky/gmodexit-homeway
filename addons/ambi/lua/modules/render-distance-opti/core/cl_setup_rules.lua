function Ambi.RenderDistanceOpti.Setup( eObj )
    function eObj:RenderOverride()
        if not Ambi.RenderDistanceOpti.Config.enable then self:DrawModel() return end

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) < Ambi.RenderDistanceOpti.Config.max_distance * Ambi.RenderDistanceOpti.Config.max_distance ) then self:DrawModel() end
    end
end