module Crop (main, Model(..), init, Action(NoOp), update, Config, Context, view) where

import Html exposing (Html)
import Signal exposing (Address)
import StartApp.Simple exposing (start)

import Button
import Herbiary exposing (Species(..), Bonus)
import Utils exposing (..)
import Row


main : Signal Html
main = start
  { model = init Watermelon
  , update = update
  , view = \address model ->
      let button = Button.view "click me!" [sendTo address NoOp]
          crop = view Watermelon nowhere address model
      in  Html.div [] [button, crop]
  }


-- MODEL

type Model
  = Growing Int -- number of clicks left until Ready
  | Ready
  | Harvested
  | Spoiled

init : Species -> Model
init = Growing << Herbiary.lifetime


-- UPDATE

type Action
  = NoOp
  | Harvest

update : Action -> Model -> Model
update action model = case action of
  NoOp -> case model of
    Growing 1 -> Ready
    Growing n -> Growing (n - 1)
    Ready     -> Spoiled
    _         -> model
  Harvest -> Harvested


-- VIEW

type alias Config = Species

type alias Context = Address ()

view : Config -> Context -> Address Action -> Model -> Html
view species outer_address inner_address model =
  let name = Herbiary.name species
      lifetime = Herbiary.lifetime species
      bonus = Herbiary.bonus species
      instructions = Herbiary.instructions bonus

      button_config = "harvest"
      button_context =
        [ sendTo inner_address Harvest
        , outer_address
        ]
      row_config = case model of
        Growing lifetime ->
          { title = "growing " ++ name
          , buttons = []
          , comments =
              ["still growing for " ++ toString lifetime ++ " more clicks."]
          }
        Ready ->
          { title = "ripe " ++ name
          , buttons = [button_config]
          , comments = ["ready to be harvested!"]
          }
        Harvested ->
          { title = "harvesting " ++ name
          , buttons = []
          , comments = instructions
          }
        Spoiled ->
          { title = "spoiled " ++ name
          , buttons = []
          , comments = ["you missed your chance to harvest it :("]
          }
      row_context = [button_context]  -- ignored if missing from row_config
  in  Row.view row_config row_context
