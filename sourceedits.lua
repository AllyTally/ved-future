sourceedits =
{
	["uis/maineditor/draw"] =
	{
		{
			find = [[
elseif movingentity > 0 and entitydata[movingentity] ~= nil then]],
			replace = [[
elseif future_is_over_node() then
	
elseif movingentity > 0 and entitydata[movingentity] ~= nil then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[local roomsettings = {platv = levelmetadata_get(roomx, roomy).platv}]],
			replace = [[local roomsettings = {platv = levelmetadata_get(roomx, roomy).platv, enemyv = levelmetadata_get(roomx, roomy).enemyv}]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[rbutton({langkeys(L.ENEMYTYPE, {levelmetadata_get(roomx, roomy).enemytype}), "e"}, -2, 164+4, true)]],
			replace = [[
				rbutton({langkeys(L.ENEMYTYPE, {levelmetadata_get(roomx, roomy).enemytype}), "e"}, -2, 164+4, true)

				ved_print(L.PLATFORMSPEEDSLIDER, love.graphics.getWidth()-(128-8), love.graphics.getHeight()+24-160+4 + 48)
				hoverrectangle(128, 128, 128, 128, love.graphics.getWidth()-(128-8)+(6*8) + (64 - font8:getWidth(roomsettings.enemyv))/2 - 4, love.graphics.getHeight()+24-160 + 48, font8:getWidth(roomsettings.enemyv) + 8, 16)
				int_control(love.graphics.getWidth()-(128-8)+(6*8), love.graphics.getHeight()+24-160 + 48, "enemyv", -math.huge, math.huge, nil, roomsettings, function() return roomsettings.enemyv end, 8*3)
				local oldenemyv = levelmetadata_get(roomx, roomy).enemyv
				if roomsettings.enemyv ~= oldenemyv then
					levelmetadata_set(roomx, roomy, "enemyv", roomsettings.enemyv)
					table.insert(undobuffer, {undotype = "levelmetadata", rx = roomx, ry = roomy, changedmetadata = {
								{
									key = "enemyv",
									oldvalue = oldenemyv,
									newvalue = levelmetadata_get(roomx, roomy).enemyv
								}
							},
							switchtool = 8
						}
					)
					finish_undo("ENEMYV (slider)")
				end
]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		}
	},
	["func"] =
	{
		{
			find = [[removeentity(editingroomtext, nil, true)]],
			replace = [[
if (input == "" and entitydata[editingroomtext] and entitydata[editingroomtext].t == 18) then
	local olddata = entitydata[editingroomtext].data
	entitydata[editingroomtext].data = ""
	if newroomtext then
		entityplaced(editingroomtext)
		newroomtext = false
	else
		table.insert(undobuffer,
			{
				undotype = "changeentity",
				rx = roomx, ry = roomy,
				entid = editingroomtext,
				changedentitydata = {
					{key = "data", oldvalue = olddata, newvalue = entitydata[editingroomtext].data}
				}
			}
		)
	end
else
	removeentity(editingroomtext, nil, true)
end]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["tool_mousedown"] =
	{
		{
			find = [[
		selectedtile = roomdata_get(roomx, roomy, atx, aty)]],
			replace = [[
		selectedtile = roomdata_get(roomx, roomy, atx, aty)
	elseif FUTURE_DRAGGING then
		future_update_node_dragging()
		future_finish_node_dragging()
		FUTURE_DRAGGING = false]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["roomfunc"] =
	{
		{
			find = [[			p1 = p1, p2 = p2, p3 = p3, p4 = p4, p5 = 320, p6 = 240,
			data = data]],
			replace = [[			p1 = p1, p2 = p2, p3 = p3, p4 = p4, p5 = 320, p6 = 240,
			data = data, activitytext = "", activitycolour = ""]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[			if v.t == 19 then
				nthscriptbox = nthscriptbox + 1]],
			replace = [[			if v.t == 19 or v.t == 20 then
				nthscriptbox = nthscriptbox + 1]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["entity_mousedown"] =
	{
		{
			find = [[menu = {"#" .. toolnames[5], L.DELETE, L.FLIP, L.MOVEENTITY, L.COPY, L.PROPERTIES}]],
			replace =
			[[menu = {"#" .. toolnames[5], L.DELETE, L.FLIP, L.CHANGESPRITE, L.MOVEENTITY, L.COPY, L.PROPERTIES}]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find =
			[[menu = {(namefound(v) ~= 0 and "" or "#") .. toolnames[12], L.DELETE, L.EDITSCRIPT, inverted_bump_option, L.OTHERSCRIPT, L.FLIP, L.MOVEENTITY, L.COPY, L.PROPERTIES}]],
			replace =
			[[menu = {(namefound(v) ~= 0 and "" or "#") .. toolnames[12], L.DELETE, L.EDITSCRIPT, inverted_bump_option, L.OTHERSCRIPT, L.FLIP, L.CHANGESPRITE, L.MOVEENTITY, L.COPY, L.PROPERTIES}]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["vvvvvvxml"] =
	{
		{
			find = [[-- Level meta data]],
			replace = [[
cons("Loading entity colors...")
if contents then
	future_entitycolors = contents:match("<EntityColours>(.*)</EntityColours>")
	future_markers = contents:match("<Markers>(.*)</Markers>")
	future_altstates = contents:match("<altstates>(.*)</altstates>")
else
	future_entitycolors = ""
	future_markers = ""
	future_altstates = ""
end

-- Level meta data]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[cons("Saving room metadata...")]],
			replace = [[
savethis = savethis:gsub("%$ENTITYCOLORS%$", future_entitycolors or "")
savethis = savethis:gsub("%$MARKERS%$", future_markers or "")
savethis = savethis:gsub("%$ALTSTATES%$", future_altstates or "")
cons("Saving room metadata...")]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[level_template = love.filesystem.read("template.vvvvvv") -- updated 1.11.0]],
			replace = [[
level_template = love.filesystem.read("template.vvvvvv")
level_template = level_template:gsub("</Data>", "    <EntityColours>$ENTITYCOLORS$</EntityColours>\n        <Markers>$MARKERS$</Markers>\n        <altstates>$ALTSTATES$</altstates>\n    </Data>")]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[
				table.insert(thenewentities,
					"            <edentity x=\"" .. v.x
					.. "\" y=\"" .. v.y
					.. "\" t=\"" .. v.t
					.. "\" p1=\"" .. v.p1
					.. "\" p2=\"" .. v.p2
					.. "\" p3=\"" .. v.p3
					.. "\" p4=\"" .. v.p4
					.. "\" p5=\"" .. v.p5
					.. "\" p6=\"" .. v.p6 .. "\">"
					.. xmlspecialchars(data)
					.. "</edentity>\n"
				)
			]],
			replace = [[
				added = ""
				if v.activitytext and v.activitytext ~= "" then
					added = added .. "\" activitytext=\"" .. v.activitytext
				end
				if v.activitycolour and v.activitycolour ~= "" then
					added = added .. "\" activitycolour=\"" .. v.activitycolour
				end

				table.insert(thenewentities,
					"            <edentity x=\"" .. v.x
					.. "\" y=\"" .. v.y
					.. "\" t=\"" .. v.t
					.. "\" p1=\"" .. v.p1
					.. "\" p2=\"" .. v.p2
					.. "\" p3=\"" .. v.p3
					.. "\" p4=\"" .. v.p4
					.. "\" p5=\"" .. v.p5
					.. "\" p6=\"" .. v.p6
					.. added
					.. "\">"
					.. xmlspecialchars(data)
					.. "</edentity>\n"
				)
			]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[allentities[entityid][k] = tonumber(v)]],
			replace = [[
				if (k == "activitytext" or k == "activitycolour") then
					allentities[entityid][k] = v
				else
					allentities[entityid][k] = tonumber(v)
				end]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[.. "\" enemytype=\"" .. v.enemytype]],
			replace = [[
			.. (v.enemyv == 0 and "" or "\" enemyv=\"" .. v.enemyv)
			.. "\" enemytype=\"" .. v.enemytype]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[enemytype = 0,]],
			replace = [[enemytype = 0, enemyv = 0,]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = true,
		},
		{
			find = [[-- Now we only need the room name...]],
			replace = [[-- Now we only need the room name...
if (not theselevelmetadata[ry][rx].enemyv) then
	theselevelmetadata[ry][rx].enemyv = 0
end
]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["rightclickmenu"] =
	{
		{
			find = [[elseif tonumber(entdetails[2]) == 1 then]],
			replace = [[
			elseif RCMreturn == L.CHANGESPRITE then
				SPRITE_PICKER_ENTITY_ID = tonumber(entdetails[3])
				to_astate("future", 0)
			elseif tonumber(entdetails[2]) == 1 then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["dialog_uses"] =
	{
		{
			find = [[table.insert(form, {"data", labelwidth, row, 47-labelwidth, thisentity.data, DF.TEXT})]],
			replace = [[
table.insert(form, {"data", labelwidth, row, 47-labelwidth, thisentity.data, DF.TEXT})
row = row + 1
local labelwidth = font8:getWidth("activitytext")/8 + 1
table.insert(form, {"", 0, row, labelwidth, "activitytext", DF.LABEL})
table.insert(form, {"activitytext", labelwidth, row, 47-labelwidth, thisentity.activitytext, DF.TEXT})
row = row + 1
local labelwidth = font8:getWidth("activitycolour")/8 + 1
table.insert(form, {"", 0, row, labelwidth, "activitycolour", DF.LABEL})
table.insert(form, {"activitycolour", labelwidth, row, 47-labelwidth, thisentity.activitycolour, DF.TEXT})]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[local entitypropkeys = {"x", "y", "t", "p1", "p2", "p3", "p4", "p5", "p6", "data"}]],
			replace =
			[[local entitypropkeys = {"x", "y", "t", "p1", "p2", "p3", "p4", "p5", "p6", "data", "activitytext", "activitycolour"}]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		},
		{
			find = [[if v ~= "data" then]],
			replace = [[if (v ~= "data") and (v ~= "activitytext") and (v ~= "activitycolour") then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["dialog"] =
	{
		{
			find = "f[v[DFP.KEY]] = v[DFP.VALUE] .. anythingbutnil(v[DFP.TEXT_CONTENT_R])",
			replace = "f[v[DFP.KEY]] = anythingbutnil(v[DFP.VALUE]) .. anythingbutnil(v[DFP.TEXT_CONTENT_R])",
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	}
}
