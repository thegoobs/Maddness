--[[
Zero Game
Idea by Bri Tamasi, Eli Schoolar, and Guthrie Schoolar
Developed by Guthrie Schoolar
Music and sounds by Eli Schoolar
Design by Bri Tamasi, Curtis Kimberlin
]]--

--Headers
composer = require("composer")
grid = require("modules.grid")
tile = require("modules.tile")
game = require("modules.game")
hud = require("modules.hud")
touch = require("modules.touch")
combination = require("modules.combination")
widget = require("widget")
bomb = require("modules.powerups.bomb")
vertical = require("modules.powerups.vertical")
horizontal = require("modules.powerups.horizontal")
reward = require("modules.reward")

debug = 0
--all main does is go to the first scene
composer.gotoScene("scenes.scene_menu")