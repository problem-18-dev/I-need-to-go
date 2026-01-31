extends Node


func is_on_mobile() -> bool:
	return OS.has_feature("web_android") or OS.has_feature("web_ios")
