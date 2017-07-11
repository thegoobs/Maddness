local hud = {}
hud.shake = nil

function hud:create()
	hud.ctr = display.newText(game.ctr, display.contentCenterX, 40, "media/Bungee-Regular.ttf", 32)
	hud.ctr:setFillColor(1,1,1)
	hud.ctr.id = "ctr"
	hud.ctr.zero = false

	hud.score = display.newText("Score: " .. game.score,  -15 + (display.contentCenterX / 4), 55 * game.rows + 80, "media/Bungee-Regular.ttf", 18)
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

	--test if counter is zero, and make the text change to show being done
	if game.ctr == 0 and hud.ctr.zero == false and #touch.points > 1 then
		hud.ctr.zero = true
		transition.to(hud.ctr, {time=150, xScale=1.5, yScale = 1.5, transition=easing.outSine})
		hud.shake = timer.performWithDelay(3000, function() game:shake(hud.ctr) end, 0)
	elseif (game.ctr ~= 0 and hud.ctr.zero == true) or (game.ctr == 0 and hud.ctr.zero == true and #touch.points == 0) then
		timer.cancel(hud.shake)
		transition.to(hud.ctr, {time=250, xScale=1, yScale = 1})
		hud.ctr.zero = false
	end
end

function hud:tap(event)
	if event.target.id == "score" then
		composer.gotoScene("scenes.scene_menu")
	end
end

return hud