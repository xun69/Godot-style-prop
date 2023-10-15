@tool
extends Button

@export_multiline var style:String = "":
	set(val):
		style = val
		Sty.parse_style(self,val)
