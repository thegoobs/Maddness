local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function buttonPress(event)
    if event.phase == "ended" then
        sound:play("button")
        if event.target.id == "endless" then
            game.mode = "endless"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
            return true
        elseif event.target.id == "continue" then
            game.mode = "continue"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
            continue:removeEventListener("touch", buttonPress)
        elseif event.target.id == "timeattack" then
            game.mode = "timeattack"
            timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
            endless:removeEventListener("touch", buttonPress)
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local g = display.newGroup()
    bg = display.newRect(g, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    local r = math.random()
    local gr = math.random()
    local b = math.random()
    bg:setFillColor(r,gr,b)

    local title = display.newText(g, "Nuffins", display.contentCenterX, 100, "media/Bungee-Regular.ttf" , 48)
    local subtitle = display.newText(g, "Swipe, add, win", display.contentCenterX, 135, "media/Bungee-Regular.ttf" , 16)
     endless = widget.newButton({
        id = "endless",
        label = "Play!",
        x = display.contentCenterX,
        y = 200,

        shape = "roundedRect",
        width = 125,
        height = 35,
        radius = 3,
        fillColor = {default={1,1,1}, over={0,0,0}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={0,0,0}, over={0,0,0}}
        })

    game.save = file:load("savedata")
    if game.save ~= nil then
        endless:setLabel("New Game")
        
        continue = widget.newButton({
        id = "continue",
        label = "Continue",
        x = display.contentCenterX,
        y = 250,

        shape = "roundedRect",
        width = 125,
        height = 35,
        radius = 3,
        fillColor = {default={1,1,1}, over={0,0,0}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={0,0,0}, over={0,0,0}}
        })
    end
    
    -- timeattack = widget.newButton({
    --     id = "timeattack",
    --     label = "Time Attack",
    --     x = display.contentCenterX,
    --     y = 250,

    --     shape = "roundedRect",
    --     width = 200,
    --     height = 35,
    --     radius = 3,
    --     fillColor = {default={1,1,1}, over={0,0,0}},

    --     font = "media/Bungee-Regular.ttf",
    --     labelColor = {default={0,0,0}, over={0,0,0}}
    --     })

    g:insert(endless)
    if game.save ~= nil then
        g:insert(continue)
    end
    -- g:insert(timeattack)

    sceneGroup:insert(g)

    game.mode = nil --haven't picked it yet!

    endless:addEventListener("touch", buttonPress)
    if game.save then continue:addEventListener("touch", buttonPress) end
end
 

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
 

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        composer.removeScene("scenes.scene_menu")
    end
end
 

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    bg:removeSelf()
    endless:removeSelf()

    bg = nil
    endless = nil
end
 
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene