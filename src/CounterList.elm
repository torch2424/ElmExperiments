module CounterList where

import Counter

--Imports, import html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


--Model

--Create our Model
type alias Model =
    { counters : List ( ID, Counter.Model )
    , nextID : ID
    }

--ID is a type int
type alias ID = Int

init : Model
init =
    { counters = []
    , nextID = 0
    }

--update

--Declare our actions
type Action = Insert | Remove ID | Modify ID Counter.Action

--Function update takes an action and a model, and returns a model
update : Action -> Model -> Model
update action model =
    case action of

        --Insert a new counter by creating a new counter, and concatenationg it to our counters
        Insert ->
          { model |
              counters = ( model.nextID, Counter.init 0 ) :: model.counters,
              nextID = model.nextID + 1
          }

          --Find the counter with the id and filter it out
        Remove id ->
          { model |
              counters = List.filter (\(counterID, _) -> counterID /= id) model.counters
          }

        --Modify (add or sub) from a counter
        Modify id counterAction ->
            --create the next state of the counter,and update the model
            let updateCounter (counterID, counterModel) =
                if counterID == id
                    then (counterID, Counter.update counterAction counterModel)
                    else (counterID, counterModel)
            in
                {model | counters = List.map updateCounter model.counters}

--View

view : Signal.Address Action -> Model -> Html

view address model =
    let insert = button [ onClick address Insert ] [ text "Add" ]
  in
      div [] (insert :: List.map (viewCounter address) model.counters)

--Replace the html for the counter that we forward our action signal to
viewCounter: Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
    let context =
        Counter.Context
          (Signal.forwardTo address (Modify id))
          (Signal.forwardTo address (always (Remove id)))
    in
      Counter.viewWithRemoveButton context model


centerClass : Attribute
centerClass =
    style
    [ ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]
