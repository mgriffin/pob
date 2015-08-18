require 'flickraw'
require 'pp'

FlickRaw.api_key = ENV['FLICKR_API_KEY']
FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']
user_id = ENV['FLICKR_USER_ID']

flickr.access_token = ENV['FLICKR_ACCESS_TOKEN']
flickr.access_secret = ENV['FLICKR_ACCESS_SECRET']

photos = 'to_flickr/coppermile/*.jpg'

login = flickr.test.login

photo_ids = Array.new
Dir.glob(photos) do |photo|
  id = flickr.upload_photo(photo, :title => File.basename(photo))
  puts "#{photo} uploaded as #{id}"
  photo_ids << id
end

photoset = 'coppermile'
set = flickr.photosets.create(:title => photoset, :primary_photo_id => photo_ids.shift)
photo_ids.each do |id|
  flickr.photosets.addPhoto(:photoset_id => set.id, :photo_id => id)
  puts "Added #{id}"
end
