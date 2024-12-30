Ambi.Discord.Bot = Ambi.Discord.Bot or {}
Ambi.Discord.Bot.bots = Ambi.Discord.Bot.bots or {}

-- LOCALS -------------------------------------------------------------------------------------
local Gen, C = Ambi.Packages.Out( 'Gen, C' )

-- CLASS [METHODS AND PROPERTIES ] -------------------------------------------------------------------------------------
local BOT_CLASS = {}

function Ambi.Discord.Bot.Create( sToken )
    if not sToken or not isstring( sToken ) then Gen.Error( 'Discord.Bot', 'Cannot to Create a bot, sToken == nil' ) return end
    if not Ambi.HTTP.CHTTP.IsConnected() then Gen.Error( 'Discord.Bot', 'Cannot to Create a bot, because CHTTP is not connected!' ) return end

    local bot = BOT_CLASS
    bot.token = sToken

    print( '[Discord] Created Bot!' )

    return bot
end

-- Send/Set/Give
BOT_CLASS.SendMessage = function( self, sChannelID, sText, nTime, bDontEmbeded )
    if not Ambi.HTTP.CHTTP.IsConnected() then Gen.Error( 'Discord.Bot', 'Cannot to SendMessage, because CHTTP is not connected!' ) return end
    if not self.token then Gen.Error( 'Discord.Bot', 'self.token is not valid!' ) return end

    local headers = {}
    headers.content = sText or ''
    if bDontEmbeded then headers.flags = 4 end

    timer.Simple( nTime or 0, function() 
        Ambi.HTTP.CHTTP.Post( 'https://discord.com/api/channels/'..sChannelID..'/messages', nil, nil, util.TableToJSON( headers ), 'application/json', { [ 'Authorization' ] = 'Bot '..self.token, [ 'Content-Type' ] = 'application/json' } ) 
    end )

    return self
end

BOT_CLASS.EditMessage = function( self, sChannelID, sMessageID, sText, nTime, bDontEmbeded )
    if not Ambi.HTTP.CHTTP.IsConnected() then Gen.Error( 'Discord.Bot', 'Cannot to SendMessage, because CHTTP is not connected!' ) return end
    if not self.token then Gen.Error( 'Discord.Bot', 'self.token is not valid!' ) return end
    --if not sMessageID then return end

    local body = {}
    body.content = sText or ''
    if bDontEmbeded then body.flags = 4 end

    timer.Simple( nTime or 0, function() 
        CHTTP( {
            url = 'https://discord.com/api/channels/'..sChannelID..'/messages/'..sMessageID,
            method = 'PATCH',
            type = 'application/json',
            body = util.TableToJSON( body ),
            headers = { 
                [ 'Authorization' ] = 'Bot '..self.token, 
                [ 'Content-Type' ] = 'application/json' 
            }
        } )
    end )

    return self
end

-- Receive
BOT_CLASS.ReceiveMessages = function( self, sChannelID, nLimit, fCallback, nTime )
    if not Ambi.HTTP.CHTTP.IsConnected() then Gen.Error( 'Discord.Bot', 'Cannot to ReceiveMessages, because CHTTP is not connected!' ) return end
    if not self.token then Gen.Error( 'Discord.Bot', 'self.token is not valid!' ) return end

    nLimit = nLimit or 1 

    timer.Simple( nTime or 0, function()
        Ambi.HTTP.CHTTP.Get( 'https://discord.com/api/channels/'..sChannelID..'/messages?limit='..nLimit, 
            function( nCode, sBody, tHeaders )
                if not sBody then return end
                
                if fCallback then fCallback( util.JSONToTable( sBody ) ) end
            end,

            function( sReason ) 
                print( 'ERROR CHTTP: '..sReason )
            end,

            {
                [ 'Authorization' ] = 'Bot '..self.token,
                [ 'Content-Type' ] = 'application/json'
            }
        )
    end )

    return self
end

BOT_CLASS.ReceiveUsers = function( self, sGuildID, nLimit, fCallback, nTime )
    if not Ambi.HTTP.CHTTP.IsConnected() then Gen.Error( 'Discord.Bot', 'Cannot to ReceiveUsers, because CHTTP is not connected!' ) return end
    if not self.token then Gen.Error( 'Discord.Bot', 'self.token is not valid!' ) return end
    
    nLimit = nLimit or 1000

    timer.Simple( nTime or 0, function()
        Ambi.HTTP.CHTTP.Get( 'https://discord.com/api/guilds/'..sGuildID..'/members?limit='..nLimit, 
            function( nCode, sBody, tHeaders )
                if not sBody then return end
                
                if fCallback then fCallback( util.JSONToTable( sBody ) ) end
            end,

            function( sReason ) 
                print( 'ERROR CHTTP: '..sReason )
            end,

            {
                [ 'Authorization' ] = 'Bot '..self.token,
                [ 'Content-Type' ] = 'application/json'
            }
        )
    end )

    return self
end

-- Show
BOT_CLASS.ShowMessages = function( self, sChannelID, nLimit, nTime )
    self:ReceiveMessages( sChannelID, nLimit, function( tBody )
        PrintTable( tBody )
    end, nTime )
end

BOT_CLASS.ShowUsers = function( self, sGuildID, nLimit, nTime )
    self:ReceiveUsers( sChannelID, nLimit, function( tBody )
        PrintTable( tBody )
    end, nTime )
end