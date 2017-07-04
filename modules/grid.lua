local grid = {}
grid.transition = false

function grid:create()
	math.randomseed(os.time())
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 7 do
			grid[i][j] = tile:create(i, j)
		end
	end
end

function grid:compute()
	local max = #touch.points
	local i = 1 --ctr

	local success = {
		time = 150,
		alpha = 0,
		onComplete = function() 
			i = i + 1
			if i > #touch.points then
				touch.points = {}
				game.ctr = 0
			end
		end
	}

	local fail = {
		time = 150,
		alpha = 0.5,
		onComplete = function() 
			i = i + 1
			if i > #touch.points then
				touch.points = {}
				game.ctr = 0
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