require 'sinatra'

def get_image_by_folder(query)
  categories = Dir.entries(File.dirname(__FILE__) + '/public')
  for category in categories
    next if category == '..' or category == '.'
    if query.include? category
      return Dir[File.dirname(__FILE__) + "/public/#{category}/*"].sample
    end
  end
  status 404
end

get '/:tag' do
  send_file(get_image_by_folder(params[:tag]))
end

def list_folders()
  categories = Dir.entries(File.dirname(__FILE__) + '/public')
  output = ''
  template = '<a href="/%s">%s</a>'
  for category in categories
    next if category == '..' or category == '.'
    output += template % [category,category]
  end
  output
end

get '/' do
  list_folders()
end
