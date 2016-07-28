import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
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
type alias Model = 
  { username : String
  , password : String
  , passwordAgain : String
  , validateForm : Bool
  }

init : Model
init =
  Model "" "" "" False

-- SUBSCRIPTIONS

-- UPDATE
type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | ValidateForm

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }
    Password password ->
      { model | password = password }
    PasswordAgain passwordAgain ->
      { model | passwordAgain = passwordAgain }
    ValidateForm ->
      { model | validateForm = True }


-- VIEW
view : Model -> Html Msg
view model =
  div []
  [ input [ type' "text", placeholder "Name", onInput Name ] []
  , input [ type' "password", placeholder "Password", onInput Password ] []
  , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
  , button [ onClick ValidateForm ] [ text "Submit" ]
  , validateForm model
  ]

validateForm : Model -> Html Msg
validateForm model =
  let
    (color, message) =
      if model.validateForm then
        if String.length model.password < 8 then 
          ("red", "Not enough characters in password")
        else if any isLower model.password == False then
          ("red", "Password must contain lower case letters")
        else if model.password == toLower model.password then
          ("red", "Password must contain uppercase letters")
        else if any isDigit model.password == False then 
          ("red", "Passowrd must contain digits")
        else if model.password /= model.passwordAgain then
          ("red", "Passwords don't match")
        else if all isDigit model.age == False then
          ("red", "Age must be a number")
        else
          ("green", "ok")
      else
        ("white", "")
  in 
    div [ style [("color", color)] ] [ text message ]