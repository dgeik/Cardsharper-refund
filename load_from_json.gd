extends Node

func load_json(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path,FileAccess.READ)
		var result = JSON.parse_string(data_file.get_as_text())
		
		if result as Dictionary:
			return result
		else: print("Error read JSON")
	else: print("File is not exist")
