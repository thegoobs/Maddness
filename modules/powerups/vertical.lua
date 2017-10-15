local vertical = {}

function vertical:animate(xpos, ypos)
	--make a thing to animate
	local x = -5 + 55 * xpos
	local anim = display.newGroup()
	local top = display.newImage(anim, "media/powerup_blast.png", x, grid.center.y)
	top:scale(0.5,0.5)
	local bot = display.newImage(anim, "media/powerup_blast.png", x, grid.center.y)
	bot:scale(0.5,0.5)
	bot:rotate(180)

	top:setFillColor(unpack(game.theme.main))
	bot:setFillColor(unpack(game.theme.main))

	local function destroy()
		anim:removeSelf()
		anim = nil
		top = nil
		bot = nil
	end
	--animate to go across screen
	transition.to(top, {time = 200, y = grid.top})
	transition.to(bot, {time = 200, y = grid.bottom})
	transition.to(anim, {time = 350, alpha = 0.25, onComplete=destroy})
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
	sound:play("vertical")
	column = {}
end

return vertical