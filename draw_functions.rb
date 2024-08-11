#all sub-draw functions are stored here

#draws background of music player
def draw_background()
	draw_quad(0, 0,Gosu::Color.argb(0x805298C7), 600,0 ,Gosu::Color.argb(0x805298C7),0,56,Gosu::Color.argb(0x805298C7), 600, 56,Gosu::Color.argb(0x805298C7), ZOrder::BACKGROUND)
	draw_quad(0,56,Gosu::Color::WHITE, 600,56, Gosu::Color::WHITE, 0,430,Gosu::Color::WHITE,600,430,Gosu::Color::WHITE)
end

#Draws a semi-transparent image on top of hovered album to create hovering effect
def draw_hover(hovered_area)
	if @page == 1 or @page == 2
		case hovered_area
		when 1  
			x=25
			y=81
		when 2
			x=200
			y=81
		when 3
			x=25
			y=256
		when 4
			x=200
			y=256
		when 5 #area for "create playlist"
			draw_rect(0,0,350,28,Gosu::Color.argb(0x807F7F7F),z=ZOrder::UI)
		when 6 #area for "my playlists"
			draw_rect(0,28,350,28,Gosu::Color.argb(0x807F7F7F),z=ZOrder::UI)
		when 
			x=0
			y=0
		end

		if x!=0 and hovered_area < 5
			draw_rect(x,y,150,150,Gosu::Color.argb(0x805298C7),z=ZOrder::UI)
		end
	end
end

# Draws the artwork on the screen for all the albums
def draw_albums(location,i,counter)
	pic = ArtWork.new(location)
	#albums passed in with an even 'i' value are placed in column 1 
	if (i%2) == 0
		x = 25
	#albums passed in with an odd 'i' value are placed in column 2 
	else
		x = 200
	end

	#counter is used to decide y coordinate of album cover 
	#3rd and fourth album passed to function will have a counter value of >2
	if counter < 2
		y = 81
	#therefore are placed in row 2
	else
		y = 256
	end
		
	pic.bmp.draw(x,y, ZOrder::PLAYER,scale_x=0.15,scale_y=0.15)
end


#draws the bar at the bottom of window which displays what song is currently being played
def song_bar()
	draw_rect(0,430,600,40,Gosu::Color.argb(0x805298C7),z=ZOrder::PLAYER)
	#if @song is empty, a song has not been chosen yet
	if !@song 
			@track_font.draw_text("No song playing",25, 440, ZOrder::PLAYER)
	else
		if @play
			@track_font.draw_text(@msg,25, 440, ZOrder::PLAYER)
		else
			@track_font.draw_text("Song paused",25, 440, ZOrder::PLAYER)
		end
	end
end 

#functions the same as draw_albums
def draw_playlist(i,counter)
	location = "images/playlist.png"
	pic = ArtWork.new(location)
	if (i%2) == 0
		x = 25
	else
		x = 200
	end

	if counter < 2
		y = 81
	else
		y = 256
	end
		
	pic.bmp.draw(x,y, ZOrder::PLAYER,scale_x=0.81,scale_y=0.862)
	@track_font.draw("Playlist #{i+1}",x+40,y+65,ZOrder::PLAYER)
end