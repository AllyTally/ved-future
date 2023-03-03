
L.CHANGESPRITE = "Change sprite"

function future_is_over_node()
    if selectedtool ~= future_teleporter_tool_id then return false end
    local mouse_x, mouse_y = (getlockablemouseX()-screenoffset), getlockablemouseY()
    for i = 1, count.entity_ai-1 do
        local v = entitydata[i]
        if v and (v.x >= roomx * 40) and (v.x < (roomx + 1) * 40) and (v.y >= roomy * 30) and (v.y < (roomy + 1) * 30) then
            if v.t == 14 then
                if touching_points(mouse_x, mouse_y, POINT_VISUAL_OFFSET + v.p1 * 2, POINT_VISUAL_OFFSET + v.p2 * 2) then
                    return true
                elseif touching_points(mouse_x, mouse_y, POINT_VISUAL_OFFSET + v.p3 * 2, POINT_VISUAL_OFFSET + v.p4 * 2) then
                    return true
                end
            end
        end
    end
    return false
end

function touching_points(mouse_x, mouse_y, x, y)
    return math.abs(mouse_x - x) < NODE_RADIUS and math.abs(mouse_y - y) < NODE_RADIUS
end

function future_update_node_dragging()
    local offsetx = (getlockablemouseX()-screenoffset) - CLICKED_MOUSE_X
    local offsety = getlockablemouseY() - CLICKED_MOUSE_Y

    if offsetx ~= 0 or offsety ~= 0 then
        MOVED_MOUSE = true
    end

    if NODE_TYPE == "teleporter" then
        if CLICKED_NODE == 1 then
            entitydata[CLICKED_ENTITY].p1 = math.floor(CLICKED_NODE_X + offsetx/2)
            entitydata[CLICKED_ENTITY].p2 = math.floor(CLICKED_NODE_Y + offsety/2)
        elseif CLICKED_NODE == 2 then
            entitydata[CLICKED_ENTITY].p3 = math.floor(CLICKED_NODE_X + offsetx/2)
            entitydata[CLICKED_ENTITY].p4 = math.floor(CLICKED_NODE_Y + offsety/2)
        end
    end
end

function future_finish_node_dragging()
    local entity = entitydata[CLICKED_ENTITY]

    if NODE_TYPE == "teleporter" then
        if (not MOVED_MOUSE) and CLICKED_NODE == 2 then
            entity.p5 = (entity.p5 + 1) % 4
            return
        end

        local save_val_1 = (CLICKED_NODE == 1) and entity.p1 or entity.p3
        local save_val_2 = (CLICKED_NODE == 1) and entity.p2 or entity.p4
        local save_key_1 = (CLICKED_NODE == 1) and "p1" or "p3"
        local save_key_2 = (CLICKED_NODE == 1) and "p2" or "p4"

        table.insert(undobuffer, {undotype = "changeentity", rx = roomx, ry = roomy, entid = CLICKED_ENTITY, changedentitydata ={
            {
                key = save_key_1,
                oldvalue = CLICKED_NODE_X,
                newvalue = save_val_1
            },
            {
                key = save_key_2,
                oldvalue = CLICKED_NODE_Y,
                newvalue = save_val_2
            }
        }})
        finish_undo("CHANGED ENTITY (TELEPORTER)")
    end
end
