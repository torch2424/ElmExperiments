module CounterPair where

import Counter

--Imports, import html
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


--Model
type alias Model =
    { topCounter: Counter.Model
    , bottomCounter: Counter.Model
    }

init: Int -> Int -> Model
init top bottom =
    {topCounter = Counter.init top
    , bottomCounter = Counter.init bottom
    }

--update

--Declare our actions
--Top and Bottom take action parameters
type Action = Reset | Top Counter.Action | Bottom Counter.Action

--Declare our update function, takes action and model, returns model
update: Action -> Model -> Model
update action model =
    case action of

        --Reset will call init passing 0 0
        Reset -> init 0 0

        --this will call top, passing the action
        Top act ->
            --This model | topCounter is a union type
            -- meaning that topcounter is of type model
            -- so if the input param is a model that
            -- is topCounter. than run the code
            { model |
                topCounter = Counter.update act model.topCounter
            }

        Bottom act ->
            { model |
                bottomCounter = Counter.update act model.bottomCounter
            }

--View!

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ Counter.view (Signal.forwardTo address Top) model.topCounter
    , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
    , button [ onClick address Reset ] [ text "RESET" ]
    ]
