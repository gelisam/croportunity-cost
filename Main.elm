import Html exposing (Html, Attribute)
import Html.Attributes as Attributes


type Plant
  = Lettuce
  | Potato
  | Carrot
  | Watermelon
  | Flower
  | Tree

all_plants : List Plant
all_plants = [Lettuce, Potato, Carrot, Watermelon, Flower, Tree]


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
  , Html.button [button_style] [Html.text "plant"]
  ]

plant_html : Plant -> Html
plant_html plant = Html.div [row_style]
  [ Html.text (plant_name plant)
  ]


main : Html
main = Html.div []
  ( List.map seed_html all_plants
 ++ List.map plant_html all_plants
  )
