require 'bundler/setup'
require 'google-search'
require 'pry'
require 'rubygems'
require 'sinatra'

# Methods
def get_file_by_folder(query)
  categories = Dir.entries(File.dirname(__FILE__) + '/public')
  for category in categories
    next if category == '..' or category == '.'
    if query.include? category
      return Dir[File.dirname(__FILE__) + "/public/#{category}/*"].sample
    end
  end
  return Dir[File.dirname(__FILE__) + "/public/not_found/*"].sample
end

def list_folders()
  categories = Dir.entries(File.dirname(__FILE__) + '/public')
  output = ''
  template = '<a href="/%s">%s</a>'
  for category in categories
    next if ['.', '..', 'not_found', 'robots.txt'].include? category
    unless output == ''
      output += ' '
    end
    output += template % [category, category]
  end
  output
end

def remote_file_is_image?(url)
  url = URI.parse(url)
  Net::HTTP.start(url.host, url.port) do |http|
    return http.head(url.request_uri)['Content-Type'].start_with? 'image'
  end
end

# Routes
get '/' do
  @folder_list = list_folders()
  haml :index
end

get '/:tag' do
  send_file(get_file_by_folder(params[:tag]))
end

get '/s/:tag' do
  results = []
  Google::Search::Image.new(query: params[:tag]).each do |image|
    results.push image.uri
  end
  image_url = results.sample
  if remote_file_is_image? image_url
    redirect image_url
  else
    send_file(get_file_by_folder(params[:tag]))
  end
end
