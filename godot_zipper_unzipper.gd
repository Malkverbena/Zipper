extends Node


var path2file = "res://files/data.txt"   # relative path
var file_len 
var path2zipfile = "res://files/data.zip"


func zipper(path2file):
	var file = File.new()
	file.open(path2file, File.READ)
	var _len = file.get_len()
#	print(file.get_len())
	var content = file.get_buffer(_len)
	content = content.compress(File.COMPRESSION_GZIP)
#	content.append_array(var2bytes(_len))
	file_len = var2bytes(_len)
	file.close()
	file.open("res://files/data.zip", File.WRITE)
	file.store_buffer(content)
	file.close()

	
	
func unzipper(path2zipfile, file_len):
	var file = File.new()
	file.open(path2zipfile, File.READ)
	var content = file.get_buffer(file.get_len())
	content = content.decompress(file_len, File.COMPRESSION_GZIP)
	file.close()
	file.open("res://files/data2.txt", File.WRITE)
	file.store_buffer(content)
	file.close()
