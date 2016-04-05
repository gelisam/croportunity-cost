import Debug
import Effects exposing (Effects, Never)
import Html exposing (Html)
import Http
import Json.Decode as Json exposing ((:=))
import Signal exposing (Signal, Address)
import StartApp exposing (App)
import Task exposing (Task)


app : App Model
app =
  StartApp.start { init = init, view = view, update = update, inputs = [] }

main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


-- HTTP

lookupZipCode : String -> Task Http.Error (List String)
lookupZipCode query =
  Http.get places ("http://localhost:8001/us/" ++ query)

places : Json.Decoder (List String)
places =
  let place =
        Json.object2 (\city state -> city ++ ", " ++ state)
          ("place name" := Json.string)
          ("state" := Json.string)
  in  "places" := Json.list place


-- MODEL

type alias Model = List String

init : (Model, Effects Action)
init =
  let task : Task Never Action
      task = lookupZipCode "90210"
          |> Task.toResult
          |> Task.map (toString >> Log)
  in  ([], Effects.task task)


-- UPDATE

type Action
  = Log String

update : Action -> Model -> (Model, Effects action)
update (Log string) strings =
  (strings ++ [string], Effects.none)


-- VIEW

view : Address Action -> Model -> Html
view _ strings =
  let line string = Html.div [] [Html.text string]
  in  Html.div [] (List.map line strings)
