
--Import our Component, as well as start app
--Start app controls the elm signals to find
--Actions
import CounterPair exposing (init, update, view)
import StartApp.Simple exposing (start)

--Set main to the start of signal reading, passing in
-- Counter pair functions
main =
  start { model = init 0 0, update = update, view = view }
