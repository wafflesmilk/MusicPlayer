require 'rubygems'
require 'gosu'
require './read_albums.rb'
require './draw_functions.rb'

#enumeration definition
module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

#record definitions 
class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 600, 465
	    self.caption = "Music Player"
		@track_font = Gosu::Font.new(18)
		@page = 1 #when program is first launched, it displays first page
		@menu_font = Gosu::Font.new(18) #used to draw "Create Playlists" and "My Playlists"
		@play = false #initially, @song is nil so @play should be false. needed to display msg on song_bar
		@playlist_tn = Array.new() #array for playlist track names
		@playlist_location = Array.new() #array for location of playlist tracks


		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		file = 'albums.txt'
		@albums = read_albums(file)
		music_file = File.new(file, "r")
		@album_count = music_file.gets().to_i()
		music_file.close()
		
		#checks if information has been read correctly
		#debug
		display_info()
		
	end


	# Detects if a 'track' area has been clicked on
	# if it is, playTrack is called which plays the track selected. 
	def track_clicked(mouse_x,mouse_y)
		case mouse_x
		#area where track is displayed
		when 375..600
			#default coordinate values of first track
			min =81
			max=103

			#if statement used to create variable a which allows this function to be used for both the playlists and albums pages
			if @page==1 or @page==2
				a =  @albums[@current_selected]
			elsif @page==3 or @page==4
				a =  @playlists[@current_selected]
			end
			track_count = a.totaltracks
			#first track
			if (mouse_y >=min and mouse_y<= max) 
				draw_rect(375,min,220,18,Gosu::Color.argb(0x800055ff),ZOrder::UI)
				if  Gosu.button_down? Gosu::MsLeft
					@selected = @current_selected
					if @option != "create"
						@msg = "Now playing: #{a.tracks[0].name}"
						playTrack(a.tracks[0].location.chomp)
					else
						@track_location =  "#{a.tracks[0].location.chomp}\n"
						@track_name = a.tracks[0].name
					end
					@current_selected_track_y = min # y coordinate for the selected background that will appear behind selected track
				end
			end

			if track_count>=2 #hover effect for 2nd track area will only be drawn if album has at least 2 tracks
				#min and max incremented to get coordinates of the next sensitive track area
				if (mouse_y >=(min+25) and mouse_y<= (max+25))
					draw_rect(375,(min+25),220,18,Gosu::Color.argb(0x800055ff),ZOrder::UI)
					if  Gosu.button_down? Gosu::MsLeft
						@selected = @current_selected
						if @option != "create" 
							@msg = "Now playing: #{a.tracks[1].name}"
							playTrack(a.tracks[1].location.chomp)
						else
							@track_location =  "#{a.tracks[1].location.chomp}\n"
							@track_name = a.tracks[1].name
						end
						@current_selected_track_y = min+25
					end
				end 
			end

			if track_count>=3 #hover effect for 3nd track area will only be drawn if album has at least 3 tracks
				if (mouse_y >=(min+(25*2)) and mouse_y<= (max+(25*2)))
					draw_rect(375,(min+(25*2)),220,18,Gosu::Color.argb(0x800055ff),ZOrder::UI)
					if  Gosu.button_down? Gosu::MsLeft
						@selected = @current_selected
						if @option != "create" 
							@msg = "Now playing: #{a.tracks[2].name}"
							playTrack(a.tracks[2].location.chomp)
						else
							@track_location =  "#{a.tracks[2].location.chomp}\n"
							@track_name = a.tracks[2].name
						end
						@current_selected_track_y = min+(25*2)
					end
				end
			end

			if track_count >=4 #hover effect for 4th track area will only be drawn if album has at least 4 tracks
				if (mouse_y >=(min+(25*3)) and mouse_y<= (max+(25*3)))
					draw_rect(375,(min+(25*3)),220,18,Gosu::Color.argb(0x800055ff),ZOrder::UI)
					if  Gosu.button_down? Gosu::MsLeft
						@selected = @current_selected
						if @option != "create"
							@msg = "Now playing: #{a.tracks[3].name}"
							playTrack(a.tracks[3].location.chomp)
						else
							@track_location =  "#{a.tracks[3].location.chomp}\n"
							@track_name = a.tracks[3].name
						end
						@current_selected_track_y = min+(25*3)
					
					end
				end
			end

			if track_count >=5 #hover effect for 5th track area will only be drawn if album has at least 5 tracks
				if (mouse_y >=(min+(25*4)) and mouse_y<= (max+(25*4)))
					draw_rect(375,(min+(25*4)),220,18,Gosu::Color.argb(0x800055ff),ZOrder::UI)
					if  Gosu.button_down? Gosu::MsLeft
						@selected = @current_selected
						@track_name = a.tracks[4].name
						if @option != "create"
							@msg = "Now playing: #{a.tracks[4].name}"
							playTrack(a.tracks[4].location.chomp)
						else
							@track_location =  "#{a.tracks[4].location.chomp}\n"
							@track_name = a.tracks[4].name
						end
						@current_selected_track_y = min+(25*4)
					end
				end
			end

		end
	end
	
	# Detects if a 'mouse sensitive' area has been clicked on
	#returns a specific value referencing to an album 
	def area_clicked(mouse_x,mouse_y)
		case mouse_x
		#column 1
		when 25..175 
			if (mouse_x>=25 and mouse_x<=130) #for the playlist options
				if (mouse_y>=8 and mouse_y<34)
					return 5
				elsif (mouse_y>=34 and mouse_y<=60)
					return 6
				end
			end
			if (mouse_y>=81 and mouse_y<=231) #album in column 1 row 1
				return 1
			elsif (mouse_y>=256 and mouse_y<=406) #album in column 1 row 2
				return 3 
			end
		#column 2
		when 200..350 
			if (mouse_y>=81 and mouse_y<=231) #album in column 2 row 1
				return 2
			elsif (mouse_y>=256 and mouse_y<=406) #album in column 2 row 2
				return 4 
			end	
		when 570..591 #area for back button
			if (mouse_y>=10 and mouse_y<=25)
				return 7 
			end
		end
	end

	# takes in album index and draws the album's list of tracks 
	def display_track(album)
		i = 0
		x = 380
		y= 81
		while i < album.totaltracks
			track = album.tracks[i].name
			@track_font.draw_text(track,x,y,ZOrder::PLAYER,scale_x = 1, scale_y = 1,Gosu::Color::BLACK)
			y+=25
			i+=1
		end 
	end

	#takes location of a track and plays it
	def playTrack(location)
			track_location = "music/" + location
			@song = Gosu::Song.new(track_location)
			@song.play(false)
			@play= true
	end

	#appends tracks to playlist.txt
	def create_playlist() 
		if File.zero?("playlists.txt")
			totalplaylists= 0 
		else
			file = File.open("playlists.txt")
			playlists = file.readlines.map(&:chomp) #gets each line from file and appends it to an array called 'playlists'
			totalplaylists = playlists.last.to_i #last line in file specifies the number of stored playlists 
		end
		File.delete("playlists.txt")
		
	
		new_file = File.open("playlists.txt","a+")
		if totalplaylists != 0 #copies old info into new file 
			i = 0
			#loop for copying old file content into new one, minus the number of playlists which was located on last line of file
			while i< (playlists.length-1)
				new_file.write("#{playlists[i]}\n")
				i+=1
			end
		end

		j= 0 
		new_file.write("#{@playlist_tn.length}\n") #number of tracks in playlist
		while j < @playlist_tn.length
			new_file.write(@playlist_tn[j])
			new_file.write(@playlist_location[j])
			j+=1
		end
		totalplaylists += 1
		new_file.write(totalplaylists)
		new_file.close()
		@option = "success"
	end


	# Not used? Everything depends on mouse actions.

	def update
	end

	# main draw function
	def draw
	
		draw_background()
		@menu_font.draw_text("Create Playlist",15,5,ZOrder::PLAYER)
		@menu_font.draw_text("My Playlists",15,33,ZOrder::PLAYER)
		song_bar()

		if @page == 1
			i=0
			while i < @album_count  - 4
				location ="images/" + @albums[i].album_cover
				draw_albums(location,i,i)
				i+=1
			end
		elsif @page == 2
			i =4
			while i < @album_count
				location ="images/" + @albums[i].album_cover
				draw_albums(location,i-4,i-4)
				i+=1
			end
		elsif @page == 3
			read_playlists()
			back_btn = ArtWork.new("images/back.png")
			back_btn.bmp.draw(565,12,ZOrder::PLAYER,0.05,0.05)
			i = 0
			while i < @totalplaylists
				draw_playlist(i,i)
				i+=1
			end
			if Gosu.button_down? Gosu::MsLeft #back button is pressed
				if (mouse_x>=565 and mouse_x<=592) and (mouse_y>=12 and mouse_y<=39)
					@page = 1
					@option = false
					@current_selected = false
					@current_selected_track_y = false
				end
			end
		elsif @page == 4
			i =4
			while i < @totalplaylists
				draw_playlist(i,i)
				i+=1
			end
		end

		draw_hover(area_clicked(mouse_x,mouse_y))

		if @current_selected
			#draws rectangle on currently selected album
			draw_rect(@x,@y,150,150,Gosu::Color.argb(0x905298C7),z=ZOrder::UI)
			if @page == 1 or @page==2
				display_track(@albums[@current_selected])
			elsif @page ==3 or @page ==4
				display_track(@playlists[@current_selected])
			end
			#checks which track area is clicked 
			track_clicked(mouse_x,mouse_y)

			#latter part of statement ensures the rectangle used to highlight the currently selected track does not highlight the same area when
			#another album has been selected but no track has been selected yet
			if @current_selected_track_y and @selected == @current_selected
				draw_rect(375,@current_selected_track_y,220,18,Gosu::Color.argb(0x800055ff),ZOrder::BACKGROUND)
			end
		end


		if @option == "create"
			if @page == 3 or @page == 4 #takes user back to main page if they are on playlist page
				@page =1
			end
			draw_rect(0,0,350,28,Gosu::Color.argb(0x807F7F7F),z=ZOrder::UI)
			@menu_font.draw("Select songs to add",400,20,ZOrder::PLAYER,1,1,Gosu::Color::RED)
			@menu_font.draw("Confirm",400,410,ZOrder::PLAYER,1,1,Gosu::Color::RED)
			@menu_font.draw("Cancel",500,410,ZOrder::PLAYER,1,1,Gosu::Color::RED)
			#only appends value to array if current @track_name is not the same as the previous one
			#needed since draw() is called several times per minute so this ensures duplicated values arent appended
			if @track_name != @playlist_tn.last 
				@playlist_tn << @track_name
				@playlist_location << @track_location
			end
			if (mouse_x>=400 and mouse_x<=458) and (mouse_y>=410 and mouse_y<=430)#if confirm is clicked
				if Gosu.button_down? Gosu::MsLeft
					create_playlist()
				end
			elsif (mouse_x>=500 and mouse_x<=552) and (mouse_y>=410 and mouse_y<=430) #if cancel is clicked
				if Gosu.button_down? Gosu::MsLeft
					@page = 1
					@option = false
				end
			end 

		elsif @option == "show"
			draw_rect(0,28,350,28,Gosu::Color.argb(0x807F7F7F),z=ZOrder::UI)
			if File.zero?("playlists.txt") #checks if file is empty 
				@menu_font.draw("No playlist found",400,20,ZOrder::PLAYER,1,1,Gosu::Color::RED) #empty file means no saved playlists
			else
				@page = 3
				
			end
		elsif @option == "success"
			@menu_font.draw("Playlist successfully created",350,20,ZOrder::PLAYER,1,1,Gosu::Color::GREEN)
		end
	end


	def needs_cursor?; true; end

	def button_down(id)
		case id
		#uses spacebar to pause and unpause song
		when Gosu::KbSpace
			if @song.playing?
				@song.pause
				@play = false
			else
				@song.play(false)
				@play = true
			end
		#s key is used to end the current song
		when Gosu::KbS 
			@song.stop
			@song = nil 
			@current_selected_track_y = false #track that was playing is no longer highlighted

		#scroll to next page
		when Gosu::MsWheelDown 
			if @page ==1
				@page = 2
				@current_selected = false
			end
			if @page ==3 and @totalplaylists > 4 #4th page only exists if there are more than 4 playlists
				@page = 4
				@current_selected = false
			end
		#scroll back to previous page
		when Gosu::MsWheelUp
			if @page==2
				@page =1
				@current_selected = false
			end
			if @page == 4
				@page = 3
				@current_selected = false
			end
		when Gosu::MsLeft
			if area_clicked(mouse_x,mouse_y) == 1  #column 1 row 1
				@x =25
				@y =81
				if @page == 1 or @page==3
					@current_selected = 0
				elsif @page == 2 or @page == 4
					@current_selected = 4
				end
				
			
			elsif area_clicked(mouse_x,mouse_y) == 2 #column 2 row 1
				@x =200
				@y =81
				if @page == 1
					@current_selected = 1
				elsif @page == 3 
					if @totalplaylists >=2 #selected effect only appears in that area when clicked if there are at least 2 playlists
						@current_selected = 1
					end
				elsif @page == 2 
					@current_selected = 5
				elsif @page == 4  
					if @totalplaylists >= 6 
						@current_selected = 5 
					end
				end
			
			elsif area_clicked(mouse_x,mouse_y) == 3 #column 1 row 2
				@x =25
				@y =256
				if @page ==1 
					@current_selected = 2
				elsif @page == 3 
					if @totalplaylists >=3
						@current_selected = 2
					end
				elsif @page == 2 
					@current_selected = 6
				elsif @page == 4 
					if @totalplaylists >= 7
						@current_selected = 6
					end
				end
				
			elsif area_clicked(mouse_x,mouse_y) == 4 #column 2 row 2
				@x =200
				@y =256
				if @page == 1
					@current_selected = 3
				elsif @page == 3 
					if @totalplaylists >=4
						@current_selected = 3
					end
				elsif @page == 2 
					@current_selected = 7
				elsif @page == 4 
					if @totalplaylists >=8
						@current_selected = 7
					end
				end
				
			elsif area_clicked(mouse_x,mouse_y) == 5
				@current_selected = false
				@current_selected_track_y = false
				@option = "create"
			elsif area_clicked(mouse_x,mouse_y) == 6
				@current_selected = false
				@current_selected_track_y = false
				@option = "show"
			end
		end
	end

end



# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
