local tile = {}
function tile:create(xpos, ypos)
	local t = {}
	t = display.newGroup()
	t.rect = display.newRoundedRect(t, -5 + 55 * xpos, -15 + 55 * ypos, 50, 50, 3)
	t.xpos = xpos
	t.ypos = ypos
	t.color = {1,1,1}

	--set value, check if power up
	t.val = math.random(game.min, game.max)
	if t.val == 0 then
		local r = math.random(1, 3)
		if r == 1 then
			t.powerup = "vertical"
			t.color = {1,0,1}
			t.rect:setFillColor(unpack(t.color)) --unpack table for some reason
		elseif r == 2 then
			t.powerup = "bomb"
			t.color = {0,0,1}
			t.rect:setFillColor(unpack(t.color))
		elseif r == 3 then
			t.powerup = "horizontal"
			t.color = {1,1,0}
			t.rect:setFillColor(unpack(t.color))
		end
	else
		t.powerup = false
	end

	--create text
	t.text = display.newText(t, t.val, -5 + 55 * xpos, -15 + 55 * ypos, "media/Bungee-Regular.ttf", 20)
	t.text:setFillColor(0,0,0)
	
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
			game.ctr = game.ctr + event.target.val
		end
	end


	if game.state == "GAME" and event.phase == "ended" and event.target.disabled == false then
		grid:compute()
	end
end

function tile:activate(t, RecursivelyCalled)
	--if statements for each type of powerup
	if t.powerup == "bomb" then
		local neighbors = combination.findNeighbors(t.xpos, t.ypos)
		if #neighbors > 0 then
			for i = 1, #neighbors do --for each neighbor
				if grid[neighbors[i].xpos][neighbors[i].ypos] ~= nil then
					if neighbors[i].powerup == false then
						neighbors[i]:removeSelf()
						grid[neighbors[i].xpos][neighbors[i].ypos] = nil
					else
						table.insert(touch.powerups, neighbors[i])
						tile:activate(neighbors[i], true)
					end
				else
					print("this should not go off")
				end
			end
		end

		game.score = game.score + 10000
		t:removeSelf()
		grid[t.xpos][t.ypos] = nil

		--shake grid
		for i = 1, game.columns do
			for j = 1, game.rows do
				if grid[i][j] ~= nil then
					game:shake(grid[i][j])
				end
			end
		end
	end

	if t.powerup == "vertical" then
		--get the column about to be destroyed
		local column = {}
		grid[t.xpos][t.ypos].powerup = false
		for i = 1, game.rows do
			if grid[t.xpos][i] ~= nil then
				if grid[t.xpos][i].powerup == false then
					table.insert(column, grid[t.xpos][i])
				else
					tile:activate(grid[t.xpos][i], true)
				end
			end
		end

		--kill the row by making game compute as if you chose this
		local moveOn = false

		for i = 1, #column do
			transition.to(column[i], {time=100, alpha=0, onStart= function()
				grid[column[i].xpos][column[i].ypos] = nil
			end})
		end
		game.score = game.score + 10000
		column = {}
	end

	if t.powerup == "horizontal" then
		--get the row about to be destroyed
		local row = {}
		grid[t.xpos][t.ypos].powerup = false
		for i = 1, game.columns do
			if grid[i][t.ypos] ~= nil then
				if grid[i][t.ypos].powerup == false then
					table.insert(row, grid[i][t.ypos])
				else
					tile:activate(grid[i][t.ypos], true)
				end
			end
		end

		--kill the row by making game compute as if you chose this
		local moveOn = false

		for i = 1, #row do
			transition.to(row[i], {time=100, alpha=0, onStart= function()
				grid[row[i].xpos][row[i].ypos] = nil
			end})
		end
		game.score = game.score + 10000
		row = {}

	end

end

return tile