local reward = {}

function reward.text(text)
	--display text on screen to tell player good job!
	local g = display.newGroup()
	local main = display.newText(g, text, display.contentCenterX, 0, "media/SonsieOne-Regular.ttf", 64)
	main:setFillColor(0.25,0.25,0.25)
	local outline = display.newText(g, text, display.contentCenterX - 3, -2, "media/SonsieOne-Regular.ttf", 64)
	outline:setFillColor(1,0.5,0.5)

	transition.to(g, {time = 250, y = display.contentCenterY, onComplete = function()
		timer.performWithDelay(550, function()
			transition.to(g, {time = 250, y = display.contentHeight + 100, onComplete = function()
				g:removeSelf()
				main = nil
				outline = nil

				game.state = "GAME"
			end})
		end)
	end})
end

return reward