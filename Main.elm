import Html exposing (Html)


type Plant
  = Lettuce
  | Potato
  | Carrot
  | Watermelon
  | Flower
  | Tree

all_plants : List Plant
all_plants = [Lettuce, Potato, Carrot, Watermelon, Flower, Tree]


plant_name : Plant -> String
plant_name plant = case plant of
  Lettuce    -> "lettuce"
  Potato     -> "potato"
  Carrot     -> "carrot"
  Watermelon -> "watermelon"
  Flower     -> "flower"
  Tree       -> "tree"

seed_html : Plant -> Html
seed_html plant = Html.div []
  [ Html.text (plant_name plant ++ " seed")
  , Html.button [] [Html.text "plant"]
  ]

plant_html : Plant -> Html
plant_html plant = Html.div []
  [ Html.text (plant_name plant)
  ]


main : Html
main = Html.div []
  ( List.map seed_html all_plants
 ++ List.map plant_html all_plants
  )
