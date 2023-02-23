-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE turns(
  id BIGSERIAL PRIMARY KEY,
  game_id VARCHAR NOT NULL,
  snake_id VARCHAR NOT NULL,
  context TEXT NOT NULL,
  path VARCHAR NOT NULL,
  dead BOOLEAN NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE turns;