# Crystal Snake

This is a [Battle Snake](https://play.battlesnake.com/) project written in [Crystal](https://crystal-lang.org/) using [Kemal](https://kemalcr.com/)

## Installation

The app uses [sam.cr](https://github.com/imdrasil/sam.cr) for ease of development.

```bash
# Install dependencies
shards install

# Start development server in port 8080 with live reload
make sam dev
```

## Development

For local development I use the [BattleSnake CLI](https://github.com/BattlesnakeOfficial/rules/tree/main/cli) with the local server running. A basic example looks like this:

```bash
battlesnake play -W 11 -H 11 --name dev --url http://localhost:8080 -g solo -v
```

## Usage / Architecture

I strongly recommend reading the docs in [fdocr.github.io/CrystalSnake/](fdocr.github.io/CrystalSnake/) because you can find detailed information about each class and method hosted there :)

#### Strategies

The server is built on the `src/app.cr` file and you can choose to use any of the available strategies ([list available here](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy)).

All strategies inherit from `Stategy::Base`, they are initialized with a `BattleSnake::Context` and you call `#move` method to chose a move to respond with.

With this interface you can create new strategies and even re-use them within each other. For example `Strategy::ChaseClosestFood` uses the `Strategy::RandomValid` strategy when reachable food doesn't exist on the board.

You can also use `Strategy::Utils` class methods like `Strategy::Utils.a_star` which implements the [A* Search Algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) (list of [Utils helper methods](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy/utils) available).

## Deployment

TODO: Write deployment instructions here

## Contributing

1. Fork it (<https://github.com/fdocr/CrystalSnake/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Fernando Valverde](https://github.com/fdocr) - creator and maintainer
