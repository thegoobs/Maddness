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
	local z = {}
	--set text to equal whatver you need to add to zero
	--find all zeroes
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
		if game.ctr ~= 0 then
			obj.text.text = game.ctr * -1
		else
			obj.text.text = "0"
		end
		obj.rect:setFillColor(self.gradient)
	end

	self.r = (math.sin(self.theta) + 1)/2
	self.g = (math.sin(self.theta + 2 * math.pi * (2/3)) + 1)/2
	self.b = (math.sin(self.theta + math.pi * (2/3)) + 1)/2
	self.gradient.color1 = {self.r, self.g, self.b}
	self.gradient.color2 = {self.r, self.g, self.b}
end

return zero