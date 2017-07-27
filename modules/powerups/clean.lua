local clean = {}

function clean:activate(xpos, ypos)
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				if grid[i][j].disabled == true then
					grid[i][j].disabled = false
					transition.to(grid[i][j], {time = 500, alpha = 1})
					transition.to(grid[i][j].rect, {time = 650, rotation = grid[i][j].rect.rotation - 180, transition = easing.outBack})
				end
			end
		end
	end

	if grid[xpos][ypos] ~= nil then
		grid[xpos][ypos]:removeSelf()
		grid[xpos][ypos] = nil
	end

	--shake grid
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				game:shake(grid[i][j])
			end
		end
	end

end

return clean