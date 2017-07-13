--game module: manages game states, starting/stopping game,
--			   and 
local game = {}
game.state = "NOT GAME"
game.score = 0
game.ctr = 0
game.group = display.newGroup()
game.rows = 5
game.columns = 5
game.min = -5
game.max = 5

function game:start()
	game.score = 0
	game.ctr = 0

	--make grid
	grid:create()
	--make HUD
	hud:create()

	game.state = "GAME"
end

function game:makeGroup()
	game.group = display.newGroup()

	--add tiles to group
	for i = 1, game.columns do
		for i = 1, game.rows do
			game.group:insert(grid[i][j])
		end
	end

	--add HUD elements to group
	game.group:insert(hud.ctr)
	game.group:insert(hud.score)

end

function game:remove()
	print("get out")
	game.score = 0
	game.tr = 0

	grid:remove()
	hud:remove()

	game.state = "NOT GAME"
end

function game:pause()

end

function game:unpause()

end

--shake function for any display object
function game:shake(obj)
	local offset = 4
	local xpos, ypos = obj:localToContent( 0, 0 )
	transition.to(obj, {
		time = 50,
		x = xpos + offset
		})
	transition.to(obj, {
		time = 50,
		delay = 50,
		x = xpos - offset
		})
	transition.to(obj, {
		time = 50,
		delay = 100,
		x = xpos
		})
end

function game:updateScore(s)
	game.score = game.score + s
end

return game