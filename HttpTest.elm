import Debug
import Effects exposing (Effects, Never)
import Html exposing (Html)
import Html.Events as Events
import Http
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
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

endpoint : String
endpoint = "http://localhost:3000/signup"

http_get : Task Http.Error String
http_get = Http.get ("hello" := Decode.string) endpoint

http_post : Task Http.Error String
http_post =
  let payload = Encode.object
        [ ("hello", Encode.string "who")
        ]
      body = Http.string (Encode.encode 0 payload)
  in  Http.post ("hello" := Decode.string) endpoint body

wrap_http_task : Task Http.Error a -> Effects Action
wrap_http_task task =
  task
    |> Task.toResult
    |> Task.map (toString >> Log)
    |> Effects.task


-- MODEL

type alias Model = List String

init : (Model, Effects Action)
init = ([], Effects.none)


-- UPDATE

type Action
  = Log String
  | ClearLog
  | TestGet
  | TestPost

update : Action -> Model -> (Model, Effects Action)
update action strings = case action of
  Log string ->
    (strings ++ [string], Effects.none)
  ClearLog ->
    ([], Effects.none)
  TestGet ->
    (strings ++ ["GET " ++ endpoint], wrap_http_task http_get)
  TestPost ->
    (strings ++ ["POST " ++ endpoint], wrap_http_task http_post)


-- VIEW

view : Address Action -> Model -> Html
view address strings =
  let line string = Html.div [] [Html.text string]
      buttons = Html.div []
        [ Html.button [Events.onClick address TestGet] [Html.text "GET"]
        , Html.button [Events.onClick address TestPost] [Html.text "POST"]
        , Html.button [Events.onClick address ClearLog] [Html.text "Clear"]
        ]
  in  Html.div [] (List.map line strings ++ [buttons])
