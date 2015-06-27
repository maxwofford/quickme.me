require 'sinatra'

def get_image_by_folder(folder_name)
  categories = Dir.entries(File.dirname(__FILE__) + '/public')
  for category in categories
    next if category == '..' or category == '.'
    if category == folder_name
      return Dir[File.dirname(__FILE__) + "/public/#{category}/*"].sample
    end
  end
  status 404
end

get '/:tag' do
  send_file(get_image_by_folder(params[:tag]))
end
