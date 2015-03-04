# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Monk', description: "Hampered by an odd variety of phobias and obsessive-compulsive tendencies that surfaced after his wife's murder, brilliant San Francisco police detective Adrian Monk (Tony Shalhoub) quits the force and begins working as a consultant on the SFPD's toughest cases. Monk's former superior, Capt. Stottlemeyer (Ted Levine), grudgingly calls on him for help but refuses to let the eccentric ex-cop rejoin the force.",
  small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Futurama', description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.",
  small_cover_url: "/tmp/futuruma.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff")
Video.create(title: 'Breaking Bad', description: "A high school chemistry teacher dying of cancer teams with a former student to secure his family's future by manufacturing and selling crystal meth.",
  small_cover_url: "http://cdn0.nflximg.net/images/7300/4177300.jpg", large_cover_url: "http://cdn4.nflximg.net/webp/7884/4177884.webp")
Video.create(title: 'Sherlock', description: "In this updated take on Arthur Conan Doyle's beloved mystery tales, the eccentric sleuth prowls the streets of modern-day London in search of clues.",
  small_cover_url: "http://cdn0.nflximg.net/images/7220/9747220.jpg", large_cover_url: "http://cdn2.nflximg.net/webp/7242/9747242.webp")
