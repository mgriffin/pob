require 'date'
require 'flickraw'

FlickRaw.api_key = "***REMOVED***"
FlickRaw.shared_secret = "***REMOVED***"
user_id = "***REMOVED***"

flickr.access_token = ENV['FLICKR_ACCESS_TOKEN']
flickr.access_secret = ENV['FLICKR_ACCESS_SECRET']

login = flickr.test.login
list = flickr.photosets.getList(:user_id => user_id, :primary_photo_extras => 'url_q, date_taken')
list.each do |set|
  date = DateTime.parse(set.primary_photo_extras.datetaken)
  parsed = date.strftime("%Y-%m-%d")
  File.open("_albums/#{parsed}-#{set.id}.md", 'w') do |file|
    puts "Writing #{set.title} to #{file.path}"
    file.write "---\n"
    file.write "id: #{set.id}\n"
    file.write "title: #{set.title}\n"
    file.write "cover: #{set.primary_photo_extras.url_q}\n"
    file.write "date: #{set.primary_photo_extras.datetaken}\n"
    file.write "photos:\n"
    photos = flickr.photosets.getPhotos(:user_id => user_id, :photoset_id => set.id, :extras => 'url_q, url_o')
    photos.photo.each do |photo|
      file.write "  - thumbnail: #{photo.url_q}\n"
      file.write "    original: #{photo.url_o}\n"
      file.write "    title: #{photo.title}\n"
    end
    file.write "---"
  end
end
