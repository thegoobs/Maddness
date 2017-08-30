local scene = composer.newScene()
 

function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --make background to hide menu
    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(0,0,0.5)

    function bg.touch(event)
        if event.phase == "ended" and game.state == "GAME" then
            grid:compute()
            return true
        end
    end
    bg:addEventListener("touch", bg.touch)
    

    game:start()
    game:makeGroup()
    
    if revmob.isLoaded(revmob.banner) then
        revmob.show( revmob.banner, { yAlign="bottom" } )
    else
        revmob.load(revmob.banner)
        revmob.show(revmob.banner, {yAlign="bottom"})
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

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("scenes.scene_game")

    end
end
 

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    game:remove()
    revmob.hide(revmob.banner)
end
 
 
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
 
return scene