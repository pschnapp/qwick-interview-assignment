{-# LANGUAGE TupleSections #-}

module Exercise
 ( doThingsAndStuff
 , weirdSortStringsWithSpaces
 ) where

import Data.Maybe
import qualified Data.Text as T

import Zipper


type IndexPair = (Int, T.Text)

data InsertionAction
  = DoNotInsertYet
  | InsertBefore
  | AppendIfUnique


{-# DEPRECATED doThingsAndStuff
  "Use `weirdSortStringsWithSpaces` instead" #-}
doThingsAndStuff :: [Maybe String] -> [String]
doThingsAndStuff = weirdSortStringsWithSpaces

weirdSortStringsWithSpaces :: [Maybe String] -> [String]
weirdSortStringsWithSpaces = doExtract . process . doPack
  where
    doPack = map T.pack . catMaybes
    process = foldr processString empty
    doExtract = reverse . map (T.unpack . snd) . extractAll

toIndexPair :: T.Text -> Maybe IndexPair
toIndexPair str = (,str) . (+ 1) <$> T.findIndex (== ' ') str

determineAction :: IndexPair -> IndexPair -> InsertionAction
determineAction (inIdx, input) (testIdx, test) =
  if testIdx >= T.length test
  then DoNotInsertYet
  else if inIdx >= T.length input || T.index input inIdx < T.index test testIdx
  then InsertBefore
  else if T.index input inIdx == T.index test testIdx
  then determineAction (inIdx+1, input) (testIdx+1, test)
  else AppendIfUnique

processString :: T.Text -> Zipper IndexPair -> Zipper IndexPair
processString text zipper =
  case toIndexPair text of
    Just pair ->
      case seekInsertionPoint pair zipper of
        (zipper', InsertBefore) -> rewind . insert pair $ moveLeft zipper'
        -- this action should be done for either AppendIfUnique
        -- or for DoNotInsertYet (which is coalesced into ^):
        (zipper', _) -> fromList . appendIfUnique pair $ extractAll zipper'
    Nothing -> zipper

seekInsertionPoint :: IndexPair -> Zipper IndexPair -> (Zipper IndexPair, InsertionAction)
seekInsertionPoint pair zipper =
  case pointedTo zipper of
    Nothing -> (zipper, AppendIfUnique)
    Just p ->
      case determineAction pair p of
        DoNotInsertYet -> seekInsertionPoint pair (moveRight zipper)
        InsertBefore -> (zipper, InsertBefore)
        AppendIfUnique -> (zipper, AppendIfUnique)

appendIfUnique :: IndexPair -> [IndexPair] -> [IndexPair]
appendIfUnique pair pairs =
  if any ((== snd pair) . snd) pairs
  then pairs
  else pairs ++ [pair]
