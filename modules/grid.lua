local grid = {}
grid.transition = false
grid.lastTouched = nil

function grid:create()
	--math.randomseed(os.time())
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 7 do
			grid[i][j] = tile:create(i, j)
		end
	end
end

function grid:fall()
	local maxtime = 0
	for i = 1, 5 do
		local ctr = 0
		for j = 7,1,-1 do
			if grid[i][j] == nil then
				for k = j, 1, -1 do
					local temp = grid[i][k]
					if temp ~= nil then
						grid[i][k] = nil
						grid[i][j] = temp
						grid[i][j].ypos = j

						local x, y = grid[i][j]:localToContent(0, 0)
						if maxtime < 200 + 100 * (7 - j) then maxtime = 200 + 100 * (7 - j) end
						ctr = ctr + 1
						transition.to(grid[i][j], {time = 200 + 100 * (j - k) + 40*ctr, y = y + 50 * (j - k), transition = easing.inSine})
						break
					end
				end
			end
		end
	end
	timer.performWithDelay(maxtime, function() grid:repopulate() end)
end

function grid:repopulate()
	ctr = 0
	for i = 1, 5 do
			for j = 1, 7 do
			if grid[i][j] ~= nil then break end
			ctr = ctr + 1
			timer.performWithDelay(40 * ctr, function() grid[i][j] = tile:create(i, j) end)
		end
	end

	touch.points = {}
	grid.lastTouched = nil
end

function grid:clearDisabled(x, y)
	if x < 5 then
		if grid[x + 1][y].disabled == true then
			print("to my right")
			grid[x + 1][y].disabled = false
			--transition.to(grid[x + 1][y], {time = 250, alpha = 1})
			grid[x+1][y]:setFillColor(1,1,1)
		end
	end

	if x > 1 then
	if grid[x - 1][y].disabled == true then
		print("left")
		grid[x - 1][y].disabled = false
		--transition.to(grid[x - 1][y], {time = 250, alpha = 1})
		grid[x - 1][y]:setFillColor(1,1,1)
	end
	end

	if y < 7 then
	if grid[x][y + 1].disabled == true then
		print("below")
		grid[x][y + 1].disabled = false
		--transition.to(grid[x][y + 1], {time = 250, alpha = 1})
		grid[x][y + 1]:setFillColor(1,1,1)
	end
	end
	
	if y > 1 then
	if grid[x][y - 1].disabled == true then
		print("above")
		grid[x][y - 1].disabled = false
		--transition.to(grid[x][y - 1], {time = 250, alpha = 1})
		grid[x][y - 1]:setFillColor(1,1,1)
	end
	end
end

function grid:compute()
	local max = #touch.points
	local i = 1 --ctr

	if #touch.points <= 1 then
		touch.points[1].rect:setFillColor(1,1,1)
		touch.points[1].selected = false
		touch.points = {}
		game.ctr = 0
		grid.lastTouched = nil
		return
	end

	local success = {
		time = 150,
		alpha = 0,
		onComplete = function()
			game:updateScore(100 * i)

			grid[touch.points[i].xpos][touch.points[i].ypos]:removeSelf()
			grid[touch.points[i].xpos][touch.points[i].ypos] = nil
			i = i + 1
			print(i)
			if i > #touch.points then
				timer.performWithDelay(150, function() grid:fall() end)
			end
		end
	}

	local fail = {
		time = 150,
		alpha = 0.5,
		onComplete = function()
			grid[touch.points[i].xpos][touch.points[i].ypos].disabled = true
			touch.points[i].selected = false
			i = i + 1
			if i > #touch.points then
				touch.points = {}
				game.ctr = 0
				grid.lastTouched = nil
			end
		end
	}

	if game.ctr == 0 then
		timer.performWithDelay(150, function() transition.to(touch.points[i], success) end, #touch.points)
	else
		timer.performWithDelay(150, function() transition.to(touch.points[i], fail) end, #touch.points)
	end
end

return grid