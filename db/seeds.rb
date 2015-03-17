# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

drama = Category.create(name: "Drama")
comedy = Category.create(name: "Comedy")
suspense = Category.create(name: "Suspense")

stella = User.create(name: "Stella", email: "stella@gmail.com", password: "stellababy")
vik = User.create(name: "Vikram Swamy", email: "vswamy@gmail.com", password: "naynay")

Video.create(title: 'Monk', description: "Hampered by an odd variety of phobias and obsessive-compulsive tendencies that surfaced after his wife's murder, brilliant San Francisco police detective Adrian Monk (Tony Shalhoub) quits the force and begins working as a consultant on the SFPD's toughest cases. Monk's former superior, Capt. Stottlemeyer (Ted Levine), grudgingly calls on him for help but refuses to let the eccentric ex-cop rejoin the force.",
  small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: 'Futurama', description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.",
  small_cover_url: "/tmp/futurama.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)
Video.create(title: 'Breaking Bad', description: "A high school chemistry teacher dying of cancer teams with a former student to secure his family's future by manufacturing and selling crystal meth.",
  small_cover_url: "http://cdn0.nflximg.net/images/7300/4177300.jpg", large_cover_url: "http://cdn4.nflximg.net/webp/7884/4177884.webp", category: drama)
Video.create(title: 'Sherlock', description: "In this updated take on Arthur Conan Doyle's beloved mystery tales, the eccentric sleuth prowls the streets of modern-day London in search of clues.",
  small_cover_url: "http://cdn0.nflximg.net/images/7220/9747220.jpg", large_cover_url: "http://cdn2.nflximg.net/webp/7242/9747242.webp", category: suspense)
Video.create(title: "The West Wing", description: "This powerful political epic chronicles the triumphs and travails of White House senior staff under the administration of President Josiah Bartlet.",
  small_cover_url: "http://cdn2.nflximg.net/webp/1442/8501442.webp", large_cover_url: "http://cdn2.nflximg.net/webp/1142/8501142.webp", category: drama)
Video.create(title: "House of Cards", description: "A ruthless politician will stop at nothing to conquer Washington, D.C., in this Emmy and Golden Globe-winning political drama.",
  small_cover_url: "http://cdn0.nflximg.net/images/0152/12140152.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: drama)
Video.create(title: "Lost", description: "After their plane crashes on a deserted island, a diverse group of people must adapt to their new home and contend with the island's enigmatic forces.",
  small_cover_url: "http://cdn1.nflximg.net/images/4137/8384137.jpg", large_cover_url: "http://cdn8.nflximg.net/webp/3868/8383868.webp", category: drama)
Video.create(title: "The West Wing", description: "This powerful political epic chronicles the triumphs and travails of White House senior staff under the administration of President Josiah Bartlet.",
  small_cover_url: "http://cdn2.nflximg.net/webp/1442/8501442.webp", large_cover_url: "http://cdn2.nflximg.net/webp/1142/8501142.webp", category: drama)
Video.create(title: "House of Cards", description: "A ruthless politician will stop at nothing to conquer Washington, D.C., in this Emmy and Golden Globe-winning political drama.",
  small_cover_url: "http://cdn0.nflximg.net/images/0152/12140152.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: drama)
lost = Video.create(title: "Lost", description: "After their plane crashes on a deserted island, a diverse group of people must adapt to their new home and contend with the island's enigmatic forces.",
  small_cover_url: "http://cdn1.nflximg.net/images/4137/8384137.jpg", large_cover_url: "http://cdn8.nflximg.net/webp/3868/8383868.webp", category: drama)
bad = Video.create(title: 'Breaking Bad', description: "A high school chemistry teacher dying of cancer teams with a former student to secure his family's future by manufacturing and selling crystal meth.",
  small_cover_url: "http://cdn0.nflximg.net/images/7300/4177300.jpg", large_cover_url: "http://cdn4.nflximg.net/webp/7884/4177884.webp", category: drama)

Review.create(video: bad, user: stella, rating: 4, body: "Awesome performance by Bryan Cranston.")
Review.create(video: bad, user: vik, rating: 5, body: "My favorite show")
Review.create(video: lost, user: stella, rating: 4, body: "Terrible ending.")
Review.create(video: lost, user: vik, rating: 5, body: "Great storytelling.")
