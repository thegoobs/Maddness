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

	if game.mode == "continue" then
		timer.performWithDelay(15 * game.rows * game.columns, function() game.mode = "endless" end)
	end
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
						transition.to(grid[i][j], {time = 200 + 100 * (j - k) + 40*ctr, y = y + 55 * (j - k), transition = easing.inSine,
							onComplete = function()
								sound:play("select")
							end})
						break
					end
				end
			end
		end
	end
	if game.state == "COMPUTE" then
		if game.state ~= "GAME OVER" then
			game.state = "REPOPULATE"
			timer.performWithDelay(maxtime, function() grid:repopulate() end)
		end
	else
		if game.state ~= "GAME OVER" then
			game.state = "CLEANUP"
			timer.performWithDelay(maxtime, function() grid:repopulate() end)
		end
	end
end

function grid:repopulate()
	if game.state == "GAME OVER" then return false end
	ctr = 1
	for i = 1, game.columns do
			for j = 1, game.rows do
			if grid[i][j] ~= nil then break end
			ctr = ctr + 1
			timer.performWithDelay(80 * ctr, function() grid[i][j] = tile:create(i, j) sound:play("fall") end)
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
			if grid:test() then
				if grid.combo > 200 then
					sound:play("game")
					reward.text()
					grid.combo = 0
				else
					grid.combo = 0
					game.state = "GAME"
				end
			end
		end)
	end
end

function grid:clearDisabled(x, y)
	if x < game.columns and grid[x + 1][y] ~= nil then
		if grid[x + 1][y].disabled == true then
			grid[x + 1][y].disabled = false
			transition.to(grid[x + 1][y], {time = 250, alpha = 1})
			grid[x + 1][y].rect:setFillColor(unpack(game.theme.main))
			if grid[x + 1][y].img ~= nil then
				grid[x + 1][y].img:setFillColor(unpack(game.theme.sub))
			else
				grid[x + 1][y].text:setFillColor(unpack(game.theme.sub))
			end
		end
	end

	if x > 1 and grid[x - 1][y] ~= nil then
		if grid[x - 1][y].disabled == true then
			grid[x - 1][y].disabled = false
			transition.to(grid[x - 1][y], {time = 250, alpha = 1})
			grid[x - 1][y].rect:setFillColor(unpack(game.theme.main))
			if grid[x - 1][y].img ~= nil then
				grid[x - 1][y].img:setFillColor(unpack(game.theme.sub))
			else
				grid[x - 1][y].text:setFillColor(unpack(game.theme.sub))
			end
		end	
	end

	if y < game.rows and grid[x][y + 1] ~= nil then
		if grid[x][y + 1].disabled == true then
			grid[x][y + 1].disabled = false
			transition.to(grid[x][y + 1], {time = 250, alpha = 1})
			grid[x][y + 1].rect:setFillColor(unpack(game.theme.main))
			if grid[x][y + 1].img ~= nil then
				grid[x][y + 1].img:setFillColor(unpack(game.theme.sub))
			else
				grid[x][y + 1].text:setFillColor(unpack(game.theme.sub))
			end
		end	
	end
	
	if y > 1 and grid[x][y - 1] ~= nil then
		if grid[x][y - 1].disabled == true then
			grid[x][y - 1].disabled = false
			transition.to(grid[x][y - 1], {time = 250, alpha = 1})
			grid[x][y - 1].rect:setFillColor(unpack(game.theme.main))
			if grid[x][y - 1].img ~= nil then
				grid[x][y - 1].img:setFillColor(unpack(game.theme.sub))
			else
				grid[x][y - 1].text:setFillColor(unpack(game.theme.sub))
			end
		end	
	end
end

function grid:powerups()
	game.state = "POWERUPS"
	for i = 1, #touch.powerups do
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
		onStart = function()
			sound:play("pop")
		end,
		onComplete = function()
			game:updateScore(10 * i)
			grid.combo = grid.combo + (10 * i)
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
		sound:play("disable")
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
		onStart = function()
			sound:play("startup")
			grid[touch.points[i].xpos][touch.points[i].ypos].rect:setFillColor(unpack(game.theme.main))
			grid[touch.points[i].xpos][touch.points[i].ypos].img:setFillColor(unpack(game.theme.sub))
			game:shake(grid[touch.points[i].xpos][touch.points[i].ypos])
		end,
		onComplete = function()
			grid[touch.points[i].xpos][touch.points[i].ypos].rect:setFillColor(unpack(game.theme.sub))
			grid[touch.points[i].xpos][touch.points[i].ypos].img:setFillColor(unpack(game.theme.main))
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