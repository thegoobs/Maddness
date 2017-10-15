local reward = {}
reward.words = {"Nice!", "Great!", "Wow!", "Amazing!", "Radical!", "Crazy!", "Perfect!"}

function reward.text(text)
	game.state = "REWARD"

	local index = math.ceil(#reward.words * grid.combo/1250)

	if index > #reward.words then
		index = #reward.words
	elseif index < 1 then
		index = 1
	end

	--display the text where the hud ctr is at
	local s = display.newText(reward.words[index], display.contentCenterX, 40, "media/Bungee-Regular.ttf", 28)
	s:setFillColor(unpack(game.theme.main))
	game:shake(s)
	transition.to(s, {time = 150, alpha = 1})
	timer.performWithDelay(750, function()
		game:shake(s)
		transition.to(s, {time = 150, alpha = 0})
		game.state = "GAME"
	end)
end

function reward:newTheme()
	local s = display.newText("New!", themeSelect.x, themeSelect.y, "media/Bungee-Regular.ttf", 12)
	s:setFillColor(unpack(game.theme.main))
	transition.to(s, {time = 150, y = themeSelect.y - 35, onComplete = function()
		timer.performWithDelay(500, function() s:removeSelf() s = nil end)
	end})
end

return reward