local hud = {}

function hud:create()
	hud.ctr = display.newText(game.ctr, display.contentCenterX, 50, "media/Bungee-Regular.ttf", 32)
	hud.ctr:setFillColor(1,1,1)
	hud.ctr.id = "ctr"
	hud.ctr.zero = false

	hud.score = display.newText("Score: " .. game.score, display.contentCenterX / 4, display.contentHeight - 35, "media/Bungee-Regular.ttf", 18)
	hud.score.anchorX = 0
	hud.score.id = "score"

	Runtime:addEventListener("enterFrame", hud)
	hud.score:addEventListener("tap", hud)
end

function hud:remove()
	hud.ctr:removeSelf()
	hud.score:removeSelf()

	hud.ctr = nil
	hud.score = nil

	Runtime:removeEventListener("enterFrame", hud)
end

function hud:enterFrame()
	hud.ctr.text = game.ctr
	hud.score.text = "Score: " .. game.score
end

function hud:tap(event)
	composer.gotoScene("scenes.scene_menu")
end

return hud