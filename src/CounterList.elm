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
type Action = Insert | Remove | Modify ID Counter.Action

--Function update takes an action and a model, and returns a model
update : Action -> Model -> Model
update action model =
    case action of
        Insert ->
            --Create the new counter var, and concatenate it to
            --Our current counters, then place in the model
            let newCounter = (model.nextID, Counter.init 0)
                newCounters = model.counters ++ [newCounter]
            in
                { model |
                    counters = newCounters,
                    nextID = model.nextID + 1
                }
        Remove ->
            --Drop the counter from the model
            {model | counters = List.drop 1 model.counters}

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
    let counters = List.map (viewCounter address) model.counters
        remove = button [onClick address Remove] [text "Remove"]
        insert = button [onClick address Insert] [text "Add"]
    in
        div [centerClass] ([remove, insert] ++ counters)

--Replace the html for the counter that we forward our action signal to
viewCounter: Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
    Counter.view (Signal.forwardTo address (Modify id)) model


centerClass : Attribute
centerClass =
    style
    [ ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]
