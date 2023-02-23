class Turn < Granite::Base
  connection db
  table turns # Name of the table to use for the model, defaults to class name snake cased

  column id : Int64, primary: true # Primary key, defaults to AUTO INCREMENT
  column game_id : String
  column snake_id : String
  column context : String
  column path : String
  column dead : Bool
  timestamps
end