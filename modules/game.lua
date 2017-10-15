local game = {}
game.state = "NOT GAME"
game.score = 0
game.ciel = 10000 --chunk size to increment difficulty by
game.best = 0
game.ctr = 0
game.group = display.newGroup()
game.rows = 5
game.columns = 5
game.min = -5
game.max = 5
game.pauseGroup = nil
game.shadow = nil
game.timer = nil
game.mode = nil
game.dt = nil
game.pausetime = 0
game.mute = false
game.firstTime = true --if you haven't played the game before, this is true
game.nextTheme = nil --theme that hasn't been seen yet

game.theme_index = 0
game.theme = theme[game.theme_index + 1]

game.save = {}
function game:start()
	game.score = 0
	game.ctr = 0

	touch.points = {}
	touch.powerups = {}

	if hud.shake ~= nil then
		timer.cancel(hud.shake)
	end
	
	game.state = "STARTUP"

	--Runtime:addEventListener("enterFrame", zero)
	timer.performWithDelay(500, function() game.state = "GAME" end) --wiggy shit happened

	--if game is time attack, start the timer
	if game.mode == "timeattack" then
		game:startTimer()
	end
	
	if game.mode == "continue" then
		game.score = game.save.score
	end

	game.max = game.max + math.floor(game.score/game.ciel)
	game.min = game.max * -1
	game.ciel = 5000 + (5000 * math.floor(game.score / game.ciel))

	--make grid
	grid:create()

	--make HUD
	hud:create()
	sound:play("game")

	if game.firstTime == false then
		timer.performWithDelay(500, function() 
			game:tutorial()
			game.firstTime = true
		end)
	end

end

function game.timer(event)
	if 60 - (os.time() - game.dt) <= 0 then
		game:endTimer()
	end
end

function game:startTimer()
	game.dt = os.time()
	Runtime:addEventListener("enterFrame", game.timer)
end

function game:endTimer()
	Runtime:removeEventListener("enterFrame", game.timer)
end

function game:makeGroup()
	game.group = display.newGroup()
	
	--add HUD elements to group
	game.group:insert(hud.header)
	game.group:insert(hud.footer)
end

function game:remove()
	game.score = 0
	game.ciel = 10000
	game.max = 5
	game.min = -5
	game.tr = 0

	grid:remove()
	hud:remove()

	if game.mode == "timeattack" then
		game:endTimer()
	end

	game.state = "NOT GAME"
	Runtime:removeEventListener("enterFrame", zero)
end

--event listener for app suspension
function game:system(event)
	if event.type == "applicationExit" and game.state == "GAME" then
		file:save("savedata")
		file:saveStats()
	elseif event.type == "applicationExit" and game.state ~= "GAME" then
		file:saveStats()
	end

end

function game:pause()
	game.state = "PAUSE"

	game.pausetime = os.time()

	local offset = (-1 * display.contentCenterY) - 100
	
	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)

	local border = display.newRoundedRect(display.contentCenterX, display.contentCenterY + offset, 250, 200, 3)
	border:setFillColor(unpack(game.theme.bg))

	local title = display.newText("Paused", display.contentCenterX, border.y - 50, "media/Bungee-Regular.ttf" , 48)
	title:setFillColor(unpack(game.theme.main))
	local resume = widget.newButton({
		id = "resume",
		label = "Resume",

		x = display.contentCenterX,
		y = display.contentCenterY + offset,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {unpack(game.theme.main)}, over = {unpack(game.theme.sub)}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
	})
	
	local quit = widget.newButton({
		id = "quit",
		label = "Quit",

		x = display.contentCenterX,
		y = resume.y + 50,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {unpack(game.theme.main)}, over = {unpack(game.theme.sub)}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
	})

	game.pauseGroup = display.newGroup()
	game.pauseGroup:insert(border)
	game.pauseGroup:insert(title)
	game.pauseGroup:insert(resume)
	game.pauseGroup:insert(quit)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	resume:addEventListener("touch", function(event)
		if event.phase == "ended" and game.state == "PAUSE" then
			sound:play("button")
			game:unpause()
			return true
		end
	end)
	quit:addEventListener("touch", function(event)
		if event.phase == "ended" and game.state == "PAUSE" then
			sound:play("lose")

		if game.score > game.best then
			game.best = game.score
			game.firstTime = true
			file:saveStats()
		end

			game:unpause()
			file:remove("savedata")
			composer.gotoScene("scenes.scene_menu")
			return true
		end
	end)
end

function game:unpause()
	if game.state == "PAUSE" then
		game.state = "UNPAUSE"
	end

	if game.dt ~= nil then
		game.dt = game.dt - (game.pausetime - os.time())
	end
	transition.to(game.shadow, {time = 400, alpha = 0, onComplete = function() game.shadow:removeSelf() end})
	transition.to(game.pauseGroup, {time = 500, y = -100, transition = easing.inSine, onComplete = function()
		game.pauseGroup:removeSelf()
		if game.state == "UNPAUSE" then
			game.state = "GAME"
		end
	end}) --button cannot immediately remove itself
