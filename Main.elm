import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events


type Plant
  = Lettuce
  | Potato
  | Carrot
  | Watermelon
  | Flower
  | Tree

type alias Seed = Plant

type Growth
  = Growing Int -- number of clicks left until grown
  | Grown
  | Spoiled

type alias Crop =
  { plant  : Plant
  , growth : Growth
  }


plant_name : Plant -> String
plant_name plant = case plant of
  Lettuce    -> "lettuce"
  Potato     -> "potato"
  Carrot     -> "carrot"
  Watermelon -> "watermelon"
  Flower     -> "flower"
  Tree       -> "tree"

-- total number of clicks until grown
plant_lifetime : Plant -> Int
plant_lifetime plant = case plant of
  Lettuce    -> 3
  Potato     -> 5
  Carrot     -> 7
  Watermelon -> 11
  Flower     -> 13
  Tree       -> 17

plant_crop : Plant -> Crop
plant_crop plant =
  { plant  = plant
  , growth = Growing (plant_lifetime plant)
  }


-- MODEL

type alias Model = List Crop

model : Signal Model
model = Signal.foldp update [] actions.signal

seeds : List Seed
seeds = [Lettuce, Potato, Carrot, Watermelon, Flower, Tree]


-- UPDATE

type Action
  = NoOp
  | PlantSeed Plant

actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


timestep_growth : Growth -> Maybe Growth
timestep_growth growth = case growth of
  Growing 1 -> Just Grown
  Growing n -> Just (Growing (n - 1))
  Grown     -> Just Spoiled
  Spoiled   -> Nothing

timestep_crop : Crop -> Maybe Crop
timestep_crop crop = case timestep_growth crop.growth of
  Nothing     -> Nothing
  Just growth -> Just {crop | growth = growth}

timestep_crops : List Crop -> List Crop
timestep_crops = List.filterMap timestep_crop

update_crops : Action -> List Crop -> List Crop
update_crops action crops = case action of
  NoOp            -> crops
  PlantSeed plant -> (plant_crop plant :: crops)

update : Action -> Model -> Model
update action = timestep_crops >> update_crops action


-- STYLES

centered_style : Attribute
centered_style = Attributes.style
  [ ("margin", "auto")
  , ("width", "40em")
  ]

row_style : Attribute
row_style = Attributes.style
  [ ("padding", "0.5em")
  , ("border", "1px solid grey")
  , ("margin", "0.25em")
  ]

button_style : Attribute
button_style = Attributes.style
  [ ("float", "right")
  ]


-- HTML

type alias Button =
  { text   : String
  , action : Action
  }

button_html : Button -> Html
button_html button = Html.button
  [button_style, Events.onClick actions.address button.action]
  [Html.text button.text]


type alias Row =
  { title       : String
  , buttons     : List Button
  , description : List String
  }

title_html : String -> Html
title_html title = Html.b [] [Html.text title]

entry_html : String -> Html
entry_html entry = Html.div [] [Html.text entry]

row_html : Row -> Html
row_html row =
  let elements =
        [title_html row.title] ++
        List.map button_html row.buttons ++
        List.map entry_html row.description
  in Html.div [row_style] elements


seed_title : Seed -> String
seed_title seed = plant_name seed ++ " seed"

seed_buttons : Seed -> List Button
seed_buttons seed =
  let button =
        { text   = "plant"
        , action = PlantSeed seed
        }
  in [button]

seed_description : Seed -> List String
seed_description seed =
  [ "grows for " ++ toString (plant_lifetime seed) ++ " clicks."
  , "upon harvest, does nothing."
  ]

seed_row : Seed -> Row
seed_row seed =
  { title       = seed_title seed
  , buttons     = seed_buttons seed
  , description = seed_description seed
  }


crop_title : Crop -> String
crop_title crop =
  let name = plant_name crop.plant in
  case crop.growth of
    Growing _ -> "growing " ++ name
    Grown     -> name
    Spoiled   -> "spoiled " ++ name

crop_buttons : Crop -> List Button
crop_buttons crop =
  case crop.growth of
    Grown ->
      let button =
            { text   = "harvest"
            , action = NoOp
            }
      in [button]
    _ -> []

crop_description : Crop -> List String
crop_description crop =
  case crop.growth of
    Growing lifetime ->
      ["still growing for " ++ toString lifetime ++ " more clicks."]
    Grown ->
      ["ready to be harvested!"]
    Spoiled ->
      ["you missed your chance to harvest it :("]

crop_row : Crop -> Row
crop_row crop =
  { title       = crop_title crop
  , buttons     = crop_buttons crop
  , description = crop_description crop
  }

rows : Model -> List Row
rows crops =
  List.map seed_row seeds ++
  List.map crop_row crops

view : Model -> Html
view model =
  let title_element = Html.h1 [] [Html.text "Croportunity Cost!"]
      row_elements = List.map row_html (rows model)
      elements     = title_element :: row_elements
  in
    Html.div [centered_style] elements

main : Signal Html
main = Signal.map view model
