module Animation (main, Model, init, Action, update, view) where

import Html exposing (Html)
import Html.Attributes as Attributes
import Signal exposing (Address)
import StartApp.Simple exposing (start)

import Button
import Utils exposing (..)

main : Signal Html
main = start
  { model = init
  , update = update
  , view = view
  }


-- MODEL

type alias Model = Bool

init : Model
init = True


-- UPDATE

type Action
  = Toggle

update : Action -> Model -> Model
update action model = case action of
  Toggle -> not model


-- VIEW

view : Address Action -> Model -> Html
view address model =
  let button_config = "toggle"
      button_context = [ sendTo address Toggle ]
      visible_style = Attributes.style []
      faded_out_style = Attributes.style
        [ ("transition", "opacity 0.9s ease-out")
        , ("background", "green")
        , ("opacity", "0.01")
        ]
      style = if model then visible_style else faded_out_style
  in  Html.div [style]
        [ Html.text "Hello!"
        , Button.view button_config button_context
        ]
