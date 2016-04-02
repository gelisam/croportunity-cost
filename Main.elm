import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events


-- MODEL


type Plant
  = Lettuce
  | Potato
  | Carrot
  | Watermelon
  | Flower
  | Tree

all_plants : List Plant
all_plants = [Lettuce, Potato, Carrot, Watermelon, Flower, Tree]


type alias Model = List Plant

model : Signal Model
model = Signal.foldp update [] actions.signal


-- UPDATE


type Action
  = NoOp
  | PlantSeed Plant

actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


update : Action -> Model -> Model
update action plants = case action of
  NoOp ->
    plants
  PlantSeed plant ->
    plant :: plants


-- STYLES


row_style : Attribute
row_style = Attributes.style
  [ ("padding", "0.5em")
  , ("border", "1px solid grey")
  , ("margin", "0.25em")
  , ("width", "40em")
  ]

button_style : Attribute
button_style = Attributes.style
  [ ("float", "right")
  ]


-- HTML


plant_name : Plant -> String
plant_name plant = case plant of
  Lettuce    -> "lettuce"
  Potato     -> "potato"
  Carrot     -> "carrot"
  Watermelon -> "watermelon"
  Flower     -> "flower"
  Tree       -> "tree"


seed_html : Plant -> Html
seed_html plant = Html.div [row_style]
  [ Html.text (plant_name plant ++ " seed")
  , Html.button
      [button_style, Events.onClick actions.address (PlantSeed plant)]
      [Html.text "plant"]
  ]

plant_html : Plant -> Html
plant_html plant = Html.div [row_style]
  [ Html.text (plant_name plant)
  ]


-- VIEW

view : Model -> Html
view plants = Html.div []
  ( List.map seed_html all_plants
 ++ List.map plant_html plants
  )

main : Signal Html
main = Signal.map view model
