--game module: manages game states, starting/stopping game,
--			   and 
local game = {}
game.state = "NOT GAME"
game.score = 0
game.ctr = 0
game.group = display.newGroup()

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
	for i = 1, 5 do
		for i = 1, 7 do
			game.group:insert(grid[i][j])
		end
	end

	--add HUD elements to group
	game.group:insert(hud.ctr)
	game.group:insert(hud.score)

end

function game:remove()
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

function game:updateScore(s)
	game.score = game.score + s
end

return game