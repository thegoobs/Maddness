--game module: manages game states, starting/stopping game,
--			   and 
local game = {}
game.state = nil
game.score = 0
game.ctr = 0

function game:start()
	game.score = 1
	game.ctr = 0

	--make grid
	grid:create()
	--make HUD
	hud:create()

	game.state = "GAME"
end

function game:pause()

end

function game:unpause()

end

return game