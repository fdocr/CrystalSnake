# Crystal Snake

This is a [Battle Snake](https://play.battlesnake.com/) project written in [Crystal](https://crystal-lang.org/) using [Kemal](https://kemalcr.com/)

I strongly recommend reading the docs in [https://fdocr.github.io/CrystalSnake/](https://fdocr.github.io/CrystalSnake/). You'll find detailed information on classes and methods there :)

## Installation

You'll need Crystal, Postgres 14 & Redis locally. The app uses [sam.cr](https://github.com/imdrasil/sam.cr) for ease of development.

```bash
# Install dependencies
shards install

# Start development server in port 8080 with live reload
make sam dev

# Run tests
make sam test

# Use a custom strategy
STRATEGY="ChaseClosestFood" make sam dev
```

## Development

The app can be configured using an `.env` file (example below)

```bash
DATABASE_URL="postgresql://localhost:5432/battlesnake"
REDIS_URL="redis://localhost:6379"
HONEYCOMB_API_KEY="<API_KEY>"
STRATEGY="CautiousCarol"
LOG_LEVEL="DEBUG"
```

For local development I use the [BattleSnake CLI](https://github.com/BattlesnakeOfficial/rules/tree/main/cli) with the local server running. A basic example looks like this:

```bash
# Solo game
battlesnake play -W 11 -H 11 --name dev --url http://localhost:8080 -g solo -v

# 1v1 against itself (you should be able to use any public snake if you know their URL)
battlesnake play -W 11 -H 11 --name dev --url http://localhost:8080  --name dev2 --url http://localhost:8080 -v
```

#### Strategies & Architecture

The server is built on the `src/app.cr` file and you can choose to use any of the available strategies ([list available here](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy)).

To start hacking a new one create a new strategy (in that folder) that inherits from `Stategy::Base`. They're all initialized with a `BattleSnake::Context` and you call `#move` method to chose a move to respond with (the method your logic will live). You can re-use strategies within each other, i.e. `Strategy::ChaseClosestFood` uses the `Strategy::RandomValid` strategy when reachable food doesn't exist on the board.

You can also use `Strategy::Utils` class methods like `Strategy::Utils.a_star` which implements the [A* Search Algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) (list of [Utils helper methods](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy/utils) available).

## Deployment

I'm currently using [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform). The [Dockerfile](/Dockerfile) is detected and deployed on their cheapest tier. It "should work" in lots of other platforms with this setup, but [open an issue](https://github.com/fdocr/CrystalSnake/issues/new) if you need help troubleshooting or to discuss other solutions.

**Customizations**

ENV variables are used to [customize your snake](https://docs.battlesnake.com/guides/customizations)

- `SNAKE_COLOR` (i.e. "#cccccc")
- `SNAKE_HEAD`
- `SNAKE_TAIL`
- `STRATEGY` (i.e. "CautiousCarol")

## Contributing

1. Fork it (<https://github.com/fdocr/CrystalSnake/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Fernando Valverde](https://github.com/fdocr) - creator and maintainer
