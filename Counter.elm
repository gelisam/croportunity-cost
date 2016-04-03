module Counter (main, Model, init, Action, update, view) where

import Html exposing (Html)
import Html.Events as Events
import Signal exposing (Signal, Address)
import StartApp.Simple exposing (start)


main : Signal Html
main = start
  { model = init 0
  , update = update
  , view = view
  }


-- MODEL

type alias Model = Int

init : Int -> Model
init = identity


-- ACTION

type Action
  = Increment
  | Decrement

update : Action -> Model -> Model
update action x = case action of
  Increment -> x + 1
  Decrement -> x - 1


-- VIEW

view : Address Action -> Model -> Html
view address x = Html.div []
  [ Html.button [Events.onClick address Decrement] [Html.text "-"]
  , Html.text (toString x)
  , Html.button [Events.onClick address Increment] [Html.text "+"]
  ]
