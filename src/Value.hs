module Value where

import Common

--------------------------------------------------------------------------------

data Val
  = VRigid Lvl Sp
  | VFlex MetaVar Sp
  | VChoice ChoiceVar ~Val ~Val
  | VU
  | VPi Name VTy (Val -> VTy)
  | VLam Name (Val -> Val)

type VTy = Val

type Sp = [Val]

type Env = [Val]

pattern VVar x = VRigid x []

pattern VMeta m = VFlex m []
