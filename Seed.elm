module Seed (main, Config, Context, view) where

import Html exposing (Html)
import Signal exposing (Address)
import StartApp.Simple exposing (start)

import Herbiary exposing (Species(..))
import Utils exposing (..)
import Row


main : Html
main =
  let config = Watermelon
      context = nowhere
  in  view config context


-- VIEW

type alias Config = Species

type alias Context = Address ()

view : Config -> Context -> Html
view species address =
  let name = Herbiary.name species
      lifetime = Herbiary.lifetime species
      bonus = Herbiary.bonus species
      instructions = Herbiary.instructions bonus
      
      title = name ++ " seed"
      button_config = "plant"
      button_context = [address]
      comments =
        [ "grows for " ++ toString lifetime ++ " clicks."
        , "upon harvest:"
        ] ++
        instructions
      row_config =
        { title = title
        , buttons = [button_config]
        , comments = comments
        }
      row_context = [button_context]
  in  Row.view row_config row_context
