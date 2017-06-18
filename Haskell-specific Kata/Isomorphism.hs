module IsomorphismKata where

import Data.Void

-- | Make all the isomorphisms typecheck (3 kyu)
-- | Link: https://biturl.io/Iso

-- | My original solution

type ISO a b = (a -> b, b -> a)

-- given ISO a b, we can go from a to b
substL :: ISO a b -> (a -> b)
substL = fst

-- and vice versa
substR :: ISO a b -> (b -> a)
substR = snd

-- There can be more than one ISO a b
isoBool :: ISO Bool Bool
isoBool = (id, id)

isoBoolNot :: ISO Bool Bool
isoBoolNot = (not, not)

-- isomorphism is reflexive
refl :: ISO a a
refl = (id, id)

-- isomorphism is symmetric
symm :: ISO a b -> ISO b a
symm (ab, ba) = (ba, ab)

-- isomorphism is transitive
trans :: ISO a b -> ISO b c -> ISO a c
trans (ab, ba) (bc, cb) = (bc . ab, ba . cb)

-- We can combine isomorphism:
isoTuple :: ISO a b -> ISO c d -> ISO (a, c) (b, d)
isoTuple (ab, ba) (cd, dc) = (\(a, c) -> (ab a, cd c), \(b, d) -> (ba b, dc d))

isoList :: ISO a b -> ISO [a] [b]
isoList (ab, ba) = (map ab, map ba)

isoMaybe :: ISO a b -> ISO (Maybe a) (Maybe b)
isoMaybe (ab, ba) = (helper ab, helper ba)
 where
  helper f mx = case mx of
    Just x -> Just $ f x
    _      -> Nothing

isoEither :: ISO a b -> ISO c d -> ISO (Either a c) (Either b d)
isoEither (ab, ba) (cd, dc) = (helper, helper')
 where
  helper (Left  a) = Left $ ab a
  helper (Right c) = Right $ cd c
  helper' (Left  b) = Left $ ba b
  helper' (Right d) = Right $ dc d

isoFunc :: ISO a b -> ISO c d -> ISO (a -> c) (b -> d)
isoFunc (ab, ba) (cd, dc) = (\ac -> cd . ac . ba, \bd -> dc . bd . ab)

-- Going another way is hard (and is generally impossible)
isoUnMaybe :: ISO (Maybe a) (Maybe b) -> ISO a b
isoUnMaybe (mab, mba) = (helper mab, helper mba)
 where
  helper f a = case (f $ Just a, f Nothing) of
    (Just x, _     ) -> x
    (_     , Just x) -> x
    _                -> undefined

isoEU :: ISO (Either [()] ()) (Either [()] Void)
isoEU = (f, g)
 where
  f (Left xs) = Left $ () : xs
  f _         = Left []
  g (Left []    ) = Right ()
  g (Left (_:xs)) = Left xs
  g _             = undefined

-- And we have isomorphism on isomorphism!
isoSymm :: ISO (ISO a b) (ISO b a)
isoSymm = (swap, swap) where swap (a, b) = (b, a)
