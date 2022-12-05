# define the frames for the animation
frames = [
  ["  O  ",
   " /|\\ ",
   "  |  ",
   " / \\ "],
  ["  O  ",
   " /|\\ ",
   "  |  ",
   " / \\ "],
  ["  O  ",
   " /|\\ ",
   " /|\\ ",
   " / \\ "],
  ["  O  ",
   " /|\\ ",
   " /|\\ ",
   " / \\ "]
]

# define a function to animate the ASCII man
def animate(frames)
  # print each frame in the animation
  frames.each do |frame|
    system "clear"
    frame.each do |row|
      puts row
    end
    puts
    sleep(0.5)
  end
end

# animate the ASCII man
animate(frames)
