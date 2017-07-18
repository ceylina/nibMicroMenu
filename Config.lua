local nibMicroMenu = LibStub("AceAddon-3.0"):GetAddon("nibMicroMenu")
local L = LibStub("AceLocale-3.0"):GetLocale("nibMicroMenu")

local db

-- Anchor Points
local table_AnchorPoints = {
	"BOTTOM",
	"BOTTOMLEFT",
	"BOTTOMRIGHT",
	"CENTER",
	"LEFT",
	"RIGHT",
	"TOP",
	"TOPLEFT",
	"TOPRIGHT",
}
local table_AnchorPoints_L = {
	L["Bottom"],
	L["Bottom Left"],
	L["Bottom Right"],
	L["Center"],
	L["Left"],
	L["Right"],
	L["Top"],
	L["Top Left"],
	L["Top Right"],
}

-- Strata
local table_Strata = {
	"BACKGROUND",
	"LOW",
	"MEDIUM",
	"HIGH",
	"DIALOG",
	"TOOLTIP",
}
local table_Strata_L = {
	L["Background"],
	L["Low"],
	L["Medium"],
	L["High"],
	L["Dialog"],
}

-- Orientation
local table_Orientation = {
	"Horizontal",
	"Vertical",
}
local table_Orientation_L = {
	L["Horizontal"],
	L["Vertical"],
}

-- Font Outline
local table_Outline = {
	"NONE",
	"OUTLINE",
	"THICKOUTLINE",
}
local table_Outline_L = {
	L["None"],
	L["Outline"],
	L["Thick Outline"],
}

-- Buttons
local ButtonNames_L = {
	[1] = L["Character"],
	[2] = L["Spell Book"],
	[3] = L["Talents"],
	[4] = L["Achievements"],
	[5] = L["Quest"],
	[6] = L["Social"],
	[7] = L["Guild"],
	[8] = L["LFD"],
	[9] = L["Collections"],
	[10] = ENCOUNTER_JOURNAL,
	[11] = L["Store"],
	[12] = L["Reload"],
	[13] = L["Exit"],
	[14] = L["Logout"],
}

local function ValidateOffset(value)
	val = tonumber(value)
	if val == nil then val = 0 end
	if val < -5000 then val = 5000 elseif val > 5000 then val = 5000 end
	return val
end

