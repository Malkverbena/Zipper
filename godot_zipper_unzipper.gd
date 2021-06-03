extends Node

export var files2compress : PoolStringArray
var compressed_file = "res://data.compress"


func zipper(files2compress : PoolStringArray):
	var matrix := {}
	var file = File.new()
	
	for i in files2compress:
		var err = file.open(i, File.READ)
		if err == OK:
			var file_length = file.get_len()
			var pre_content = file.get_buffer(file_length)
			var compressed_content = pre_content.compress(File.COMPRESSION_ZSTD)
			file.close()
			matrix[i] = [file_length, compressed_content]
		else:
			push_error("Fail trying to open the file: {file}".format({file = i}))
			get_tree().quit()
	file.open(compressed_file, File.WRITE)
	file.store_var(matrix)
	file.close()


func unzipper(path2file2decompress : String = compressed_file) -> void:
	var decompressed_files
	var file = File.new()
	
	var err = file.open(path2file2decompress, File.READ)
	file.close()
	if err != OK:
		push_error("Fail trying to open the compressed file: {file}".format({file = path2file2decompress}))
		get_tree().quit()

	var matrix = file.get_var()
	for i in matrix:
		var content = matrix[i][1].decompress(matrix[i][0], File.COMPRESSION_ZSTD)
		err = file.open(i, File.WRITE)
		if err != OK:
			file.close()
			push_error("Fail trying create file: {file}".format({file = i}))
			get_tree().quit()
		file.store_buffer(content)
		file.close()
