local vertical = {}

function vertical:animate(xpos, ypos)
	--make a thing to animate
	local x = -5 + 55 * xpos
	local anim = display.newGroup()
	local top = display.newRect(anim, x, grid.center.y, 50, 50)
	local bot = display.newRect(anim, x, grid.center.y, 50, 50)

	local function destroy()
		anim:removeSelf()
		anim = nil
		top = nil
		bot = nil
	end
	--animate to go across screen
	transition.to(top, {time = 250, y = grid.top})
	transition.to(bot, {time = 250, y = grid.bottom})
	transition.to(anim, {time = 500, alpha = 0.25, onComplete=destroy})
end

function vertical:activate(t) --t for tile
	--get the column about to be destroyed
	local column = {}
	grid[t.xpos][t.ypos].powerup = false
	for i = 1, game.rows do
		if grid[t.xpos][i] ~= nil then
			if grid[t.xpos][i].powerup == false then
				table.insert(column, grid[t.xpos][i])
			else
				tile:activate(grid[t.xpos][i], true)
			end
		end
	end

	--kill the row by making game compute as if you chose this
	local moveOn = false

	for i = 1, #column do
		transition.to(column[i], {time=100, alpha=0, onStart= function()
			grid[column[i].xpos][column[i].ypos] = nil
		end})
	end

	self:animate(t.xpos, t.ypos)
	column = {}
end

return vertical