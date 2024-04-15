module Zipper
 ( Zipper
 , empty
 , fromList
 , insert
 , moveLeft
 , moveRight
 , rewind
 , pointedTo
 , extractAll
 ) where


data Zipper a
  = Zipper
    { leftsOf :: [a]
    , rightsOf :: [a]
    }

empty :: Zipper a
empty = Zipper [] []

fromList :: [a] -> Zipper a
fromList = Zipper []

insert :: a -> Zipper a -> Zipper a
insert item (Zipper lefts rights) = Zipper (item:lefts) rights

moveLeft :: Zipper a -> Zipper a
moveLeft z@(Zipper [] _) = z
moveLeft (Zipper (right:lefts) rights) = Zipper lefts (right:rights)

moveRight :: Zipper a -> Zipper a
moveRight z@(Zipper _ []) = z
moveRight (Zipper lefts (left:rights)) = Zipper (left:lefts) rights

rewind :: Zipper a -> Zipper a
rewind z@(Zipper [] _) = z
rewind (Zipper (l:ls) rights) = rewind . Zipper ls $ l:rights

pointedTo :: Zipper a -> Maybe a
pointedTo (Zipper _ []) = Nothing
pointedTo (Zipper _ (right:_)) = Just right

extractAll :: Zipper a -> [a]
extractAll = rightsOf . rewind
