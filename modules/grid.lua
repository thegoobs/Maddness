local grid = {}
grid.transition = false
grid.lastTouched = nil
grid.combo = 0 --combo used for reward stuff

--dimensions for animation purposes
grid.center = nil
grid.top = nil
grid.bottom = nil
grid.left = nil
grid.right = nil

function grid:create()
	--math.randomseed(os.time())
	for i = 1, game.columns do
		grid[i] = {}
		for j = 1, game.rows do
			timer.performWithDelay(15 * i * j, function() grid[i][j] = tile:create(i,j) end)
		end
	end
	grid.center = {x = -5 + (55 * 3), y = -15 + (55 * 4)}
	grid.top = -20 + (55 * 2)
	grid.bottom = -20 + (55 * 6)
	grid.left = 50
	grid.right = -5 + (55 * 5)
end

function grid:remove()
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				timer.performWithDelay(15 * i * j, function()
					transition.to(grid[i][j], {time = 100, alpha = 0, y = 25, onComplete = function()
						grid[i][j]:removeSelf()
						grid[i][j] = nil
					end})
				end)
			end
		end
	end

	grid.lastTouched = nil
	grid.transition = false
end

function grid:fall()
	local maxtime = 0
	for i = 1, game.columns do
		local ctr = 0
		for j = game.rows,1,-1 do
			if grid[i][j] == nil then
				for k = j, 1, -1 do
					local temp = grid[i][k]
					if temp ~= nil then
						grid[i][k] = nil
						grid[i][j] = temp
						grid[i][j].ypos = j

						local x, y = grid[i][j]:localToContent(0, 0)
						if maxtime < 200 + 100 * (game.rows - j) then maxtime = 200 + 100 * (game.rows - j) end
						ctr = ctr + 1
						transition.to(grid[i][j], {time = 200 + 100 * (j - k) + 40*ctr, y = y + 55 * (j - k), transition = easing.inSine})
						break
					end
				end
			end
		end
	end
	if game.state == "COMPUTE" then
		game.state = "REPOPULATE"
		timer.performWithDelay(maxtime, function() grid:repopulate() end)
	else
		game.state = "CLEANUP"
		timer.performWithDelay(maxtime, function() grid:repopulate() end)
	end
end

function grid:repopulate()
	ctr = 1
	for i = 1, game.columns do
			for j = 1, game.rows do
			if grid[i][j] ~= nil then break end
			ctr = ctr + 1
			timer.performWithDelay(80 * ctr, function() grid[i][j] = tile:create(i, j) end)
		end
	end

	touch.points = {}
	grid.lastTouched = nil
	if game.state == "REPOPULATE" then
		timer.performWithDelay(125 * (ctr + 1), function()
			grid:powerups()
		end)
	else
		timer.performWithDelay(100 * (ctr + 1), function()
			if grid.combo >= 1500 then
				reward.text("Tasty!")
				grid.combo = 0
			else
				game.state = "GAME"
			end
		end)
	end
end

function grid:clearDisabled(x, y)
	if x < game.columns and grid[x + 1][y] ~= nil then
		if grid[x + 1][y].disabled == true then
			grid[x + 1][y].disabled = false
			transition.to(grid[x + 1][y], {time = 250, alpha = 1})
			grid[x + 1][y].rect:setFillColor(unpack(grid[x + 1][y].color))
		end
	end

	if x > 1 and grid[x - 1][y] ~= nil then
		if grid[x - 1][y].disabled == true then
			grid[x - 1][y].disabled = false
			transition.to(grid[x - 1][y], {time = 250, alpha = 1})
			grid[x - 1][y].rect:setFillColor(unpack(grid[x - 1][y].color))
		end
	end

	if y < game.rows and grid[x][y + 1] ~= nil then
		if grid[x][y + 1].disabled == true then
			grid[x][y + 1].disabled = false
			transition.to(grid[x][y + 1], {time = 250, alpha = 1})
			grid[x][y + 1].rect:setFillColor(unpack(grid[x][y + 1].color))
		end
	end
	
	if y > 1 and grid[x][y - 1] ~= nil then
		if grid[x][y - 1].disabled == true then
			grid[x][y - 1].disabled = false
			transition.to(grid[x][y - 1], {time = 250, alpha = 1})
			grid[x][y - 1].rect:setFillColor(unpack(grid[x][y - 1].color))
		end
	end
end

function grid:powerups()
	game.state = "POWERUPS"
	for i = 1, #touch.powerups do
		game.score = game.score + 10000
		grid.combo = grid.combo + 10000
		tile:activate(touch.powerups[i], false)
	end

	if #touch.powerups > 0 then
		touch.powerups = {}
		timer.performWithDelay(350, function() grid:fall() end)
	else
		grid:fall()
	end
end

function grid:compute()
	local max = #touch.points
	local i = 1 --ctr

	if #touch.points == 1 and touch.points[1].val ~= 0 then

		touch.points[1].rect:setFillColor(1,1,1)
		touch.points[1].selected = false
		touch.points = {}
		game.ctr = 0
		grid.lastTouched = nil
		return
	end

	local success = {
		time = 100,
		alpha = 0,
		onComplete = function()
			game:updateScore(100 * i)
			grid.combo = grid.combo + (100 * i)
			grid:clearDisabled(touch.points[i].xpos, touch.points[i].ypos)
			grid[touch.points[i].xpos][touch.points[i].ypos]:removeSelf()
			grid[touch.points[i].xpos][touch.points[i].ypos] = nil
			i = i + 1

			if i > #touch.points then
				timer.performWithDelay(150, function() grid:fall() end)
			end
		end
	}

	local fail = {
		time = 100,
		alpha = 0.5,
		onComplete = function()
			grid[touch.points[i].xpos][touch.points[i].ypos].disabled = true
			grid[touch.points[i].xpos][touch.points[i].ypos].rect:setFillColor(unpack(grid[touch.points[i].xpos][touch.points[i].ypos].color))
			touch.points[i].selected = false
			i = i + 1
			if i > #touch.points then
				touch.points = {}
				game.ctr = 0
				grid.lastTouched = nil
				game.state = "GAME"
				touch.powerups = {}
				timer.performWithDelay(1000, function() grid:test() end)
			end
		end
	}
	
	local powerup = {
		time = 100,
		onComplete = function()
			grid[touch.points[i].xpos][touch.points[i].ypos].rect:setFillColor(0,1,0)
			i = i + 1
			if i > #touch.points then
				timer.performWithDelay(150, function() grid:fall() end)
			end
		end
	}

	if game.ctr == 0 and #touch.points > 0 then
		game.state = "COMPUTE"
		timer.performWithDelay(125, function()
			if touch.points[i].powerup == false or touch.points[i] == "evenOdd" then
				transition.to(touch.points[i], success)
			else
				transition.to(touch.points[i], powerup)
			end
		end, #touch.points)
	elseif game.ctr ~= 0 and #touch.points > 0 then
		game.state = "COMPUTE"
		timer.performWithDelay(125, function() transition.to(touch.points[i], fail) end, #touch.points)
	else
		grid:fall()
	end
end

function grid:test()
	for i = 1, game.columns do
		for j = 1, game.rows do
			--print("starting at: " .. i .. " " .. j .. " is it disabled? " .. tostring(grid[i][j].disabled))
			if grid[i][j].disabled == false then
				if combination:findzero(i, j, 0) == true then
 					return true
 				end
 			end
		end
	end
	game:lose()
	return false
end

return grid