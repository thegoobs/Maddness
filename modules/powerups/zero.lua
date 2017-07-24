local zero = {}
zero.r = 1
zero.g = 1
zero.b = 1
zero.theta = 0
zero.event = nil

zero.gradient = {
	type = "gradient",
	color1 = {zero.r, 1, 1},
	color2 = {1, zero.g, 1}
}

function zero:enterFrame()
	--find all zeroes
	local z = {}
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				if grid[i][j].val == "x0" then
					table.insert(z, grid[i][j])
				end
			end
		end
	end

	for i, obj in ipairs(z) do
		obj.rect:setFillColor(self.gradient)
	end

	self.r = (math.sin(self.theta) + 1)/2
	self.g = (math.sin(self.theta + 2 * math.pi * (2/3)) + 1)/2
	self.b = (math.sin(self.theta + math.pi * (2/3)) + 1)/2
	self.gradient.color1 = {self.r, self.g, self.b}
	self.gradient.color2 = {self.r, self.g, self.b}
end

return zero