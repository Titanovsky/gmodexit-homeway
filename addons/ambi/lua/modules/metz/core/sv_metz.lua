function Ambi.Metz.MetzUse( self, ePly )
    local amount = self:GetAmount()

    ePly.metz = ePly.metz or 0
    ePly.metz = ePly.metz + amount

    ePly:ChatPrint( 'Вы подобрали метз ('..ePly.metz..')' )

    self:Remove()
end