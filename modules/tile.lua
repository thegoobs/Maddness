local tile = {}

function tile:create(xpos, ypos)
	local t = {}
	t = display.newGroup()
	t.rect = display.newRoundedRect(t, -5 + 55 * xpos, -15 + 55 * ypos, 50, 50, 3)
	t.xpos = xpos
	t.ypos = ypos
	t.color = {1,1,1}
	t.img = nil

	--set value, check if power up
	t.val = math.random(game.min, game.max)
	if t.val == 0 then
		local r = math.random(1, 100)
		if r < 32 then
			t.powerup = "vertical"
			t.color = {1,0,1}
			t.rect:setFillColor(unpack(t.color)) --unpack table for some reason
			t.img = display.newImage(t, "media/vertical.png", t.rect.x, t.rect.y)
		elseif r < 65 then
			t.powerup = "bomb"
			t.color = {0,0,1}
			t.rect:setFillColor(unpack(t.color))
			t.img = display.newImage(t, "media/bomb.png", t.rect.x, t.rect.y)
		elseif r < 95 then
			t.powerup = "horizontal"
			t.color = {1,1,0}
			t.rect:setFillColor(unpack(t.color))
			t.img = display.newImage(t, "media/horizontal.png", t.rect.x, t.rect.y)
		elseif r >= 95 then
			t.powerup = false --not actual powerup
			t.val = "x0"
		end
	else
		t.powerup = false
	end

	--create text
	if t.powerup == false then
		t.text = display.newText(t, t.val, -5 + 55 * xpos, -15 + 55 * ypos, "media/Bungee-Regular.ttf", 20)
		t.text:setFillColor(0,0,0)
	end

	--enable conditional variables
	t.selected = false
	t.disabled = false
	t.destroyed = false

	--transition effects
	t.alpha = 0
	transition.to(t, {time = 150, alpha = 1, y = 50})
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
			event.target.rect:setFillColor(1,0,0)
			event.target.selected = true

			if event.target.val == "x0" then
				game.ctr = 0
			else
				game.ctr = game.ctr + event.target.val
			end
			return true
		end
	end


	if game.state == "GAME" and event.phase == "ended" and event.target.disabled == false then
		grid:compute()
		return true
	end
end

function tile:activate(t, RecursivelyCalled)
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
end

return tile