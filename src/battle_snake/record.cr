require "jennifer"

# This is a DB record representation of a request from a game for either
# start/move/end request. It's a jennifer.cr model:
# https://imdrasil.github.io/jennifer.cr/docs/model_mapping
class BattleSnake::Record < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary64,
    game_id: String,
    context: JSON::Any?,
    created_at: Time?,
    updated_at: Time?,
  )
end