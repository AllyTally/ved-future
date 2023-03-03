allocate_states("future", 2)

NODE_RADIUS = 7
CLICKED_MOUSE_X = 0
CLICKED_MOUSE_Y = 0
CLICKED_NODE_X = 0
CLICKED_NODE_Y = 0
CLICKED_NODE = 1
CLICKED_ENTITY = 1
NODE_TYPE = nil
DRAGGING = false
POINT_VISUAL_OFFSET = 24
MOVED_MOUSE = false

SPRITE_PICKER_ENTITY_ID = 0

SPRITE_PICKER_OFFSET_X = 8 + 188
SPRITE_PICKER_OFFSET_Y = 16 + 8
SPRITE_PICKER_SCROLL_OFFSET = 0

POINT_GRAPHICS = {
    love.graphics.newImage(future_path .. "graphics/point.png"),
    love.graphics.newImage(future_path .. "graphics/point_on.png"),
}

AC_register_tool("Coins", "coins", "s1", 5, {0, 0, 0, 0}, function(atx, aty, roomx, roomy)
        -- Coins
    local found = false
    for ke,ve in pairs(entitydata) do
        if ve.x == (atx + 40 * roomx) and ve.y == (aty + 30 * roomy) then
            -- We found one, whoops
            found = true
            break
        end
    end
    if not found then
        insert_entity(atx, aty, 8)
    end
end, future_path .. "graphics/coins")

future_teleporter_tool_id = AC_register_tool("Teleporter", "tele", "s2", 14, {0, 0, 11, 11}, function(atx, aty, roomx, roomy)
    if not mousepressed then
        -- Teleporters
        -- Ved doesn't have a version of insert_entity which supports p5 and p6...
        insert_entity(atx, aty, 14, (atx + 9) * 8, (aty - 4) * 8 + 37, (atx + 16) * 8 + 38, (aty + 8) * 8)
        entitydata[count.entity_ai - 1].p5 = 1
        entitydata[count.entity_ai - 1].p6 = 7
        mousepressed = true
    end
end, future_path .. "graphics/tele")

AC_register_tool("Gravity token", "fliptoken", "s3", 5, {0, 0, 1, 1}, function(atx, aty, roomx, roomy)
    if not mousepressed then
        -- Gravity tokens
        insert_entity(atx, aty, 5, 0, 10, 1, 0)
        mousepressed = true
    end
end, future_path .. "graphics/fliptoken")



AC_register_click_handler(function(atx, aty, mouse_x, mouse_y)
    if (not DRAGGING) and selectedtool == future_teleporter_tool_id then
        for i = 1, count.entity_ai-1 do
            local v = entitydata[i]
                if v then
                if (v.x >= roomx * 40) and (v.x < (roomx + 1) * 40) and (v.y >= roomy * 30) and (v.y < (roomy + 1) * 30) then
                    if v.t == 14 then
                        -- See if the cursor is touching a control point
                        if touching_points(mouse_x, mouse_y, POINT_VISUAL_OFFSET + v.p1 * 2, POINT_VISUAL_OFFSET + v.p2 * 2) then
                            -- Control point 1
                            CLICKED_MOUSE_X = mouse_x
                            CLICKED_MOUSE_Y = mouse_y
                            CLICKED_NODE = 1
                            CLICKED_NODE_X = v.p1
                            CLICKED_NODE_Y = v.p2
                            CLICKED_ENTITY = i
                            NODE_TYPE = "teleporter"
                            DRAGGING = true
                            MOVED_MOUSE = false
                            return true
                        elseif touching_points(mouse_x, mouse_y, POINT_VISUAL_OFFSET + v.p3 * 2, POINT_VISUAL_OFFSET + v.p4 * 2) then
                            -- Control point 2
                            CLICKED_MOUSE_X = mouse_x
                            CLICKED_MOUSE_Y = mouse_y
                            CLICKED_NODE = 2
                            CLICKED_NODE_X = v.p3
                            CLICKED_NODE_Y = v.p4
                            CLICKED_ENTITY = i
                            NODE_TYPE = "teleporter"
                            DRAGGING = true
                            MOVED_MOUSE = false
                            return true
                        end

                    end
                end
            end
        end
    end
    if DRAGGING then
        return true
    end
    return false
end)

