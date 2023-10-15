# ========================================================
# 名称：Sty
# 类型：静态函数库
# 简介：用于解析和应用控件样式
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-07 23:11:57
# 最后修改时间：2023-08-07 23:11:57
# ========================================================
class_name Sty

# 样式解析
static func parse_style(ctl:Control,style_str:String):
	# 创建ConfigFile实例
	var cfg = ConfigFile.new()
	# 在解析前替换冒号和封号，使格式转为标准ConfigFile形式，从而保证被正确解析
	var err = cfg.parse(style_str.replace(":","=\"").replace(";","\""))
	if err == OK: # 解析成功
		# 遍历节和旗下的键
		for section in cfg.get_sections():
			for key in cfg.get_section_keys(section):
				var val = cfg.get_value(section,key) # 获取键的值
				# 根据键的名称分别处理
				match key:
					"font_size":
						pass
						
					# 根据节的名称更近一步进行细节处理
						match section:
							# 节名对应的是一种控件的交互或状态
							"normal":
								# 添加属性覆盖
								ctl.add_theme_color_override("font_color",Color(val))
							"hover","pressed","disabled","focus":
								ctl.add_theme_color_override("font_%s_color" % section,Color(val))
					"bg_color":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								stylebox.bg_color = Color(val)
					"radius":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.corner_radius_top_left = int(vals[0])
								stylebox.corner_radius_top_right = int(vals[1])
								stylebox.corner_radius_bottom_left = int(vals[2])
								stylebox.corner_radius_bottom_right = int(vals[3])
					"border_width":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.border_width_left = int(vals[0])
								stylebox.border_width_top = int(vals[1])
								stylebox.border_width_right = int(vals[2])
								stylebox.border_width_bottom = int(vals[3])
					"border_color":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								stylebox.border_color = Color(val)
					"padding":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.content_margin_left = int(vals[0])
								stylebox.content_margin_top = int(vals[1])
								stylebox.content_margin_right = int(vals[2])
								stylebox.content_margin_bottom = int(vals[3])
					"margin":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.expand_margin_left = int(vals[0])
								stylebox.expand_margin_top = int(vals[1])
								stylebox.expand_margin_right = int(vals[2])
								stylebox.expand_margin_bottom = int(vals[3])
					"shadow_color":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								stylebox.shadow_color = Color(val)
					"shadow_size":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								stylebox.shadow_size = int(val)
					"shadow_offset":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.shadow_offset = Vector2(float(vals[0]),float(vals[1]))
					"skew":
						match section:
							"normal","hover","pressed","disabled","focus":
								var stylebox:StyleBoxFlat = get_stylebox(ctl,section)
								var vals = val.split(",")
								stylebox.skew = Vector2(float(vals[0]),float(vals[1]))

# 获取控件对应名称的样式盒
static func get_stylebox(ctl:Control,name:String) -> StyleBoxFlat:
	var stylebox:StyleBoxFlat
	# 如果已经存在覆盖的样式盒
	if ctl.has_theme_stylebox_override(name):
		stylebox = ctl.get_theme_stylebox(name)
	else:
		# 创建一个新的样式盒 - 默认为StyleBoxFlat类型
		stylebox= StyleBoxFlat.new()
		# 添加为覆盖样式盒
		ctl.add_theme_stylebox_override(name, stylebox)
	return stylebox # 返回对样式盒的引用，以用于后续操作
