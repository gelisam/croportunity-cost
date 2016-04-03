module CounterPair (main, Model, init, Action, update, view) where

import Html exposing (Html)
import Html.Events as Events
import Signal exposing (Signal, Address)
import StartApp.Simple exposing (start)

import Counter


main : Signal Html
main = start
  { model = init 0 0
  , update = update
  , view = view
  }


-- MODEL

type alias Model =
  { top : Counter.Model
  , bottom : Counter.Model
  }

init : Int -> Int -> Model
init x y =
  { top = Counter.init x
  , bottom = Counter.init y
  }


-- ACTION

type Action
  = Reset
  | Top Counter.Action
  | Bottom Counter.Action

update : Action -> Model -> Model
update action model = case action of
  Reset -> init 0 0
  Top action' -> {model | top = Counter.update action' model.top}
  Bottom action' -> {model | bottom = Counter.update action' model.bottom}


-- VIEW

view : Address Action -> Model -> Html
view address model = Html.div []
  [ Html.button [Events.onClick address Reset] [Html.text "reset"]
  , Counter.view (Signal.forwardTo address Top) model.top
  , Counter.view (Signal.forwardTo address Bottom) model.bottom
  ]
