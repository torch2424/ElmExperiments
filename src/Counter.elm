
--Creating Module counter, where we expose (Make public)
--The Functions f(g(x)), Model, init, Action, update and view
module Counter(Model, init, Action, update, view, viewWithRemoveButton, Context) where

--Imports, import html
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MODEL

--Declare of varaible  type of model
type alias Model = Int

--Our Counter Context (State), for removing a counter
type alias Context =
    {actions: Signal.Address Action
    , remove: Signal.Address ()
    }

--Declare our init function
--init, a function that
--takes an integer and returns a model
init : Int -> Model
init count = count


-- UPDATE

--Declare the function type of Action
--Where Increment and Decrements are Action types
type Action = Increment | Decrement

--function update
--that takes an action, takes a model, and returns a model
update : Action -> Model -> Model
--Declare the {} of the update function
--with the parameters action and model
update action model =
    --switch statement (pattern matching)
    --if action is increment, add 100 to the model param
    --vice versa
  case action of
    Increment -> model + 1
    Decrement -> model - 1


-- VIEW

--view, function that takes an action from
--the always listening signal adresses,
--takes a model, and returns html
view : Signal.Address Action -> Model -> Html
--Declaring function {}
view address model =
    --this is calling the div function
    --passing an attributes to the function
    --to apply css
    div [centerClass]
        [ button [onClick address Decrement] [text "- count"]
        , div [countStyle] [text (toString model)]
        , button [onClick address Increment ] [text "+ count"]
        ]

--Our About view but also with remove button
viewWithRemoveButton : Context -> Model -> Html
viewWithRemoveButton context model =
  div []
    [ button [ onClick context.actions Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick context.actions Increment ] [ text "+" ]
    , div [ countStyle, removeButton, centerClass ] []
    , button [ onClick context.remove () ] [ text "X" ]
    ]

--Css classes, count style is a fucntion
--that is an attribute type
countStyle : Attribute
countStyle =
    --count style is a function that returns
    --the results of the html.style function
    --with the input params
    style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "500px")
    , ("text-align", "center")
    ]

centerClass : Attribute
centerClass =
    style
    [ ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]

removeButton: Attribute
removeButton =
    style
    [("margin-left", "auto")]
