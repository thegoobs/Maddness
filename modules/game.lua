local game = {}
game.state = "NOT GAME"
game.score = 0
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
	
	--make grid
	grid:create()

	--make HUD
	hud:create()
	sound:play("game")
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
	if event.type == "applicationSuspend" and game.state == "GAME" then
		print("whoops")
	elseif event.type == "applicationExit" and game.state == "GAME" then
		file:save("savedata")
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
	border:setFillColor(28/255,28/255,26/255)

	local title = display.newText("Paused", display.contentCenterX, border.y - 50, "media/Bungee-Regular.ttf" , 48)
	local resume = widget.newButton({
		id = "resume",
		label = "Resume",

		x = display.contentCenterX,
		y = display.contentCenterY + offset,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})
	
	local quit = widget.newButton({
		id = "quit",
		label = "Quit",

		x = display.contentCenterX,
		y = resume.y + 50,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})

	game.pauseGroup = display.newGroup()
	game.pauseGroup:insert(border)
	game.pauseGroup:insert(title)
	game.pauseGroup:insert(resume)
	game.pauseGroup:insert(quit)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	resume:addEventListener("touch", function(event) if event.phase == "ended" then sound:play("button") game:unpause() return true end end)
	quit:addEventListener("touch", function(event) if event.phase == "ended" then sound:play("lose") game:unpause() file:remove("savedata") composer.gotoScene("scenes.scene_menu") return true end end)
end

function game:unpause()
	game.state = "UNPAUSE"

	if game.dt ~= nil then
		game.dt = game.dt - (game.pausetime - os.time())
	end
	transition.to(game.shadow, {time = 400, alpha = 0, onComplete = function() game.shadow:removeSelf() end})
	transition.to(game.pauseGroup, {time = 500, y = -100, transition = easing.inSine, onComplete = function()
		game.pauseGroup:removeSelf()
		game.state = "GAME"
	end}) --button cannot immediately remove itself
end

function game:lose()
	game.state = "GAME OVER"
	sound:play("lose")

	--ad show
	if revmob.isLoaded(revmob.int) then
		revmob.show(revmob.int)
	else
		revmob.load(revmob.int)
		revmob.show(revmob.int)
	end

	local offset = (-1 * display.contentCenterY) - 100
	
	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)

	local border = display.newRoundedRect(display.contentCenterX, display.contentCenterY + offset, 250, 200, 3)
	border:setFillColor(28/255,28/255,26/255)

	local title = display.newText("Game Over", display.contentCenterX, border.y - 50, "media/Bungee-Regular.ttf" , 32)
	local retry = widget.newButton({
		id = "retry",
		label = "Retry",

		x = display.contentCenterX,
		y = display.contentCenterY + offset,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})
	
	local quit = widget.newButton({
		id = "quit",
		label = "Quit",

		x = display.contentCenterX,
		y = retry.y + 50,

		shape = "roundedRect",
		width = border.width - 37.5,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})

	game.pauseGroup = display.newGroup()
	game.pauseGroup:insert(border)
	game.pauseGroup:insert(title)
	game.pauseGroup:insert(retry)
	game.pauseGroup:insert(quit)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	retry:addEventListener("touch", function(event)
		if event.phase == "ended" then
			sound:play("button")
			game:unpause()
			timer.performWithDelay(100, function() game:remove() end)
			timer.performWithDelay(1000, function() game:start() end)
			file:remove("savedata")
			return true
		end
	end)
	quit:addEventListener("touch", function(event)
		if event.phase == "ended" then
			sound:play("button")
			game:unpause()
			file:remove("savedata")
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