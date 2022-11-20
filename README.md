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