end

function game:tutorial()
	if game.state == "GAME" then
		game.state = "PAUSE"
	end

	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)


	local offset = (-1 * display.contentCenterY) - 100

	local border = display.newRoundedRect(display.contentCenterX, display.contentCenterY + offset, 250, 275, 3)
	border:setFillColor(unpack(game.theme.bg))

	local title = display.newText("How To Play", display.contentCenterX, border.y - border.height/2 + 30, "media/Bungee-Regular.ttf" , 32)
	title:setFillColor(unpack(game.theme.main))

	local instructions = display.newText({
		text = "Slide your finger over tiles to add them up. Win points if the sum of the tiles equals zero!\n\nIf the sum does not equal zero, the tiles disable and cannot be used. Clear tiles around disabled ones to reactivate them.\n\nUse powerups in sequence or alone to get extra points!",
		x = display.contentCenterX,
		y = border.y - 62.5 + 55,
		width = border.width - 24,
		height = border.height + offset,
		font = "media/Bungee-Regular.ttf",
		fontSize = 12,
		align = "center"
	})
	instructions:setFillColor(unpack(game.theme.main))
	instructions.align = "center"
	local playButton = widget.newButton({
		id = "tutplay",
		label = "Okay!",

		x = display.contentCenterX,
		y = display.contentCenterY + offset + 105,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {unpack(game.theme.main)}, over = {unpack(game.theme.sub)}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
	})

	game.pauseGroup = display.newGroup()
	game.pauseGroup:insert(border)
	game.pauseGroup:insert(title)
	game.pauseGroup:insert(instructions)
	game.pauseGroup:insert(playButton)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	playButton:addEventListener("touch", function(event)
		if event.phase == "ended" and (game.state == "PAUSE" or game.state == "NOT GAME") then
			sound:play("button")
			game:unpause()
			return true
		end
	end)


end

function game:lose()
	game.state = "GAME OVER"
	sound:play("lose")

	--ad show
	if appodeal.isLoaded("interstitial") then
		timer.performWithDelay(500, appodeal.show("interstitial"))
	else
        appodeal.load("interstitial")
		timer.performWithDelay(500, function() appodeal.show("interstitial") end)
	end

	local offset = (-1 * display.contentCenterY) - 100
	
	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)

	local border = display.newRoundedRect(display.contentCenterX, display.contentCenterY + offset, 250, 200, 3)
	border:setFillColor(unpack(game.theme.bg))

	local title = display.newText("Game Over", display.contentCenterX, border.y - 62.5, "media/Bungee-Regular.ttf" , 32)
	title:setFillColor(unpack(game.theme.main))
	local highscore = display.newText("", display.contentCenterX, border.y - 37.5, "media/Bungee-Regular.ttf" , 18)
	highscore:setFillColor(unpack(game.theme.main))
	if game.score > game.best then
		game.best = game.score
		highscore.text = "New Highscore!"
		file:saveStats()
	end

	local retry = widget.newButton({
		id = "retry",
		label = "Retry",

		x = display.contentCenterX,
		y = display.contentCenterY + offset,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {unpack(game.theme.main)}, over = {unpack(game.theme.sub)}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
	})
	
	local quit = widget.newButton({
		id = "quit",
		label = "Quit",

		x = display.contentCenterX,
		y = retry.y + 50,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {unpack(game.theme.main)}, over = {unpack(game.theme.sub)}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={unpack(game.theme.sub)}, over={unpack(game.theme.sub)}}
	})

	game.pauseGroup = display.newGroup()
	game.pauseGroup:insert(border)
	game.pauseGroup:insert(title)
	game.pauseGroup:insert(highscore)
	game.pauseGroup:insert(retry)
	game.pauseGroup:insert(quit)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	retry:addEventListener("touch", function(event)
		if event.phase == "ended" and game.state == "GAME OVER" then
			sound:play("button")
			game:unpause()
			timer.performWithDelay(100, function() game:remove() end)
			timer.performWithDelay(1000, function() game:start() end)
			file:remove("savedata")
			return true
		end
	end)
	quit:addEventListener("touch", function(event)
		if event.phase == "ended" and game.state == "GAME OVER" then
			sound:play("button")
			game:unpause()
			file:remove("savedata")
			file:saveStats()
			composer.gotoScene("scenes.scene_menu")
			return true
		end
	end)

end

--shake function for any display object
function game:shake(obj)
	local offset = 4
	local xpos, ypos = obj:localToContent( 0, 0 )
	transition.to(obj, {
		time = 50,
		x = xpos + offset
		})
	transition.to(obj, {
		time = 50,
		delay = 50,
		x = xpos - offset
		})
	transition.to(obj, {
		time = 50,
		delay = 100,
		x = xpos
		})
end

function game:updateScore(s)
	game.score = game.score + s
end

return game