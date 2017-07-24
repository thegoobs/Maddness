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

function game:start()
	game.score = 0
	game.ctr = 0

	--make grid
	grid:create()
	--make HUD
	hud:create()

	game.state = "GAME"
end

function game:makeGroup()
	game.group = display.newGroup()
	
	--add HUD elements to group
	game.group:insert(hud.header)
	game.group:insert(hud.footer)

	Runtime:addEventListener("enterFrame", zero)
end

function game:remove()
	game.score = 0
	game.tr = 0

	grid:remove()
	hud:remove()

	game.state = "NOT GAME"
	Runtime:removeEventListener("enterFrame", zero)
end

--event listener for app suspension
function game:system(event)
	if event.type == "applicationSuspend" and game.state == "GAME" then
		print("whoops")
	end
end

function game:pause()
	game.state = "PAUSE"

	local offset = (-1 * display.contentCenterY) - 100
	
	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)

	local border = display.newRect(display.contentCenterX, display.contentCenterY + offset, 250, 200)
	border:setFillColor(1,0,0)

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

		x = display.contentCenterX - 55,
		y = resume.y + 50,

		shape = "roundedRect",
		width = 100,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})
	
	local extra = widget.newButton({
		id = "extra",
		label = "???",

		x = display.contentCenterX + 55,
		y = resume.y + 50,

		shape = "roundedRect",
		width = 100,
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
	game.pauseGroup:insert(extra)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	resume:addEventListener("touch", function(event) if event.phase == "ended" then game:unpause() return true end end)
	quit:addEventListener("touch", function(event) if event.phase == "ended" then game:unpause() composer.gotoScene("scenes.scene_menu") return true end end)
end

function game:unpause()
	game.state = "UNPAUSE"
	transition.to(game.shadow, {time = 400, alpha = 0, onComplete = function() game.shadow:removeSelf() end})
	transition.to(game.pauseGroup, {time = 500, y = -100, transition = easing.inSine, onComplete = function()
		game.pauseGroup:removeSelf()
		game.state = "GAME"
	end}) --button cannot immediately remove itself
end

function game:lose()
	game.state = "GAME OVER"

	local offset = (-1 * display.contentCenterY) - 100
	
	game.shadow = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	game.shadow:setFillColor(0,0,0,0.4)

	--event listener makes sure nothing behind shadow can be touched
	game.shadow:addEventListener( "touch", function() return true end)

	local border = display.newRect(display.contentCenterX, display.contentCenterY + offset, 250, 200)
	border:setFillColor(1,0,0)

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

		x = display.contentCenterX - 55,
		y = retry.y + 50,

		shape = "roundedRect",
		width = 100,
		height = 40,
		fillColor = {default = {1,1,1}, over = {0,0,0}},

		font = "media/Bungee-Regular.ttf",
		size = 64,
        labelColor = {default={0,0,0}, over={0,0,0}}
	})
	
	local extra = widget.newButton({
		id = "extra",
		label = "???",

		x = display.contentCenterX + 55,
		y = retry.y + 50,

		shape = "roundedRect",
		width = 100,
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
	game.pauseGroup:insert(extra)
	transition.to(game.pauseGroup, {time = 600, y = -1 * offset, transition = easing.outBack})
	retry:addEventListener("touch", function(event)
		timer.performWithDelay(100, function() game:remove() end)
		return true
	end)
	quit:addEventListener("touch", function(event) if event.phase == "ended" then game:unpause() composer.gotoScene("scenes.scene_menu") return true end end)

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