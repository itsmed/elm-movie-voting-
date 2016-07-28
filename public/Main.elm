import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing(..)
import Regex exposing (..)
import Char exposing (isDigit, isLower)
--import JSON

main =
  App.program
  { init = init
  , view = view
  , update = update
  --, subscriptions = subscriptions
  }


-- MODEL
type alias Model =
  { topic : String
  , gifUrl : String
  }

-- INIT

init : (Model, Cmd Msg)
init =
  (Model "cats" "waiting.gif", Cmd.none)


-- getRandomGif
getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at [ "data", "image_url" ] Json.string


-- UPDATE
type Msg 
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text model.topic ]
    , img [ src model.gifUrl ] []
    , button [ onClick MorePlease ] [ text "More Please" ]
    ]