-- Return the Options table
local options = nil
local function GetOptions()
	local TextOpts, MicroOpts = {}, {}
	local Opts_TextOrderCnt = 10
	local Opts_MicroOrderCnt = 10
	
	if not options then
		options = {
			name = "nibMicroMenu",
			handler = nibMicroMenu,
			type = "group",
			childGroups = "tab",
			args = {
				textsfont = {
					name = L["Texts"],
					type = "group",
					order = 10,
					args = {
						buttontexts = {
							name = L["Buttons"],
							type = "group",
							inline = true,
							order = 20,
							args = {},
						},
						font_area = {
							name = L["Font"],
							type = "group",
							inline = true,
							order = 30,
							args = {
								fontname = {
									type = "select",
									name = L["Name"],
									values = AceGUIWidgetLSMlists.font,
									get = function()
										return db.font.name
									end,
									set = function(info, value)
										db.font.name = value
										nibMicroMenu:Refresh()
									end,
									dialogControl='LSM30_Font',
									order = 10,
								},
								fontsize = {
									type = "range",
									name = L["Size"],
									min = 6, max = 36, step = 1,
									get = function(info) return db.font.size end,
									set = function(info, value) db.font.size = value; nibMicroMenu:Refresh(); end,
									order = 20,
								},
							},
						},
					},
				},
				positionsize = {
					name = L["Position"],
					type = "group",
					childGroups = "tab",
					order = 20,
					args = {
						position = {
							name = L["Position"],
							type = "group",
							order = 10,
							args = {
								offset = {
									type = "group",
									name = L["Offset"],
									inline = true,
									order = 10,									
									args = {
										xoffset = {
											type = "input",
											name = L["X"],
											width = "half",
											order = 10,
											get = function(info) return tostring(db.position.x) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.position.x = value
												nibMicroMenu:Refresh()
											end,
										},
										yoffset = {
											type = "input",
											name = L["Y"],
											width = "half",
											order = 20,
											get = function(info) return tostring(db.position.y) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.position.y = value
												nibMicroMenu:Refresh()
											end,
										},
									},
								},
								anchors = {
									type = "group",
									name = L["Anchors"],
									inline = true,
									order = 20,									
									args = {
										anchorto = {
											type = "select",
											name = L["Anchor To"],
											get = function(info) 
												for k,v in pairs(table_AnchorPoints) do
													if v == db.position.anchorto then return k end
												end
											end,
											set = function(info, value)
												db.position.anchorto = table_AnchorPoints[value]
												nibMicroMenu:Refresh()
											end,
											style = "dropdown",
											width = nil,
											values = table_AnchorPoints_L,
											order = 10,
										},
										anchorfrom = {
											type = "select",
											name = L["Anchor From"],
											get = function(info) 
												for k,v in pairs(table_AnchorPoints) do
													if v == db.position.anchorfrom then return k end
												end
											end,
											set = function(info, value)
												db.position.anchorfrom = table_AnchorPoints[value]
												nibMicroMenu:Refresh()
											end,
											style = "dropdown",
											width = nil,
											values = table_AnchorPoints_L,
											order = 20,
										},
										parent = {
											type = "input",
											name = L["Parent"],
											get = function(info) return db.position.parent end,
											set = function(info, value) db.position.parent = value; nibMicroMenu:Refresh(); end,
											order = 30,
										},
									},
								},								
							},
						},
						strata = {
							type = "group",
							name = L["Strata"],
							childGroups = "tab",
							order = 20,
							args = {
								automatic = {
									type = "toggle",
									name = L["Automatic"],
									desc = "The Micro Menu will automatically set itself to appear on top of whatever it is parented to.",
									get = function() return db.framelevel.automatic end,
									set = function(info, value) 
										db.framelevel.automatic = value;
										nibMicroMenu:Refresh();
									end,
									order = 10,
								},
								manual = {
									name = L["Manual"],
									type = "group",
									inline = true,
									disabled = function() if db.framelevel.automatic then return true else return false end end,
									order = 20,
									args = {
										framestrata = {
											type = "select",
											name = L["Strata"],
											get = function(info) 
												for k_ts,v_ts in pairs(table_Strata) do
													if v_ts == db.framelevel.strata then return k_ts end
												end
											end,
											set = function(info, value)
												db.framelevel.strata = table_Strata[value]
												nibMicroMenu:Refresh();
											end,
											style = "dropdown",
											width = nil,
											values = table_Strata_L,
											order = 10,
										},
										level = {
											type = "range",
											name = L["Level"],
											min = 1, max = 50, step = 1,
											get = function(info) return db.framelevel.level end,
											set = function(info, value) 
												db.framelevel.level = value
												nibMicroMenu:Refresh();
											end,
											order = 20,
										},
									},
								},
							},
						},
						alignment = {
							name = L["Alignment"],
							type = "group",
							order = 30,
							args = {
								orientation = {
									type = "select",
									name = L["Orientation"],
									get = function(info) 
										for k,v in pairs(table_Orientation) do
											if v == db.position.orientation then return k end
										end
									end,
									set = function(info, value)
										db.position.orientation = table_Orientation[value]
										nibMicroMenu:Refresh()
									end,
									style = "dropdown",
									width = nil,
									values = table_Orientation_L,
									order = 10,
								},
								reversed = {
									name = L["Reversed"],
									type = "toggle",
									get = function(info) return db.position.reversed end,
									set = function(info, value) db.position.reversed = value; nibMicroMenu:Refresh(); end,
									order = 20,
								},		
							},
						},
					},
				},
				microadjustments = {
					type = "group",
					name = L["Micro Adjustments"],
					childGroups = "tab",
					order = 30,
					args = {
						global = {
							type = "group",
							name = L["Global"],
							order = 10,
							args = {
								xoffset = {
									type = "input",
									name = L["Text X Offset"],
									order = 10,
									get = function(info) return tostring(db.microadjustments.x) end,
									set = function(info, value)
										value = ValidateOffset(value)
										db.microadjustments.x = value
										nibMicroMenu:Refresh()
									end,
								},
								yoffset = {
									type = "input",
									name = L["Text Y Offset"],
									order = 20,
									get = function(info) return tostring(db.microadjustments.y) end,
									set = function(info, value)
										value = ValidateOffset(value)
										db.microadjustments.y = value
										nibMicroMenu:Refresh()
									end,
								},
								width = {
									type = "range",
									name = L["Button Width (+/-)"],
									min = -32,
									max = 32,
									step = 1,
									get = function(info) return db.microadjustments.width end,
									set = function(info, value) db.microadjustments.width = value; nibMicroMenu:Refresh(); end,
									order = 30,
								},
								height = {
									type = "range",
									name = L["Button Height (+/-)"],
									min = -32,
									max = 32,
									step = 1,
									get = function(info) return db.microadjustments.height end,
									set = function(info, value) db.microadjustments.height = value; nibMicroMenu:Refresh(); end,
									order = 40,
								},
							},
						},
						individual = {
							type = "group",
							name = L["Individual Buttons"],
							childGroups = "list",
							order = 20,
							args = {},
						},
					},
				},
				tooltip = {
					type = "group",
					name = L["Tooltip"],
					order = 40,
					args = {
						showtooltip = {
							name = L["Show Tooltip"],
							type = "toggle",
							get = function(info) return db.tooltip.enabled end,
							set = function(info, value) db.tooltip.enabled = value; end,
							order = 10,
						},
					},
				},
				styles = {
					type = "group",
					name = L["Styles"],
					childGroups = "tab",
					order = 50,
					args = {
						normalstyle = {
							type = "group",
							name = L["Normal"],
							order = 10,
							childGroups = "tab",
							args = {
								textcolor = {
									type = "group",
									name = L["Text Color"],
									order = 10,
									args = {
										color = {
											type = "color",
											name = L["Color"],
											hasAlpha = false,
											get = function(info,r,g,b)
												return db.normal.colors.r, db.normal.colors.g, db.normal.colors.b
											end,
											set = function(info,r,g,b)
												db.normal.colors.r = r
												db.normal.colors.g = g
												db.normal.colors.b = b
												nibMicroMenu:UpdateButtons()
											end,
											disabled = function()
												if db.normal.colors.class.enabled then return true else return false; end 
											end,
											order = 10,
										},
										classcolor_area = {
											type = "group",
											name = L["Class Color"],
											inline = true,
											order = 20,
											args = {			
												useclasscolor = {
													name = L["Use Class Color"],
													type = "toggle",
													get = function(info) return db.normal.colors.class.enabled end,
													set = function(info, value) db.normal.colors.class.enabled = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,
												},											
												classshade = {
													name = L["Shade"],
													type = "range",
													min = 0,
													max = 1,
													step = 0.05,
													isPercent = true,
													get = function(info) return db.normal.colors.class.shade end,
													set = function(info, value) db.normal.colors.class.shade = value; nibMicroMenu:UpdateButtons(); end,
													disabled = function() if db.normal.colors.class.enabled then return false else return true end end,
													order = 20,
												},
											},
										},
									},
								},
								fontstyle = {
									type = "group",
									name = L["Font Style"],
									order = 20,
									args = {
										shadow_area = {
											name = L["Shadow"],
											type = "group",
											inline = true,
											order = 10,
											args = {
												useshadow = {
													name = L["Enabled"],
													type = "toggle",
													get = function(info) return db.normal.shadow.useshadow end,
													set = function(info, value) db.normal.shadow.useshadow = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,							
												},
												offsets = {
													name = L["Position"],
													type = "group",
													inline = true,
													disabled = function() if db.normal.shadow.useshadow then return false else return true end end,
													order = 20,
													args = {
														shadowx = {
															type = "range",
															name = L["X"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.normal.shadow.position.x end,
															set = function(info, value) db.normal.shadow.position.x = value; nibMicroMenu:UpdateButtons(); end,
															order = 10,
														},
														shadowy = {
															type = "range",
															name = L["Y"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.normal.shadow.position.y end,
															set = function(info, value) db.normal.shadow.position.y = value; nibMicroMenu:UpdateButtons(); end,
															order = 20,
														},
													},
												},
												color = {
													name = L["Color"],
													type = "color",
													hasAlpha = true,
													get = function(info,r,g,b,a)
														return db.normal.shadow.color.r, db.normal.shadow.color.g, db.normal.shadow.color.b, db.normal.shadow.color.a
													end,
													set = function(info,r,g,b,a)
														db.normal.shadow.color.r = r
														db.normal.shadow.color.g = g
														db.normal.shadow.color.b = b
														db.normal.shadow.color.a = a
														nibMicroMenu:UpdateButtons()
													end,
													disabled = function() if db.normal.shadow.useshadow then return false else return true end end,
													order = 30,
												},
											},
										},
										outline = {
											type = "group",
											name = L["Outline"],
											inline = true,
											order = 20,
											args = {
												style = {
													type = "select",
													name = L["Style"],
													values = table_Outline_L,
													get = function()
														for k,v in pairs(table_Outline) do
															if v == db.normal.outline then return k end
														end
													end,
													set = function(info, value)
														db.normal.outline = table_Outline[value]
														nibMicroMenu:UpdateButtons()
													end,
													order = 10,
												},
											},
										},
									},
								},						
								opacity = {
									type = "group",
									name = L["Opacity"],
									order = 30,
									args = {
										opacity = {
											type = "range",
											name = L["Opacity"],
											min = 0,
											max = 1,
											step = 0.05,
											isPercent = true,
											get = function(info) return db.normal.opacity end,
											set = function(info, value) db.normal.opacity = value; nibMicroMenu:UpdateButtons(); end,
											order = 10,
										},
									},
								},
							},
						},
						highlightstyle = {
							type = "group",
							name = L["Highlight"],
							order = 20,
							childGroups = "tab",
							args = {
								textcolor = {
									type = "group",
									name = L["Text Color"],
									order = 10,
									args = {
										color = {
											type = "color",
											name = L["Color"],
											hasAlpha = false,
											get = function(info,r,g,b)
												return db.highlight.colors.r, db.highlight.colors.g, db.highlight.colors.b
											end,
											set = function(info,r,g,b)
												db.highlight.colors.r = r
												db.highlight.colors.g = g
												db.highlight.colors.b = b
												nibMicroMenu:UpdateButtons()
											end,
											disabled = function()
												if db.highlight.colors.class.enabled then return true else return false; end 
											end,
											order = 10,
										},
										classcolor_area = {
											type = "group",
											name = L["Class Color"],
											inline = true,
											order = 20,
											args = {			
												useclasscolor = {
													name = L["Use Class Color"],
													type = "toggle",
													get = function(info) return db.highlight.colors.class.enabled end,
													set = function(info, value) db.highlight.colors.class.enabled = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,
												},											
												classshade = {
													name = L["Shade"],
													type = "range",
													desc = "Adjust how dark the Class Color will appear.",
													min = 0,
													max = 1,
													step = 0.05,
													isPercent = true,
													get = function(info) return db.highlight.colors.class.shade end,
													set = function(info, value) db.highlight.colors.class.shade = value; nibMicroMenu:UpdateButtons(); end,
													disabled = function() if db.highlight.colors.class.enabled then return false else return true end end,
													order = 20,
												},
											},
										},
									},
								},
								fontstyle = {
									type = "group",
									name = L["Font Style"],
									order = 20,
									args = {
										shadow_area = {
											name = L["Shadow"],
											type = "group",
											inline = true,
											order = 10,
											args = {
												useshadow = {
													name = L["Enabled"],
													type = "toggle",
													get = function(info) return db.highlight.shadow.useshadow end,
													set = function(info, value) db.highlight.shadow.useshadow = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,							
												},
												offsets = {
													name = L["Position"],
													type = "group",
													inline = true,
													disabled = function() if db.highlight.shadow.useshadow then return false else return true end end,
													order = 20,
													args = {
														shadowx = {
															type = "range",
															name = L["X"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.highlight.shadow.position.x end,
															set = function(info, value) db.highlight.shadow.position.x = value; nibMicroMenu:UpdateButtons(); end,
															order = 10,
														},
														shadowy = {
															type = "range",
															name = L["Y"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.highlight.shadow.position.y end,
															set = function(info, value) db.highlight.shadow.position.y = value; nibMicroMenu:UpdateButtons(); end,
															order = 20,
														},
													},
												},
												color = {
													name = L["Color"],
													type = "color",
													hasAlpha = true,
													get = function(info,r,g,b,a)
														return db.highlight.shadow.color.r, db.highlight.shadow.color.g, db.highlight.shadow.color.b, db.highlight.shadow.color.a
													end,
													set = function(info,r,g,b,a)
														db.highlight.shadow.color.r = r
														db.highlight.shadow.color.g = g
														db.highlight.shadow.color.b = b
														db.highlight.shadow.color.a = a
														nibMicroMenu:UpdateButtons()
													end,
													disabled = function() if db.highlight.shadow.useshadow then return false else return true end end,
													order = 30,
												},
											},
										},
										outline = {
											type = "group",
											name = L["Outline"],
											inline = true,
											order = 20,
											args = {
												style = {
													type = "select",
													name = L["Style"],
													values = table_Outline_L,
													get = function()
														for k,v in pairs(table_Outline) do
															if v == db.highlight.outline then return k end
														end
													end,
													set = function(info, value)
														db.highlight.outline = table_Outline[value]
														nibMicroMenu:UpdateButtons()
													end,
													order = 10,
												},
											},
										},
									},
								},						
								opacity = {
									type = "group",
									name = L["Opacity"],
									order = 30,
									args = {
										opacity = {
											type = "range",
											name = L["Opacity"],
											min = 0,
											max = 1,
											step = 0.05,
											isPercent = true,
											get = function(info) return db.highlight.opacity end,
											set = function(info, value) db.highlight.opacity = value; nibMicroMenu:UpdateButtons(); end,
											order = 10,
										},
									},
								},
							},
						},
						disabledstyle = {
							type = "group",
							name = L["Disabled"],
							order = 30,
							childGroups = "tab",
							args = {
								textcolor = {
									type = "group",
									name = L["Text Color"],
									order = 10,
									args = {
										color = {
											type = "color",
											name = L["Color"],
											hasAlpha = false,
											get = function(info,r,g,b)
												return db.disabled.colors.r, db.disabled.colors.g, db.disabled.colors.b
											end,
											set = function(info,r,g,b)
												db.disabled.colors.r = r
												db.disabled.colors.g = g
												db.disabled.colors.b = b
												nibMicroMenu:UpdateButtons()
											end,
											disabled = function()
												if db.disabled.colors.class.enabled then return true else return false; end 
											end,
											order = 10,
										},
										classcolor_area = {
											type = "group",
											name = L["Class Color"],
											inline = true,
											order = 20,
											args = {			
												useclasscolor = {
													name = L["Use Class Color"],
													type = "toggle",
													get = function(info) return db.disabled.colors.class.enabled end,
													set = function(info, value) db.disabled.colors.class.enabled = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,
												},											
												classshade = {
													name = L["Shade"],
													type = "range",
													desc = "Adjust how dark the Class Color will appear.",
													min = 0,
													max = 1,
													step = 0.05,
													isPercent = true,
													get = function(info) return db.disabled.colors.class.shade end,
													set = function(info, value) db.disabled.colors.class.shade = value; nibMicroMenu:UpdateButtons(); end,
													disabled = function() if db.disabled.colors.class.enabled then return false else return true end end,
													order = 20,
												},
											},
										},
									},
								},
								fontstyle = {
									type = "group",
									name = L["Font Style"],
									order = 20,
									args = {
										shadow_area = {
											name = L["Shadow"],
											type = "group",
											inline = true,
											order = 10,
											args = {
												useshadow = {
													name = L["Enabled"],
													type = "toggle",
													get = function(info) return db.disabled.shadow.useshadow end,
													set = function(info, value) db.disabled.shadow.useshadow = value; nibMicroMenu:UpdateButtons(); end,
													order = 10,							
												},
												offsets = {
													name = L["Position"],
													type = "group",
													inline = true,
													disabled = function() if db.disabled.shadow.useshadow then return false else return true end end,
													order = 20,
													args = {
														shadowx = {
															type = "range",
															name = L["X"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.disabled.shadow.position.x end,
															set = function(info, value) db.disabled.shadow.position.x = value; nibMicroMenu:UpdateButtons(); end,
															order = 10,
														},
														shadowy = {
															type = "range",
															name = L["Y"],
															min = -8,
															max = 8,
															step = 1,
															get = function(info) return db.disabled.shadow.position.y end,
															set = function(info, value) db.disabled.shadow.position.y = value; nibMicroMenu:UpdateButtons(); end,
															order = 20,
														},
													},
												},
												color = {
													name = L["Color"],
													type = "color",
													hasAlpha = true,
													get = function(info,r,g,b,a)
														return db.disabled.shadow.color.r, db.disabled.shadow.color.g, db.disabled.shadow.color.b, db.disabled.shadow.color.a
													end,
													set = function(info,r,g,b,a)
														db.disabled.shadow.color.r = r
														db.disabled.shadow.color.g = g
														db.disabled.shadow.color.b = b
														db.disabled.shadow.color.a = a
														nibMicroMenu:UpdateButtons()
													end,
													disabled = function() if db.disabled.shadow.useshadow then return false else return true end end,
													order = 30,
												},
											},
										},
										outline = {
											type = "group",
											name = L["Outline"],
											inline = true,
											order = 20,
											args = {
												style = {
													type = "select",
													name = L["Style"],
													values = table_Outline_L,
													get = function()
														for k,v in pairs(table_Outline) do
															if v == db.disabled.outline then return k end
														end
													end,
													set = function(info, value)
														db.disabled.outline = table_Outline[value]
														nibMicroMenu:UpdateButtons()
													end,
													order = 10,
												},
											},
										},
									},
								},						
								opacity = {
									type = "group",
									name = L["Opacity"],
									order = 30,
									args = {
										opacity = {
											type = "range",
											name = L["Opacity"],
											min = 0,
											max = 1,
											step = 0.05,
											isPercent = true,
											get = function(info) return db.disabled.opacity end,
											set = function(info, value) db.disabled.opacity = value; nibMicroMenu:UpdateButtons(); end,
											order = 10,
										},
									},
								},
							},
						},
					},
				},
			},
		}
		
		-- Text Options
		wipe(TextOpts)
		for k,v in ipairs(ButtonNames_L) do
			local BID = string.format("%s %s", "button", k)
			TextOpts[BID] = {
				type = "input",
				name = ButtonNames_L[k],
				width = "half",
				order = Opts_TextOrderCnt,
				get = function(info) return db.texts[k] end,
				set = function(info, value)	db.texts[k] = value; nibMicroMenu:Refresh(); end,
			}
			Opts_TextOrderCnt = Opts_TextOrderCnt + 10
		end
		
		-- Fill out new Texts table
		for k, v in pairs(TextOpts) do
			options.args.textsfont.args.buttontexts.args[k] = (type(v) == "function") and v() or v
		end
		
		-- Micro Adjustment Options
		wipe(MicroOpts)
		for k,v in ipairs(ButtonNames_L) do
			local BID = string.format("%s %s", "button", k)
			MicroOpts[BID] = {
				type = "group",
				name = ButtonNames_L[k],
				order = Opts_MicroOrderCnt,
				args = {
					xoffset = {
						type = "input",
						name = "Text X Offset",
						order = 10,
						get = function(info) return tostring(db.microadjustments.individual[k].x) end,
						set = function(info, value)
							value = ValidateOffset(value)
							db.microadjustments.individual[k].x = value
							nibMicroMenu:Refresh()
						end,
					},
					yoffset = {
						type = "input",
						name = "Text Y Offset",
						order = 20,
						get = function(info) return tostring(db.microadjustments.individual[k].y) end,
						set = function(info, value)
							value = ValidateOffset(value)
							db.microadjustments.individual[k].y = value
							nibMicroMenu:Refresh()
						end,
					},
					width = {
						type = "range",
						name = "Button Width (+/-)",
						min = -32,
						max = 32,
						step = 1,
						get = function(info) return db.microadjustments.individual[k].width end,
						set = function(info, value) db.microadjustments.individual[k].width = value; nibMicroMenu:Refresh(); end,
						order = 30,
					},
				},
			}
			Opts_MicroOrderCnt = Opts_MicroOrderCnt + 10
		end
		
		-- Fill out new Texts table
		for k, v in pairs(MicroOpts) do
			options.args.microadjustments.args.individual.args[k] = (type(v) == "function") and v() or v
		end
	end
	return options
end

-- Add a small panel to the Interface - Addons options
local intoptions = nil
local function GetIntOptions()
	if not intoptions then
		intoptions = {
			name = "nibMicroMenu",
			handler = nibMicroMenu,
			type = "group",
			args = {
				note = {
					type = "description",
					name = "You can access the nibMicroMenu options by typing: /nibmm",
					order = 10,
				},
				openoptions = {
					type = "execute",
					name = "Open config...",
					func = function()
						InterfaceOptionsFrame_Show()
						nibMicroMenu:OpenOptions()
					end,
					order = 20,
				},
			},
		}
	end
	return intoptions
end

function nibMicroMenu:OpenOptions()
	if not options then nibMicroMenu:SetUpOptions() end
	LibStub("AceConfigDialog-3.0"):Open("nibMicroMenu")
end

function nibMicroMenu:ChatCommand(input)
	nibMicroMenu:OpenOptions()
end

function nibMicroMenu:ConfigRefresh()
	db = self.db.profile
end

function nibMicroMenu:SetUpInitialOptions()
	-- Chat commands
	self:RegisterChatCommand("nibmicromenu", "ChatCommand")
	self:RegisterChatCommand("nibmm", "ChatCommand")
	
	-- Interface panel options
	LibStub("AceConfig-3.0"):RegisterOptionsTable("nibMicroMenu-Int", GetIntOptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("nibMicroMenu-Int", "nibMicroMenu")
end

function nibMicroMenu:SetUpOptions()
	db = self.db.profile

	GetOptions()
	
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.order = 10000
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("nibMicroMenu", options)
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("nibMicroMenu", 700, 500)
end