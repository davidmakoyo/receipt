supported_tests = [
  {
    name: "Spotify Wrapped #1",
    slug: "spotify-wrapped-1",
    external_url: "",
    description: "Share your top Spotify Wrapped personality snapshot."
  },
  {
    name: "Animal in You",
    slug: "animal-in-you",
    external_url: "https://www.animalinyou.com/",
    description: "Discover your inner animal personality type."
  },
  {
    name: "Love Language",
    slug: "love-language",
    external_url: "https://5lovelanguages.com/quizzes/love-language",
    description: "Find your primary love language."
  },
  {
    name: "Hogwarts house",
    slug: "hogwarts-house",
    external_url: "https://www.harrypotter.com/news/discover-your-hogwarts-house-on-wizarding-world",
    description: "Get sorted into your Hogwarts house."
  },
  {
    name: "Political Compass",
    slug: "political-compass",
    external_url: "https://www.politicalcompass.org/test",
    description: "Map your political orientation."
  },
  {
    name: "Travel Style",
    slug: "travel-style",
    external_url: "https://myluggage.io/en/travel-personality-test",
    description: "Discover your travel personality and style."
  }
]

supported_tests.each do |attrs|
  test = SupportedTest.find_or_initialize_by(slug: attrs[:slug])
  test.update!(attrs)
end

SupportedTest.where.not(slug: supported_tests.map { |test| test[:slug] }).destroy_all
