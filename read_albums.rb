#enumerations

module Genre
	POP, ALTERNATIVE, COUNTRY, KPOP = *1..4
end


#record definitions

class Playlist
	attr_accessor :tracks, :totaltracks
	def initialize(tracks,totaltracks)
		@tracks = tracks
		@totaltracks= totaltracks
	end
end

class Album
	attr_accessor :title, :artist,:year, :genre,:totaltracks, :tracks,:album_cover
	def initialize (title, artist,year,cover, genre,totaltracks,tracks)
		genre_names = ['Null', 'Pop', 'Alternative', 'Country', 'K-pop']
		@title = title
		@artist = artist
		@year= year
		@album_cover = cover
		@genre = genre_names[genre]
		@tracks = tracks
		@totaltracks = totaltracks
	end
end

class Track
	attr_accessor :name, :location,:num
	def initialize (name, location,num)
		@name = name
		@location = location
		@num = num
	end
end



#code for reading and printing albums
#reads in file and returns an array of albums
def read_albums(filename)
	music_file = File.new(filename, "r")
	album_count = music_file.gets().to_i()
	#create array to store the albums
	albums = Array.new()
	i = 0
	while i < album_count
		album = read_album(music_file)
		albums << album
		i+=1
	end
	music_file.close()
	return albums
end


# Reads in and returns a single album from the given file, with all its tracks
def read_album(music_file)
	album_title = music_file.gets.chomp.to_s()
	album_artist = music_file.gets.chomp.to_s()
	album_year = music_file.gets().to_i()
	album_cover = music_file.gets.chomp.to_s()
	album_genre = music_file.gets().to_i()
	total = music_file.gets().to_i()
	album_tracks = read_tracks(music_file,total)

	album = Album.new(album_title, album_artist,album_year,album_cover,album_genre,total, album_tracks)
	return album
end


# Returns an array of tracks read from the given file
def read_tracks(music_file,total)
	tracks = Array.new()

# while loop which increments an index to read the tracks
	i=0
	while i < total 
		track = read_track(music_file,i+1)
		tracks << track
		i+=1
	end
	return tracks
end

# Reads in and returns a single track from the given file
def read_track(music_file,num)
	track_name = music_file.gets()
	track_location = music_file.gets()
	track_num = num
	track = Track.new(track_name,track_location,track_num)
	return track
end

# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
	# print all the tracks use: tracks[x] to access each track.
	i = 0 
	while i < tracks.length
		print_track(tracks[i], i+1)
		i+=1
	end
end


# Takes a single track and prints it to the terminal
def print_track(track,tracknum)
	track.num = tracknum
	puts(track.num.to_s + ". "+ track.name.to_s)
	puts(track.location.to_s)
end


# Takes a single album and prints it to the terminal along with all its tracks
def print_album(album)
# print out all the albums fields/attributes
	puts("Album: " + album.title.to_s)
	puts("Artist: " + album.artist.to_s)
	puts("Year: " + album.year.to_s)
	puts("Genre: " + album.genre.to_s)
	puts("Number of tracks: " + album.totaltracks.to_s)
	puts(" ") #separates each block of album info
end

#outputs information about albums read to terminal
#used to check if textfile was read correctly
def display_info()
	i=0
	while i < @album_count
		print_album(@albums[i])
		i+=1
	end
end

#code for reading in playlists from playlist.txt and creates an array of playlists saved
def read_playlists()
	playlist_file = File.open("playlists.txt","r")
	@playlists = Array.new()

	file = File.open("playlists.txt")
	playlist_array = file.readlines.map(&:chomp)
	file.close()
	@totalplaylists = playlist_array.last.to_i

	i = 0
	while i < @totalplaylists 
		playlist = read_playlist(playlist_file) 	
		@playlists << playlist
		i+=1
	end
	playlist_file.close()
end

#reads in a playlist and returns it
def read_playlist(file)
	total = file.gets.to_i
	playlist_tracks = read_tracks(file,total)
	playlist = Playlist.new(playlist_tracks,total)
	return playlist
end



