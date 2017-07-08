local combination = {}
combination.count = 0
combination.prev = {}

function combination.previouslyUsed(t)
	for i, obj in ipairs(combination.prev) do
		if t == obj then
			return true
		end
	end

	return false
end

function combination.findNeighbors(x, y)
	local l = true
	local r = true
	local t = true
	local b = true

	--test corners
	if x == 1 then l = false
	elseif x == 5 then r = false end

	if y == 1 then t = false
	elseif y == 7 then b = false end

	local neighbors = {}

	if l == true and grid[x - 1][y].disabled == false and combination.previouslyUsed(grid[x - 1][y]) == false then
		table.insert(neighbors,grid[x - 1][y])
	end
	if r == true and grid[x + 1][y].disabled == false and combination.previouslyUsed(grid[x + 1][y]) == false then
		table.insert(neighbors,grid[x + 1][y])
	end
	if t == true and grid[x][y - 1].disabled == false and combination.previouslyUsed(grid[x][y - 1]) == false then
		table.insert(neighbors,grid[x][y - 1])
	end
	if b == true and grid[x][y + 1].disabled == false and combination.previouslyUsed(grid[x][y + 1]) == false then
		table.insert(neighbors,grid[x][y + 1])
	end

	return neighbors
end

function combination:findzero(x, y, prev_ctr)
	--update counter
	local ctr = prev_ctr + grid[x][y].val

	--test if pair is foind
	if ctr == 0 then
		self.prev = {}
		return true
	end

	--add grid member to the stack
	table.insert(self.prev, grid[x][y])

	--find active neighbor tiles
	local neighbors = self.findNeighbors(x, y)

	if #neighbors == 0 then
		self.prev = {}
		return false
	end

	local minTile = nil
	--test neighbor tiles
	for i = 1, #neighbors do
		if minTile == nil then
			minTile = neighbors[i]
		elseif math.abs(ctr + minTile.val) > math.abs(ctr + neighbors[i].val) then
			minTile = neighbors[i]
		end
	end

	return self:findzero(minTile.xpos, minTile.ypos, ctr)

end

return combination