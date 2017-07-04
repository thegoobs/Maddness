local grid = {}

function grid:create()
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 7 do
			grid[i][j] = tile:create(i, j)
		end
	end
end

return grid