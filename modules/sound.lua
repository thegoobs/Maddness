local sound = {}

function sound:init()
	sound.select = audio.loadSound("media/sounds/muffin_selection.wav")

	sound.pop = {}
	for i = 1, 6 do
		local s = "media/sounds/pop" .. i .. ".wav"
		sound.pop[i] = audio.loadSound(s)
	end

	sound.startup = audio.loadSound("media/sounds/startup.wav")
	sound.vertical = audio.loadSound("media/sounds/vertical_line.wav")
	sound.horizontal = audio.loadSound("media/sounds/horizontal_line.wav")
	sound.bomb = audio.loadSound("media/sounds/bomb.wav")
	sound.disable = audio.loadSound("media/sounds/gray_blocks.wav")
end

function sound:play(phrase)
	if game.mute == false then
		if phrase == "select" then
			audio.play(sound.select)
		elseif phrase == "pop" or phrase == "button" then
			audio.play(sound.pop[math.ceil(math.random(6))])
		elseif phrase == "startup" then
			audio.play(sound.startup)
		elseif phrase == "horizontal" then
			audio.play(sound.horizontal)
		elseif phrase == "vertical" then
			audio.play(sound.vertical)
		elseif phrase == "bomb" then
			audio.play(sound.bomb)
		elseif phrase == "disable" then
			audio.play(sound.disable)
		end
	end
end

return sound