def remove_file_extension(file)
  return File.basename(file, File.extname(file))
end
