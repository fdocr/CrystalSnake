# This is a DB record representation of a request from a game for either
# start/move/end request. It's a jennifer.cr model:
# https://imdrasil.github.io/jennifer.cr/docs/model_mapping
class Turn < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary64,
    game_id: String?,
    created_at: Time?,
    updated_at: Time?,
  )

  # def self.build_from(context : BattleSnake::Context, action : String)
  #   # create()
  # end
end