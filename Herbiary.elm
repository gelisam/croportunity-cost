module Herbiary where


type Species
  = Lettuce
  | Potato
  | Carrot
  | Watermelon
  | Flower
  | Tree

type Bonus
  = Nothing

all_species : List Species
all_species = [Lettuce, Potato, Carrot, Watermelon, Flower, Tree]

name : Species -> String
name species = case species of
  Lettuce    -> "lettuce"
  Potato     -> "potato"
  Carrot     -> "carrot"
  Watermelon -> "watermelon"
  Flower     -> "flower"
  Tree       -> "tree"

-- total number of clicks until grown
lifetime : Species -> Int
lifetime species = case species of
  Lettuce    -> 3
  Potato     -> 5
  Carrot     -> 7
  Watermelon -> 11
  Flower     -> 13
  Tree       -> 17

-- what happens when you harvest the crop
bonus : Species -> Bonus
bonus species = case species of
  Lettuce    -> Nothing
  Potato     -> Nothing
  Carrot     -> Nothing
  Watermelon -> Nothing
  Flower     -> Nothing
  Tree       -> Nothing

instructions : Bonus -> List String
instructions bonus = case bonus of
  Nothing -> ["nothing happens."]
