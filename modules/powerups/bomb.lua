local bomb = {}

function bomb:animate(t, neighbors)
	local tx, ty = t.rect:localToContent(0,0)
	--make four tile sized particles that move from center of bomb to effected neighbors
	local particles = {}
	local anim = display.newGroup()
	for i = 1, #neighbors do
		if neighbors[i].powerup == false then
			local xpos, ypos = neighbors[i].rect:localToContent(0, 0)
			particles[i] = display.newImage(anim, "media/bomb_smoke.png", tx, ty)
			particles[i]:scale(0.5, 0.5)
			particles[i]:rotate(math.random() * 360)
			particles[i]:setFillColor(unpack(game.theme.main))
			transition.to(particles[i], {time = 150, x = xpos, y = ypos})
		end
	end

	local function destroy()
		anim:removeSelf()
		anim = nil
		particles = {}	
	end

	transition.to(anim, {time = 300, alpha = 0.25, onComplete = destroy})

	-- --shake grid
	for i = 1, game.columns do
		for j = 1, game.rows do
			if grid[i][j] ~= nil then
				game:shake(grid[i][j])
			end
		end
	end
end

function bomb:activate(t) --t for tile
	local neighbors = combination.findNeighbors(t.xpos, t.ypos)
	if #neighbors > 0 then
		for i = 1, #neighbors do --for each neighbor
			if grid[neighbors[i].xpos][neighbors[i].ypos] ~= nil then
				if neighbors[i].powerup == false then
					--grid:clearDisabled(neighbors[i].xpos, neighbors[i].ypos)
					neighbors[i]:removeSelf()
					grid[neighbors[i].xpos][neighbors[i].ypos] = nil
				else
					table.insert(touch.powerups, neighbors[i])
					tile:activate(neighbors[i], true)
				end
			else
			end
		end
	end

	self:animate(t, neighbors)
	sound:play("bomb")
	t:removeSelf()
	grid[t.xpos][t.ypos] = nil
end

return bomb