module Row (main, Config, Context, view) where

import Html exposing (Html)
import Html.Attributes as Attributes
import StartApp.Simple exposing (start)

import Button
import Utils exposing (..)


main : Html
main =
  let button_config = "click me!"
      button_context = []
      config =
        { title = "title"
        , buttons = [button_config]
        , comments = ["comment1", "comment2"]
        }
      context = [button_context]
  in  view config context


-- VIEW

type alias Config =
  { title    : String
  , buttons  : List Button.Config
  , comments : List String
  }

type alias Context = List Button.Context

title_view : String -> Html
title_view title = Html.b [] [Html.text title]

comment_view : String -> Html
comment_view comment = Html.div [] [Html.text comment]

view : Config -> Context -> Html
view config button_contexts =
  let style = Attributes.style
        [ ("padding", "0.5em")
        , ("border", "1px solid grey")
        , ("margin", "0.25em")
        ]
      title = title_view config.title
      buttons = List.map2 Button.view config.buttons button_contexts
      comments = List.map comment_view config.comments
  in  Html.div [style] (title :: buttons ++ comments)
