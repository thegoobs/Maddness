local hud = {}

function hud:create()
	hud.ctr = display.newText(game.ctr, display.contentCenterX, 50, "media/Bungee-Regular.ttf", 32)
	hud.ctr:setFillColor(1,1,0)

	hud.score = display.newText("Score: " .. game.score, display.contentCenterX / 4, display.contentHeight - 35, "media/Bungee-Regular.ttf", 18)
	hud.score.anchorX = 0

	Runtime:addEventListener("enterFrame", hud)
end

function hud:enterFrame()
	hud.ctr.text = game.ctr
	hud.score.text = "Score: " .. game.score
end

return hud