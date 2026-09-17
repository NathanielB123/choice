# choice

Pattern unification extended with a "choice" operator.

## Motivation

In order to solve a higher-order unification problem that has a unique solution but some of its subproblems have multiple solutions.

Consider the following unification problem:

```
metactx:
  ?0 : ℕ → ℕ → ℕ → Type

m : ℕ, n : ℕ ⊢ (?0 m n m ≟ Fin m) ∧ (?0 m n n ≟ Fin n)
```

This has the unique solution `?0 ≔ λ _ _ o -> Fin o`, but each subproblems have two distinct solutions.

The problem is clearly outside the pattern fragment. Pruning can't handle this situation either, because it can only prune non-linear vars that don't occur on the RHS. We also can't postpone these, since there are no other subproblems. We could of cource use backtracking, but that may be expensive.

The idea is that, when solving the first subproblem, we represent the alternatives using the choice operator:

```
metactx:
  ?0 : ℕ → ℕ → ℕ → Type = λ m n o → Fin (m | o)

m : ℕ, n : ℕ ⊢ ?0 m n n ≟ Fin n
```

We then continue working on the remaining problem:

```
metactx :
  ?0 : ℕ → ℕ → ℕ → Type = λ m n o → Fin (m | o)

m : ℕ, n : ℕ ⊢ ?0 m n n ≟ Fin n
    ⇓ reduce ?0 m n n
m : ℕ, n : ℕ ⊢ Fin (m | n) ≟ Fin n
```

At this point, we can determine that the the left branch can't satisfy the equation, and can refine so that the choice selects the right branch. Now, `?0` computes to `λ m n o → Fin o`, which is the solution we want.

So, roughly speaking, the idea is to keep a finite set of possible unifiers, and let other constraints rule out alternatives.

## Alternative

Actually, Agda can solve the example problem!

```agda
open import Relation.Binary.PropositionalEquality
open import Data.Nat
open import Data.Fin

test : Set
test =
  let α : ℕ → ℕ → ℕ → Set
      α = _ in

  let p : ∀ m n → α m n m ≡ Fin m
      p _ _ = refl in

  let q : ∀ m n → α m n n ≡ Fin n
      q _ _ = refl in

  ℕ
```

Agda prunes the second argument of `α` when solving the constraint for `p`, because `n` doesn't occur in the RHS:

```agda
α ≔ λ m n o → β m o
```

Now the constraint for `q` becomes `m : ℕ, n : ℕ ⊢ β m n ≡ Fin n`, which is inside the pattern fragment.

I'm not sure which is stronger.

## Acknowledgment

This implementation extends András Kovács's [elaboration-zoo](https://github.com/AndrasKovacs/elaboration-zoo).
Also it is his idea that we represent alternatives using the choice operator.
My original idea was to use some meta-level enum type and case expression over enum values to keep alternatives.
