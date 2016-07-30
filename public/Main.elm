import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import List
import String exposing(..)
import Regex exposing (..)
import Char exposing (isDigit, isLower)


main =
  App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL
type alias RedditPost =
  { title : String
  }

type alias Model =
  { subreddit : String
  , response : (List RedditPost) 
  , error : String
  }


-- INIT
init : (Model, Cmd Msg)
init =
  (Model "" [] "", Cmd.none)


-- UPDATE
type Msg
   = InputUpdate String
   | Get
   | FetchPass (List RedditPost)
   | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of 
    InputUpdate val ->
      ( { model | subreddit = val }, Cmd.none )

    Get ->
      ( model, getSubReddit model.subreddit )

    FetchPass response ->
      ( { model | response = response } , Cmd.none )

    FetchFail err ->
      case err of 
        Http.BadResponse code message ->
          ( { model | error = message }, Cmd.none )

        _ -> 
          ( { model | 
              error = "Failed"
              , response = []}, Cmd.none )

--VIEW
view model =
  div []
    [ input [ type' "text", onInput InputUpdate, placeholder "Subreddit" ] []
    , button [ onClick Get ] [ text "GO" ]
    , p [] [ text model.error ]
    , ul [] (List.map subbreddit model.response)
    ]

subbreddit response =
  li []
    [ h3[] [ text response.title ]
    ]

--HTTP
getSubReddit : String -> Cmd Msg
getSubReddit subreddit =
  let 
    url =
      "https://www.reddit.com/r/" ++ subreddit ++ ".json"
  in
    Task.perform FetchFail FetchPass (Http.get decodeRedditPost url)

decodeRedditPost =
  Json.at [ "data", "children" ] decodeList

decodeList =
  Json.list decodeSubReddit

decodeSubReddit =
  Json.at [ "data" ] decodeInnerData

decodeInnerData =
  Json.object1 RedditPost
    ("title" := Json.string)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none