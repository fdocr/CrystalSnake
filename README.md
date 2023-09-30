# Crystal Snake

This is a [Battle Snake](https://play.battlesnake.com/) project written in [Crystal](https://crystal-lang.org/) using [Kemal](https://kemalcr.com/)

I strongly recommend reading the docs in [https://fdocr.github.io/CrystalSnake/](https://fdocr.github.io/CrystalSnake/). You'll find detailed information on classes and methods there :)

I wrote a few blog posts about this project. Check out [the first one here](https://dev.to/fdocr/learning-crystal-with-battlesnake-3chj).

## Installation

You'll need Crystal, Postgres & Redis locally. The app uses [sam.cr](https://github.com/imdrasil/sam.cr) for ease of development.

```bash
# Install dependencies
shards install

# Create DB & run migrations
make sam db:setup

# Start development server in port 8080 with live reload
make sam dev

# Run tests
make sam test
```

## Development

The app can be configured copying the `.env.sample` file as `.env` in the directory root.

For local development I use the [BattleSnake CLI](https://github.com/BattlesnakeOfficial/rules/tree/main/cli) with the local server running. A basic example looks like this:

```bash
# Solo game with ChaseClosestFood strategy
battlesnake play -W 11 -H 11 --name dev --url http://localhost:8080/chase_closest_food -g solo -v

# Play RandomValid vs CautiousCarol strategies
battlesnake play -W 11 -H 11 --name RandomValid --url http://localhost:8080/random_valid  --name CautiousCarol --url http://localhost:8080/cautious_carol -v
```

#### Strategies & Architecture

The server is built on the `src/app.cr` file and you can choose to use [any of the available strategies](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy).

To start hacking a new one create a new strategy (in the `src/strategy` folder) that inherits from `Stategy::Base`. They're all initialized with a `BattleSnake::Context` and the server calls the `#move` method on it to respond with. You can re-use strategies within each other, i.e. `Strategy::ChaseClosestFood` uses the `Strategy::RandomValid` strategy when it can't reach any food on the board.

In order to start using a new strategy:
1. Add new entry in case clause to `src/strategy/base.cr`
   - Must return the new strategy object
2. The string in the case clause will determine its path
   - i.e. `http://localhost:8080/new_strategy`

Strategies can use `Strategy::Utils` class methods like `Strategy::Utils.a_star` which implements the [A* Search Algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm). Check out the [available Utils helper methods](https://github.com/fdocr/CrystalSnake/tree/main/src/strategy/utils).

## Deployment

I'm currently using [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform). The [Dockerfile](/Dockerfile) is detected and deployed on their cheapest tier. It "should work" in lots of other platforms with this setup, but [open an issue](https://github.com/fdocr/CrystalSnake/issues/new) if you need help troubleshooting or to discuss other solutions.

**Customizations**

ENV variables are used to [customize your snake](https://docs.battlesnake.com/guides/customizations)

- `SNAKE_COLOR` (i.e. "#cccccc")
- `SNAKE_HEAD`
- `SNAKE_TAIL`

## Contributing

Make sure to test your changes. First copy `.env.sample` as `.env.test` so you can run the test suite with `make sam test`.

1. Fork it (<https://github.com/fdocr/CrystalSnake/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Fernando Valverde](https://github.com/fdocr) - creator and maintainer
