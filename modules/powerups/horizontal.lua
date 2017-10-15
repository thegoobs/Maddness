local horizontal = {}

function horizontal:animate(xpos, ypos)
	--make a thing to animate
	local y = -20 + 55 * (ypos + 1)
	local anim = display.newGroup()
	local left = display.newImage(anim, "media/powerup_blast.png", display.contentCenterX, y)
	local right = display.newImage(anim, "media/powerup_blast.png", display.contentCenterX, y)
	left:setFillColor(unpack(game.theme.main))
	right:setFillColor(unpack(game.theme.main))

	left:scale(0.5,0.5)
	right:scale(0.5,0.5)

	left:rotate(-90)
	right:rotate(90)
	local function destroy()
		anim:removeSelf()
		anim = nil
		left = nil
		right = nil
	end
	--animate to go across screen
	transition.to(left, {time = 200, x = grid.left})
	transition.to(right, {time = 200, x = grid.right})
	transition.to(anim, {time = 350, alpha = 0.25, onComplete=destroy})
end

function horizontal:activate(t) --to for tile
	--get the row about to be destroyed
	local row = {}
	grid[t.xpos][t.ypos].powerup = false
	for i = 1, game.columns do
		if grid[i][t.ypos] ~= nil then
			if grid[i][t.ypos].powerup == false then
				table.insert(row, grid[i][t.ypos])
			else
				tile:activate(grid[i][t.ypos], true)
			end
		end
	end

	--kill the row by making game compute as if you chose this
	local moveOn = false

	for i = 1, #row do
		--grid:clearDisabled(i, t.ypos)
		transition.to(grid[row[i].xpos][row[i].ypos], {time=100, alpha=0, onStart= function()
			grid[row[i].xpos][row[i].ypos] = nil
		end})
	end

	self:animate(t.xpos, t.ypos)
	sound:play("horizontal")
	row = {}
end

return horizontal