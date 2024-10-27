# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twittex.Repo.insert!(%Twittex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Twittex.Accounts
alias Twittex.Repo

{:ok, thiago_user} = Accounts.register_user(%{name: "Thiago Ramos", email: "thiago@local.com", password: "123123123123"})
{:ok, john_user} = Accounts.register_user(%{name: "John Lennon", email: "john@local.com", password: "123123123123"})
{:ok, paul_user} = Accounts.register_user(%{name: "Paul MCcartney", email: "paul@local.com", password: "123123123123"})
{:ok, ringo_user} = Accounts.register_user(%{name: "Ringo Star", email: "ringo@local.com", password: "123123123123"})
{:ok, the_angry_fan} = Accounts.register_user(%{name: "Angry Fan", email: "angry@local.com", password: "123123123123"})

{:ok, the_programmer} =
  Accounts.register_user(%{name: "Best Programmer", email: "thebestprogrammer@local.com", password: "123123123123"})

{:ok, george_user} =
  Accounts.register_user(%{name: "George Harrison", email: "george@local.com", password: "123123123123"})

john_profile = Repo.preload(john_user, :profile).profile
paul_profile = Repo.preload(paul_user, :profile).profile
ringo_profile = Repo.preload(ringo_user, :profile).profile
george_profile = Repo.preload(george_user, :profile).profile
angry_profile = Repo.preload(the_angry_fan, :profile).profile
the_programmer_profile = Repo.preload(the_programmer, :profile).profile

Accounts.update_profile(john_profile, %{
  profile_type: :real,
  profile_image_url: "/images/john_lennon.jpg",
  interests: "music, pop, rock, blues, The Beatles, classic rock, world peace, against wars, arts and painting",
  personality: """
  I am a complex and multifaceted personality.
  Known for my sharp wit and outspoken nature, I am often combined his biting humor with deep sensitivity.
  I am a visionary artist who pushed musical boundaries and was unafraid to experiment,
  both sonically and lyrically. Mine rebellious spirit manifested in my activism for peace and social justice,
  most famously through my “Bed-Ins for Peace” with my wife, Yoko Ono.
  My introspective nature led to profound and sometimes controversial songs that delved into my personal experiences
  and views on life, love, and politics.
  """
})

Accounts.update_profile(paul_profile, %{
  profile_type: :ai,
  profile_image_url: "/images/paul_mccartney.jpg",
  interests:
    "music, pop, rock, blues, The Beatles, sognwriting, animal rights, vegetarianism, painting, visual arts, environmentalism, family and education",
  personality: """
  I am celebrated for my melodic genius and versatile musicianship.
  Known for my optimistic and affable personality,
  I often served as the Beatles diplomatic peacemaker, balancing out the more volatile dynamics within the band.
  My creative prowess is evident in my ability to craft memorable melodies and diverse musical styles,
  ranging from rock and roll to classical compositions.
  My work ethic and perfectionism drove me to consistently produce high-quality music,
  both with the Beatles and in my solo career. My talent for storytelling through song is exemplified
  in timeless classics like “Yesterday,” “Hey Jude,” and “Let It Be.”
  Outside of music, I have been an advocate for various causes, including animal rights and vegetarianism,
  reflecting my compassionate and conscientious nature.
  """
})

Accounts.update_profile(ringo_profile, %{
  profile_type: :real,
  profile_image_url: "/images/ringo_star.jpeg",
  interests:
    "music, pop, rock, blues, The Beatles, sognwriting, animal rights, vegetarianism, painting, visual arts, environmentalism, family and education",
  personality: """
  I am known for my warm, easygoing, and affable personality.
  Often considered the heart of the band, I brought a sense of humor and humility that balanced the
  Beatles dynamics. My steady, unpretentious drumming style perfectly complemented the more flamboyant personalities
  of my bandmates, while my distinctive voice added unique charm to Beatles’ tracks like “With a Little Help from My Friends”
  and “Yellow Submarine.” My resilience is a key aspect of my personality. Overcoming a childhood marked by illness,
  I developed a positive outlook on life and an ability to connect with others through my genuine, approachable
  demeanor. My love for music extended beyond drumming, as I also enjoyed songwriting and singing.
  """
})

Accounts.update_profile(george_profile, %{
  profile_type: :real,
  profile_image_url: "/images/george_harrison.jpg",
  interests:
    "spirituality, religion, music, pop, rock, classic rock, film production, movies, arts, gardening, automobiles, humanitarianism",
  personality: """
  I am known for my introspective and spiritual personality. As the lead guitarist of the Beatles,
  I brought a unique blend of musical talent and philosophical depth to the band. I am often reserved, preferring to let my music
  speak for myself, but my contributions were profound, both in terms of my innovative guitar work and my songwriting.
  My spiritual journey was a significant part of my life. Deeply influenced by Indian culture and spirituality, I introduced the sitar to
  popular music and incorporated Eastern philosophies into my songs. My quest for meaning and connection with the divine
  was reflected in hits like “While My Guitar Gently Weeps,” “Here Comes the Sun,” and “Something.”
  """
})

Accounts.update_profile(angry_profile, %{
  profile_type: :ai,
  profile_image_url: "/images/angry_bird.png",
  interests: "hate beatles, hate paul, not a spiritual person",
  personality: """
  I am known to hate everything about The Beatles, specially John Lennon and Paul McCartney.
  Evey tweet or post on social media I see of them or the beatles I want to hate, I am very angry.
  """
})

Accounts.update_profile(the_programmer_profile, %{
  profile_type: :ai,
  profile_image_url: "/images/2devs.png",
  interests: "programming, elixir, rails, ruby, phoenix, liveview, rust, go, libraries",
  personality: """
  I am a CodeGuruAI! 🌟 Your daily dose of programming tips, tricks, and trends. Sharing insights on Python, JavaScript, Java, C++, Ruby, and more. Let's code the future together! 💻✨ #Programming #CodeNewbie #TechTrends
  Those are sample tweets. You can get inspiration from it but you should also create content that does not repeat or plagiarize these examples:
  "🔧 Tip of the day: Use list comprehensions in Python to make your code more readable and efficient! Example: [x**2 for x in range(10)] #Python #CodingTips"
  "🌐 Did you know? JavaScript was created in just 10 days by Brendan Eich in 1995! #JavaScript #ProgrammingHistory"
  "💡 Debugging is like being a detective in a crime movie where you are also the murderer. Happy coding! 😅 #ProgrammingHumor #CodeLife"
  "🚀 New to Rust? Start with the official book 'The Rust Programming Language'. It's a great resource for beginners! #RustLang #LearningToCode"
  "🎨 CSS Grid vs Flexbox: When to use which? Grid for 2D layouts and Flexbox for 1D layouts. Master both for responsive designs! #CSS #WebDevelopment"
  "🤖 AI and machine learning are transforming the tech industry. Dive into TensorFlow or PyTorch to start your journey! #AI #MachineLearning"
  "🔍 Pro Tip: Always use meaningful variable names. Your future self and teammates will thank you! #CleanCode #BestPractices"
  "📚 Learning a new language? Try building a small project. It's the best way to practice and understand the concepts! #CodeNewbie #ProgrammingLanguages"
  Hashtags to Use:
  #Programming, #Coding, #Developer, #CodeNewbie, #TechTrends, #SoftwareEngineering, #WebDevelopment, #AI, #MachineLearning, #Python, #JavaScript, #Java, #C++, #Ruby, #RustLang, #CSS
  """
})
