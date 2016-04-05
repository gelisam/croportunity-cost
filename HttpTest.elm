import Debug
import Effects exposing (Effects, Never)
import Html exposing (Html)
import Http
import Json.Decode as Json
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

http_post : Task Http.Error (List String)
http_post = Http.post (Json.list Json.string) ("http://localhost:8001/endpoint") Http.empty


-- MODEL

type alias Model = List String

init : (Model, Effects Action)
init =
  let task : Task Never Action
      task = http_post
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
