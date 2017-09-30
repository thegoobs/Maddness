local reward = {}
reward.words = {"Nice!", "Great!", "Wow!", "Amazing!", "Rad!", "Neato!", "Hooray!"}

function reward.text(text)
	game.state = "REWARD"

	--display the text where the hud ctr is at
	local s = display.newText(reward.words[math.ceil(math.random(#reward.words))], display.contentCenterX, 40, "media/Bungee-Regular.ttf", 28)
	game:shake(s)
	transition.to(s, {time = 150, alpha = 1})
	timer.performWithDelay(750, function()
		game:shake(s)
		transition.to(s, {time = 150, alpha = 0})
		game.state = "GAME"
	end)
end

return reward