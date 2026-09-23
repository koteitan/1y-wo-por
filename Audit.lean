/-
Axiom audit of 1y-wo-por.

This file is not part of any `lean_lib`. Check it with
`leanman check -C . Audit.lean` (or `lake env lean Audit.lean`) after building
`ZeroY OneY Por`. Every line below should print
`[propext, Classical.choice, Quot.sound]`.
-/
import Por

-- The four final 1-Y theorems.
#print axioms Por.expansion_wellFounded
#print axioms Por.generated_strictWellOrder
#print axioms Por.descendants_strictWellOrder
#print axioms Por.expansion_chain_reaches_empty

-- The model: all hypotheses of the core theorem, finite reflection, initial representations.
#print axioms Por.model_obligations
#print axioms Por.finiteReflection
#print axioms Por.initial_all

-- The relation R and its defining equation.
#print axioms Por.R_iff

-- The combinatorial core (adapted from Phyrion's project) that the model is plugged into.
#print axioms OneY.RootIndexed.actual_expansion_wellFounded
