import Debug
import Html
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)


lookupZipCode : String -> Task Http.Error (List String)
lookupZipCode query =
    Http.get places ("http://localhost:8001/us/" ++ query)


places : Json.Decoder (List String)
places =
  let place =
        Json.object2 (\city state -> city ++ ", " ++ state)
          ("place name" := Json.string)
          ("state" := Json.string)
  in
      "places" := Json.list place

port myPort : Task Http.Error (List String)
port myPort = lookupZipCode "90210"
           |> map (\x -> Debug.log (toString x) x)
           |> mapError (toString >> Debug.crash)

main = Html.text "look at the console"
