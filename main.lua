--[[
Zero Game
Idea by Bri Tamasi, Eli Schoolar, and Guthrie Schoolar
Developed by Guthrie Schoolar
Music and sounds by Eli Schoolar
Design by Bri Tamasi, Curtis Kimberlin
]]--

--Headers
composer = require("composer")

bomb = require("modules.powerups.bomb")
vertical = require("modules.powerups.vertical")
horizontal = require("modules.powerups.horizontal")
clean = require("modules.powerups.clean")
evenOdd = require("modules.powerups.evenodd")
zero = require("modules.powerups.zero")

grid = require("modules.grid")
tile = require("modules.tile")
game = require("modules.game")
hud = require("modules.hud")
touch = require("modules.touch")
combination = require("modules.combination")
widget = require("widget")

reward = require("modules.reward")

--setup system check whether or not game becomes suspended or not
Runtime:addEventListener("system", game)

--go to main menu
composer.gotoScene("scenes.scene_menu")