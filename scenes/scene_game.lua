local scene = composer.newScene()
 

function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --make background to hide menu
    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(unpack(game.theme.bg))

    function bg.touch(event)
        if event.phase == "ended" and game.state == "GAME" then
            grid:compute()
            return true
        end
    end

    bg:addEventListener("touch", bg.touch)
    

    transition.to(howTo, {time = 500, y = display.contentCenterY + 115, transition = easing.outBack})
    transition.to(howTo.label, {time = 500, y = display.contentCenterY + 115, transition = easing.outBack})
    game:start()
    game:makeGroup()
    
    if appodeal.isLoaded("banner") then
        timer.performWithDelay(500, appodeal.show("banner", {yAlign="bottom"}))
    else
        appodeal.load("banner")
        timer.performWithDelay(500, function() appodeal.show("banner", {yAlign="bottom"}) end)
    end

    sceneGroup:insert(game.group)
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
        transition.to(howTo, {time = 500, y = display.contentHeight - 40, transition = easing.outBack})
        transition.to(howTo.label, {time = 500, y = display.contentHeight - 40, transition = easing.outBack})
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("scenes.scene_game")

    end
end
 

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    game:remove()
    appodeal.hide("banner")
end
 
 
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
 
return scene