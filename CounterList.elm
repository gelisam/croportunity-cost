module CounterList (main, Model, init, Action, update, view) where

import Html exposing (Html)
import Html.Events as Events
import Signal exposing (Signal, Address)
import StartApp.Simple exposing (start)

import Counter


main : Signal Html
main = start
  { model = init []
  , update = update
  , view = view
  }


-- MODEL

type alias Model = List Counter.Model

init : List Int -> Model
init = List.map Counter.init


-- ACTION

type Action
  = Reset
  | Push
  | Pop
  | Counter Int Counter.Action

updateAt : Int -> (a -> a) -> List a -> List a
updateAt n f = List.indexedMap (\i x -> if n == i then f x else x)

update : Action -> Model -> Model
update action counters = case action of
  Reset -> init []
  Push -> Counter.init 0 :: counters
  Pop -> List.drop 1 counters
  Counter i counter_action -> updateAt i (Counter.update counter_action) counters


-- VIEW

viewAt : Address Action -> Int -> Counter.Model -> Html
viewAt address n counter_model =
  let counter_address = Signal.forwardTo address (Counter n)
  in Counter.view counter_address counter_model

view : Address Action -> Model -> Html
view address counters =
  let elements =
        [ Html.button [Events.onClick address Reset] [Html.text "reset"]
        , Html.button [Events.onClick address Push] [Html.text "push"]
        , Html.button [Events.onClick address Pop] [Html.text "pop"]
        ] ++
        List.indexedMap (viewAt address) counters
  in Html.div [] elements
