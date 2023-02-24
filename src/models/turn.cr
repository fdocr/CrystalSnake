# This is a DB record representation of a request from a game for either
# start/move/end request.
# 
# NOTE: https://imdrasil.github.io/jennifer.cr/docs/model_mapping
class Turn < ApplicationRecord
  with_timestamps

  mapping(
    id: Primary64,
    game_id: String,
    snake_id: String,
    context: String,
    path: String,
    dead: Bool,
    created_at: Time?,
    updated_at: Time?,
  )
end