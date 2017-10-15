--[[
Addness
Idea by Bri Tamasi, Eli Schoolar, and Guthrie Schoolar
Developed by Guthrie Schoolar
]]--

--UI modules
widget = require("widget")
sound = require("modules.sound")
theme = require("modules.theme")
reward = require("modules.reward")

--game controller modules
game = require("modules.game")
file = require("modules.file")
hud = require("modules.hud")
touch = require("modules.touch")
composer = require("composer")
json = require("json")


--grid modules
grid = require("modules.grid")
tile = require("modules.tile")
combination = require("modules.combination")
bomb = require("modules.powerups.bomb")
vertical = require("modules.powerups.vertical")
horizontal = require("modules.powerups.horizontal")
clean = require("modules.powerups.clean")
evenOdd = require("modules.powerups.evenodd")
zero = require("modules.powerups.zero")
addtime = require("modules.powerups.addtime")

--adverstisements module
appodeal = require( "plugin.appodeal" )

--initialize appodeal ad service

local function adListener( event )

    -- Exit function if user hasn't set up testing parameters
    if ( setupComplete == false ) then return end

    if ( event.phase == "loaded" ) then  -- The ad was successfully loaded
        print( event.type)
    elseif ( event.phase == "failed" ) then  -- The ad failed to load
        print( event.type)
        print( event.isError )
        print( event.response )
    end

    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.isError )
    end
end
 
-- Initialize appodeal
if system.getInfo("platform") == "ios" then
    appodeal.id = "a961908b210dcf1378a57291c32149b823cc4b2e88ca53d4"
else
    appodeal.id = "fb751c6a5903872881dc5bfbd64d956b01b59495e0c61b58"
end

appodeal.init( adListener, { appKey=appodeal.id } )

--setup system check whether or not game becomes suspended or not
Runtime:addEventListener("system", game)

--set up random seed
math.randomseed(os.time())

--initalize sounds
sound:init()

--Graphical enhancement (I think?)
display.setDefault("minTextureFilter", "nearest");

--go to main menu
firstLoad = true
composer.gotoScene("scenes.scene_menu")