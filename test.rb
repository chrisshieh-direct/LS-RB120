def santa(people)
  receivers = people.dup.shuffle
  hsh = {}

  people.each do |person|
    if receivers[0] == person
      transport = receivers.shift
      receivers << transport
    end
    hsh[person] = receivers[0]
    receivers.shift
  end
  hsh.each_with_object do |k, v, h|
    if k == v
      puts "ERROR"
      h[0], h[k] = h[k], h[0]
      p h
    end
  end
  hsh
end


a = ['Barney', 'Wilma', 'Fred', 'Pebbles', 'Bam Bam']

santa(a)
