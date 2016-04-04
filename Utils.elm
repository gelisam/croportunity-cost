module Utils where

import Signal exposing (Address)


type alias ID = Int

updateAt : ID -> (a -> a) -> List (ID, a) -> List (ID, a)
updateAt n f = List.map (\(i, x) -> (i, if i == n then f x else x))


nowhere : Address a
nowhere =
  let unit_mailbox = Signal.mailbox ()
      unit_address = unit_mailbox.address
  in  Signal.forwardTo unit_address (always ())

sendTo : Address b -> b -> Address ()
sendTo address x = Signal.forwardTo address (always x)
