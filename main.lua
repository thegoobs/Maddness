--[[
Nuffins
Idea by Bri Tamasi, Eli Schoolar, and Guthrie Schoolar
Developed by Guthrie Schoolar
]]--

--Headers
composer = require("composer")
json = require("json")

bomb = require("modules.powerups.bomb")
vertical = require("modules.powerups.vertical")
horizontal = require("modules.powerups.horizontal")
clean = require("modules.powerups.clean")
evenOdd = require("modules.powerups.evenodd")
zero = require("modules.powerups.zero")
addtime = require("modules.powerups.addtime")

grid = require("modules.grid")
tile = require("modules.tile")
game = require("modules.game")
hud = require("modules.hud")
touch = require("modules.touch")
combination = require("modules.combination")
widget = require("widget")
file = require("modules.file")
nanosvg = require( "plugin.nanosvg" )
sound = require("modules.sound")

reward = require("modules.reward")

revmob = require("plugin.revmob")
revmob.id = "59a18e03986e9e3c25adcf69"
revmob.banner = "59a19086986e9e3c25adcf79"
revmob.int = "59a1957a2fdd190df62523bc"
--initialize RevMob ad service

local function adListener( event )
  
    if ( event.phase == "sessionStarted" ) then  -- Successful initialization
        -- Load a RevMob ad
        revmob.load("banner", revmob.banner)
        revmob.load("interstitial", revmob.int)
 
    elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
        print( event.type )
 
    elseif ( event.phase == "failed" ) then  -- The ad failed to load
        print( event.type )
        print( event.isError )
        print( event.response )
    elseif (event.phase == "hidden") then
    	if event.type == "banner" then
	    	revmob.load(event.type, revmob.banner)
	    elseif event.type == "interstitial" then
	    	revmob.load(event.type, revmob.int)
	    end
    end
end
 
-- Initialize RevMob
revmob.init( adListener, { appId=revmob.id } )

--setup system check whether or not game becomes suspended or not
Runtime:addEventListener("system", game)

--set up random seed
math.randomseed(os.time())

--initalize sounds
sound:init()

display.setDefault("minTextureFilter", "nearest");
--go to main menu
composer.gotoScene("scenes.scene_menu")