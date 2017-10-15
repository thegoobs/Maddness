local tile = {}

function tile:create(xpos, ypos)
	local t = {}
	t = display.newGroup()
	t.rect = display.newRoundedRect(t, -5 + 55 * xpos, -15 + 55 * ypos, 47, 47, 3)
	--t.rect = display.newImageRect(t, "media/muffin.png", 50, 50)
	t.rect.x, t.rect.y = -5 + 55 * xpos, -15 + 55 * ypos
	t.xpos = xpos
	t.ypos = ypos
	t.color = {unpack(game.theme.sub)}
	t.rect:setFillColor(unpack(game.theme.main))
	t.img = nil
	t.url = nil

	local alphaSave = nil

	--set value, check if power up
	if game.mode == "endless" then
		t.val = math.random(game.min, game.max)
		if t.val == 0 and game.mode == "endless" then
			local r = math.random(1, 100)
			if r < 33 then
				t.powerup = "vertical"
				t.url = "media/vertical.png"
			elseif r < 70 then
				t.powerup = "bomb"
				t.url = "media/bomb@2x.png"
			else
				t.powerup = "horizontal"
				t.url = "media/horizontal.png"
			end
		-- local params = {
		-- 	filename = t.url,
		-- 	x = t.rect.x,
		-- 	y = t.rect.y,
		-- 	width = 50,
		-- 	height = 50
		-- }
		-- t.img = nanosvg.newImage(params)
		-- t:insert(t.img)
		t.img = display.newImage(t, t.url, t.rect.x, t.rect.y)
		t.img:scale(0.5,0.5)
		t.img:setFillColor(unpack(game.theme.sub))
		elseif t.val == 0 and game.mode == "timeattack" then
			t.powerup = "addtime"
			t.img = display.newImage(t, "media/timer.png", t.rect.x, t.rect.y)
			t.url = "media/vertical.png"
		else
			t.powerup = false
		end
	else
		t.val = game.save.grid[xpos][ypos].val
		t.powerup = false
		t.disabled = game.save.grid[xpos][ypos].disabled
		if t.disabled == true then
			alphaSave = 0.5
			t.rect:setFillColor(unpack(game.theme.sub))
		end

		if t.val == 0 then
			t.powerup = game.save.grid[xpos][ypos].powerup
			t.url = game.save.grid[xpos][ypos].url
			t.img = display.newImage(t, t.url, t.rect.x, t.rect.y)
			t.img:scale(0.5,0.5)
			t.rect:setFillColor(unpack(game.theme.main))
			t.img:setFillColor(unpack(game.theme.sub))
			if t.disabled == true then
				t.img:setFillColor(unpack(game.theme.main))
			end
		end
	end

	--create text
	if t.powerup == false or t.powerup == "evenOdd" then
		t.text = display.newText(t, t.val, -5 + 55 * xpos, -15 + 55 * ypos, "media/Bungee-Regular.ttf", 20)
		t.text:setFillColor(unpack(game.theme.sub))
		if t.disabled == true then
			t.text:setFillColor(unpack(game.theme.main))
		end
	end

	--enable conditional variables
	t.selected = false
	if game.mode ~= "continue" then t.disabled = false end
	t.destroyed = false

	--transition effects
	t.alpha = 0
	if alphaSave == nil then alphaSave = 1 end
	transition.to(t, {time = 150, alpha = alphaSave, y = 50})
	t:addEventListener("touch", tile)

	return t
end

function tile.adjacentCheck(t)
	if t.disabled == true then return false end
	if grid.lastTouched == nil then
		grid.lastTouched = t
		return true
	elseif math.abs(t.xpos - grid.lastTouched.xpos) + 
		   math.abs(t.ypos - grid.lastTouched.ypos) <= 1 then
		grid.lastTouched = t
		return true
	else
		return false
	end

end

function tile:touch(event)
	if game.state == "GAME" and 
	   event.target.selected == false and
	   self.adjacentCheck(event.target) == true and
	   event.target.disabled == false then

		if event.phase == "began" or event.phase == "moved" then
			touch:addPoint(event.target)
			event.target.rect:setFillColor(unpack(game.theme.sub))
			if event.target.text ~= nil then
				event.target.text:setFillColor(unpack(game.theme.main))
			else
				event.target.img:setFillColor(unpack(game.theme.main))
			end
			event.target.selected = true
			game.ctr = game.ctr + event.target.val
			sound:play("select")
			return true
		end
	end


	if game.state == "GAME" and event.phase == "ended" and event.target.disabled == false then
		if event.target.powerup == "evenOdd" then
			tile:activate(event.target, false)
			return true
		else
			grid:compute()
			return true
		end
	end
end

function tile:activate(t, RecursivelyCalled)
	game.score = game.score + 200
	grid.combo = grid.combo + 200
	--if statements for each type of powerup
	if t.powerup == "bomb" then
		bomb:activate(t)
	end

	if t.powerup == "vertical" then
		vertical:activate(t)
	end

	if t.powerup == "horizontal" then
		horizontal:activate(t)
	end

	if t.powerup == "evenOdd" then
		evenOdd:activate()
	end

	if t.powerup == "clean" then
		clean:activate(t.xpos, t.ypos)
	end

	if t.powerup == "addtime" then
		addtime:activate(t)
	end
end

return tile