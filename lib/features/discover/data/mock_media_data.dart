import '../domain/media_item.dart';

const int mockMediaPageSize = 8;

final mockMediaItems = mockMediaSourceRows
    .map(MediaItem.fromTmdbJson)
    .toList(growable: false);

const mockMediaSourceRows = [
  {
    'id': 101,
    'media_type': 'movie',
    'title': 'Dune: Part Two',
    'overview':
        'Paul Atreides unites with Chani and the Fremen while seeking revenge '
        'against the conspirators who destroyed his family.',
    'release_date': '2024-02-27',
    'genre_names': ['Science Fiction', 'Adventure'],
    'vote_average': 8.2,
  },
  {
    'id': 102,
    'media_type': 'tv',
    'name': 'Shogun',
    'overview':
        'An English navigator, a powerful daimyo, and a translator become '
        'entangled in the political currents of feudal Japan.',
    'first_air_date': '2024-02-27',
    'genre_names': ['Drama', 'War & Politics'],
    'vote_average': 8.6,
  },
  {
    'id': 103,
    'media_type': 'tv',
    'name': 'The Bear',
    'overview':
        'A young chef from fine dining returns home to Chicago to run his '
        'family sandwich shop and rebuild the team around it.',
    'first_air_date': '2022-06-23',
    'genre_names': ['Drama', 'Comedy'],
    'vote_average': 8.3,
  },
  {
    'id': 104,
    'media_type': 'movie',
    'title': 'Past Lives',
    'overview':
        'Two deeply connected childhood friends are wrested apart, then '
        'reunited decades later for one fateful week in New York.',
    'release_date': '2023-06-02',
    'genre_names': ['Drama', 'Romance'],
    'vote_average': 7.8,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-past-lives-back/900/500',
  },
  {
    'id': 105,
    'media_type': 'tv',
    'name': 'Severance',
    'overview':
        'Employees at Lumon Industries undergo a procedure separating their '
        'work memories from their personal lives.',
    'first_air_date': '2022-02-18',
    'genre_names': ['Sci-Fi & Fantasy', 'Mystery'],
    'vote_average': 8.4,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-severance-back/900/500',
  },
  {
    'id': 106,
    'media_type': 'movie',
    'title': 'Oppenheimer',
    'overview':
        'The story of J. Robert Oppenheimer and the creation of the atomic '
        'bomb during the Manhattan Project.',
    'release_date': '2023-07-19',
    'genre_names': ['Drama', 'History'],
    'vote_average': 8.1,
    'backdropUrl':
        'https://picsum.photos/seed/watchshelf-oppenheimer-back/900/500',
  },
  {
    'id': 107,
    'media_type': 'movie',
    'title': 'Anatomy of a Fall',
    'overview':
        'A writer is put on trial after her husband dies under suspicious '
        'circumstances at their isolated chalet.',
    'release_date': '2023-08-23',
    'genre_names': ['Drama', 'Mystery', 'Crime'],
    'vote_average': 7.7,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-anatomy-back/900/500',
  },
  {
    'id': 108,
    'media_type': 'movie',
    'title': 'The Holdovers',
    'overview':
        'A curmudgeonly instructor stays on campus over winter break with a '
        'troubled student and the school cook.',
    'release_date': '2023-10-27',
    'genre_names': ['Comedy', 'Drama'],
    'vote_average': 7.7,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-holdovers-back/900/500',
  },
  {
    'id': 109,
    'media_type': 'movie',
    'title': 'Killers of the Flower Moon',
    'overview':
        'Members of the Osage Nation are murdered after oil is found beneath '
        'their land, drawing federal investigators into the case.',
    'release_date': '2023-10-18',
    'genre_names': ['Crime', 'Drama', 'History'],
    'vote_average': 7.5,
    'backdropUrl':
        'https://picsum.photos/seed/watchshelf-flower-moon-back/900/500',
  },
  {
    'id': 110,
    'media_type': 'movie',
    'title': 'Poor Things',
    'overview':
        'A young woman is brought back to life and travels across continents '
        'in search of experience and freedom.',
    'release_date': '2023-12-07',
    'genre_names': ['Science Fiction', 'Romance', 'Comedy'],
    'vote_average': 7.8,
    'cover_art_url':
        'https://picsum.photos/seed/watchshelf-poor-things/500/750',
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-poor-things-back/900/500',
  },
  {
    'id': 111,
    'media_type': 'movie',
    'title': 'Civil War',
    'overview':
        'Journalists travel through a fractured near-future America while '
        'documenting the collapse around them.',
    'release_date': '2024-04-10',
    'genre_names': ['War', 'Drama', 'Thriller'],
    'vote_average': 6.9,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-civil-war-back/900/500',
  },
  {
    'id': 112,
    'media_type': 'movie',
    'title': 'Challengers',
    'overview':
        'A tennis champion turned coach pushes her husband toward a tense '
        'match against his former best friend.',
    'release_date': '2024-04-18',
    'genre_names': ['Drama', 'Romance'],
    'vote_average': 7.1,
    'backdropUrl':
        'https://picsum.photos/seed/watchshelf-challengers-back/900/500',
  },
  {
    'id': 113,
    'media_type': 'movie',
    'title': 'Furiosa: A Mad Max Saga',
    'overview':
        'A young Furiosa is swept into a warlord empire and begins the long '
        'road toward finding her way home.',
    'release_date': '2024-05-22',
    'genre_names': ['Action', 'Adventure', 'Science Fiction'],
    'vote_average': 7.5,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-furiosa-back/900/500',
  },
  {
    'id': 114,
    'media_type': 'movie',
    'title': 'Inside Out 2',
    'overview':
        'Riley enters her teenage years and a new set of emotions arrives at '
        'Headquarters.',
    'release_date': '2024-06-11',
    'genre_names': ['Animation', 'Family', 'Comedy'],
    'vote_average': 7.6,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-inside-out-2-back/900/500',
  },
  {
    'id': 115,
    'media_type': 'tv',
    'name': 'Fallout',
    'overview':
        'A vault dweller steps into a chaotic wasteland where survival depends '
        'on alliances, luck, and dangerous discoveries.',
    'first_air_date': '2024-04-10',
    'genre_names': ['Sci-Fi & Fantasy', 'Action & Adventure'],
    'vote_average': 8.3,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-fallout-back/900/500',
  },
  {
    'id': 116,
    'media_type': 'tv',
    'name': 'The Last of Us',
    'overview':
        'A hardened survivor escorts a teenager across a devastated America '
        'after a fungal outbreak reshapes the world.',
    'first_air_date': '2023-01-15',
    'genre_names': ['Drama', 'Sci-Fi & Fantasy'],
    'vote_average': 8.6,
    'backdropUrl':
        'https://picsum.photos/seed/watchshelf-last-of-us-back/900/500',
  },
  {
    'id': 117,
    'media_type': 'tv',
    'name': 'Slow Horses',
    'overview':
        'A team of sidelined MI5 agents keeps stumbling into dangerous cases '
        'that more polished spies have missed.',
    'first_air_date': '2022-04-01',
    'genre_names': ['Crime', 'Drama', 'Comedy'],
    'vote_average': 8.2,
    'cover_art_url':
        'https://picsum.photos/seed/watchshelf-slow-horses/500/750',
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-slow-horses-back/900/500',
  },
  {
    'id': 118,
    'media_type': 'tv',
    'name': 'Silo',
    'overview':
        'Thousands live in a giant underground silo, where questions about the '
        'outside world become dangerous.',
    'first_air_date': '2023-05-05',
    'genre_names': ['Sci-Fi & Fantasy', 'Drama'],
    'vote_average': 8.1,
  },
  {
    'id': 119,
    'media_type': 'tv',
    'name': 'House of the Dragon',
    'overview':
        'The Targaryen dynasty begins to fracture as rival claims to the Iron '
        'Throne threaten to ignite civil war.',
    'first_air_date': '2022-08-21',
    'genre_names': ['Drama', 'Sci-Fi & Fantasy'],
    'vote_average': 8.4,
    'backdropUrl':
        'https://picsum.photos/seed/watchshelf-house-dragon-back/900/500',
  },
  {
    'id': 120,
    'media_type': 'tv',
    'name': 'Andor',
    'overview':
        'Cassian Andor is drawn into the earliest sparks of rebellion against '
        'the Empire.',
    'first_air_date': '2022-09-21',
    'genre_names': ['Sci-Fi & Fantasy', 'Drama'],
    'vote_average': 8.2,
  },
  {
    'id': 121,
    'media_type': 'tv',
    'name': 'The Penguin',
    'overview':
        'Oz Cobb maneuvers through Gotham City power struggles after the fall '
        'of a crime boss.',
    'first_air_date': '2024-09-19',
    'genre_names': ['Crime', 'Drama'],
    'vote_average': 8.0,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-penguin-back/900/500',
  },
  {
    'id': 122,
    'media_type': 'tv',
    'name': 'Ripley',
    'overview':
        'A grifter is hired to retrieve a wealthy man from Italy and discovers '
        'a darker path to reinvention.',
    'first_air_date': '2024-04-04',
    'genre_names': ['Drama', 'Crime'],
    'vote_average': 8.0,
  },
  {
    'id': 123,
    'media_type': 'tv',
    'name': 'Mr. & Mrs. Smith',
    'overview':
        'Two strangers join a spy agency and enter a cover marriage where '
        'missions and intimacy collide.',
    'first_air_date': '2024-02-01',
    'genre_names': ['Action & Adventure', 'Comedy', 'Drama'],
    'vote_average': 7.5,
  },
  {
    'id': 124,
    'media_type': 'tv',
    'name': 'Dark Matter',
    'overview':
        'A physicist is pulled into alternate versions of his life and races '
        'to return to his family.',
    'first_air_date': '2024-05-08',
    'genre_names': ['Sci-Fi & Fantasy', 'Drama', 'Mystery'],
    'vote_average': 7.8,
    'backdrop_url':
        'https://picsum.photos/seed/watchshelf-dark-matter-back/900/500',
  },
];
