module Button (main, Config, Context, view) where

import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Signal exposing (Address)

import Utils exposing (..)


main : Html
main = view "click me" []


-- VIEW

type alias Config = String

type alias Context = List (Address ())

view : Config -> Context -> Html
view text addresses =
  let style = Attributes.style
        [ ("float", "right")
        ]
      clickHandler address = Events.onClick address ()
      clickHandlers = List.map clickHandler addresses
  in  Html.button
        (style :: clickHandlers)
        [Html.text text]
