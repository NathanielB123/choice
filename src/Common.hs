module Common
  ( module Common,
    module Data.Coerce,
  )
where

import Data.Coerce

--------------------------------------------------------------------------------

newtype Name = Name String
  deriving newtype (Show)

instance Eq Name where
  ~_ == ~_ = True

instance Ord Name where
  compare ~_ ~_ = EQ

newtype Ix = Ix Int
  deriving newtype (Eq, Ord, Show, Num, Enum, Bounded)

newtype Lvl = Lvl Int
  deriving newtype (Eq, Ord, Show, Num, Enum, Bounded)

newtype MetaVar = MetaVar Int
  deriving newtype (Eq, Ord, Show, Num, Enum, Bounded)

newtype ChoiceVar = ChoiceVar Int
  deriving newtype (Eq, Ord, Show, Num, Enum, Bounded)

lvl2Ix :: Lvl -> Lvl -> Ix
lvl2Ix (Lvl l) (Lvl x) = Ix (l - x - 1)

pattern xs :> x <- x : xs
  where
    xs :> ~x = x : xs

{-# COMPLETE [], (:>) #-}