AC_register_entity_render_handler(function(entity, type, x, y, k, interact, offsetx, offsety, myroomx, myroomy, scriptname_args, nthscriptbox)
    if type == 5 then
        v6_setcol(entity.p2)
        drawentitysprite(68 + entity.p1, x, y)
        if interact then
            entity_highlight(x, y, 2, 2)
        end
        return true
    end
    if type == 8 then
		-- Coin
		love.graphics.setColor(255, 255, 0)
		love.graphics.draw(tilesets["tiles.png"]["white_img"], tilesets["tiles.png"]["tiles"][48], x, y, 0, 2)
		love.graphics.setColor(255, 255, 255)
        if interact then
			entity_highlight(x, y, 1, 1)
		end
        return true
    end
    if type == 14 then
		drawtele(x, y, false)

        if (selectedtool == future_teleporter_tool_id) then
            local point_1 = {x + 74, y + 74}
            local point_2 = {offsetx + entity.p1 * 2, offsety + entity.p2 * 2}
            local point_3 = {offsetx + entity.p3 * 2, offsety + entity.p4 * 2}

            local off_point_1 = {point_1[1] + POINT_VISUAL_OFFSET, point_1[2] + POINT_VISUAL_OFFSET}
            local off_point_2 = {point_2[1] + POINT_VISUAL_OFFSET, point_2[2] + POINT_VISUAL_OFFSET}
            local off_point_3 = {point_3[1] + POINT_VISUAL_OFFSET, point_3[2] + POINT_VISUAL_OFFSET}

            v6_setcol(0)
            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(r, g, b, a / 2)

            local sprite = 0
            if (entity.p5 % 2 == 0) then sprite = sprite + 3 end
            if (entity.p5     >= 2) then sprite = sprite + 6 end

            drawentitysprite(sprite, point_3[1], point_3[2])

            love.graphics.setLineWidth(1)
            love.graphics.setLineStyle("rough")

            love.graphics.setColor(0, 255, 255, 127)
            love.graphics.line(off_point_1[1], off_point_1[2], off_point_2[1], off_point_2[2])
            love.graphics.line(off_point_1[1], off_point_1[2], off_point_3[1], off_point_3[2])
            love.graphics.line(off_point_2[1], off_point_2[2], off_point_3[1], off_point_3[2])

            -- Creating a curve object every draw frame might not be the best idea,
            -- but I don't think I can create just one curve and change the points...
            local curve = love.math.newBezierCurve(off_point_1[1], off_point_1[2], off_point_2[1], off_point_2[2], off_point_3[1], off_point_3[2])
            love.graphics.setColor(0, 255, 0)
            love.graphics.setLineWidth(2)
            love.graphics.line(curve:render())
            love.graphics.setColor(255, 255, 255)
            local mouse_x, mouse_y = (getlockablemouseX()-screenoffset), getlockablemouseY()
            local touching_point_1 = touching_points(mouse_x, mouse_y, off_point_2[1] - offsetx, off_point_2[2] - offsety) and 2 or 1
            local touching_point_2 = touching_points(mouse_x, mouse_y, off_point_3[1] - offsetx, off_point_3[2] - offsety) and 2 or 1

            love.graphics.draw(POINT_GRAPHICS[touching_point_1], off_point_2[1] - 7, off_point_2[2] - 7)
            love.graphics.draw(POINT_GRAPHICS[touching_point_2], off_point_3[1] - 7, off_point_3[2] - 7)
        end

        if interact then
			entity_highlight(x, y, 12, 12)
		end
        return true
    end
    if type == 20 or type == 21 or type == 22 or type == 23 or type == 24 then

        if type == 23 then
            -- It's a directional box! Find the center of the box.
            local centerx = x + (entity.p1 -1 ) * 8
            local centery = y + (entity.p2 - 1) * 8

            love.graphics.setColor(196, 196, 255) -- TODO: doesnt glow lol
            -- Draw the arrow.
            if entity.p3 == 0 then
                ved_print("\xE2\x86\x91", centerx, centery, 2)
            elseif entity.p3 == 1 then
                ved_print("\xE2\x86\x93", centerx, centery, 2)
            elseif entity.p3 == 2 then
                ved_print("\xE2\x86\x90", centerx, centery, 2)
            elseif entity.p3 == 3 then
                ved_print("\xE2\x86\x92", centerx, centery, 2)
            end
        end

		-- It's a box, draw it as an actual box.
        if type == 20 then
    		love.graphics.setColor(0, 255, 255)
        elseif type == 21 then
            love.graphics.setColor(0, 255, 0)
        elseif type == 22 then
            love.graphics.setColor(255, 0, 0)
        elseif type == 23 then
            love.graphics.setColor(255, 255, 0)
        elseif type == 24 then
            love.graphics.setColor(255, 0, 255)
        end

		love.graphics.draw(scriptboximg[1], x, y)

        -- Normal box
        love.graphics.draw(scriptboximg[3], x + (entity.p1-1)*16, y)
        love.graphics.draw(scriptboximg[7], x, y + (entity.p2-1)*16)
        love.graphics.draw(scriptboximg[9], x + (entity.p1-1)*16, y + (entity.p2-1)*16)

        -- Horizontal
        for prt = x + 16, x + (entity.p1-1)*16 - 16, 16 do
            love.graphics.draw(scriptboximg[2], prt, y)
            love.graphics.draw(scriptboximg[8], prt, y + (entity.p2-1)*16)
        end

        -- Vertical
        for prt = y + 16, y + (entity.p2-1)*16 - 16, 16 do
            love.graphics.draw(scriptboximg[4], x, prt)
            love.graphics.draw(scriptboximg[6], x + (entity.p1-1)*16, prt)
        end
        love.graphics.setColor(255,255,255)

        if interact then
            entity_highlight(x, y, entity.p1, entity.p2)
        end
		love.graphics.setColor(255,255,255)

		-- Maybe we should also display the script name!
        if type == 20 then
    		if hovering_over_name(true, k, entity, offsetx, offsety, myroomx, myroomy) and interact then
    			AC_SCRIPTNAME_SHOWN = true
    			scriptname_args[1], scriptname_args[2], scriptname_args[3], scriptname_args[4] = true, k, entity, nthscriptbox
    		end
        end
        return true
    end
    return false
end)


AC_register_entity_menu_handler(function(type)
    if type == 5 then
        -- Gravity token
        return {"#Gravity token", L.DELETE, L.MOVEENTITY, L.COPY, L.CHANGESPRITE, L.PROPERTIES}
    end
    if type == 8 then
        -- Coin
        return {"#Coin", L.DELETE, L.MOVEENTITY, L.COPY, L.PROPERTIES}
    end
    if type == 14 then
        -- Teleporter
        return {"#Teleporter", L.DELETE, L.MOVEENTITY, L.COPY, L.PROPERTIES}
    end
end)
