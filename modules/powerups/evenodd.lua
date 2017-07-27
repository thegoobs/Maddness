local evenodd = {}

function evenodd:animate()
	--shake grid
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				game:shake(grid[i][j])
			end
		end
	end
end

function evenodd:activate()
	--destroy all tiles with same evenodd as game ctr
	local ctr = game.ctr
	for i = 1, game.columns do
		for j = 1, game.rows do
			if (grid[i][j].val ~= "x0") and (grid[i][j].val ~= 0 or grid[i][j].powerup == "evenOdd") then
				if grid[i][j].powerup == "evenOdd" then
					timer.performWithDelay(15 * i * j, function()
						transition.to(grid[i][j], {time = 100, alpha = 0, y = 25, onComplete = function()
							grid[i][j]:removeSelf()
							grid[i][j] = nil
						end})
					end)
				elseif ctr % 2 == 0  and math.abs(grid[i][j].val) % 2 == 0 then
					timer.performWithDelay(15 * i * j, function()
						transition.to(grid[i][j], {time = 100, alpha = 0, y = 25, onComplete = function()
							grid[i][j]:removeSelf()
							grid[i][j] = nil
						end})
					end)
				elseif ctr % 2 ~= 0 and math.abs(grid[i][j].val) % 2 ~= 0 then
					timer.performWithDelay(15 * i * j, function()
						transition.to(grid[i][j], {time = 100, alpha = 0, y = 25, onComplete = function()
							grid[i][j]:removeSelf()
							grid[i][j] = nil
						end})
					end)
				end
			end
		end
	end

	self:animate()
	game.ctr = 0

	for i, obj in ipairs(touch.points) do
		if obj ~= nil then
			obj.rect:setFillColor(unpack(obj.color))
		end
	end

	timer.performWithDelay(500 + (15 * game.columns * game.rows), function() grid:fall() end)
end


return evenodd