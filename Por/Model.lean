/-
  Por.Model — a patterns-of-resemblance label model for the 1-Y well-ordering interface
  (no constructible universe, no admissible ordinals, no `Adequate`).

  Labels are ordinals, `lt = (· < ·)`, `D = True`, and

    R k η a b  :⟺  η ≤ a ∧ a < b ∧ 𝔄^a_{k,η} ≼_{Σ₁} 𝔄^b_{k,η}

  where `𝔄^γ_{k,η}` has domain `{x | x < γ}` and relations
    * `x < y`,
    * `Rel_j(x,y,z) :⟺ R j x y z`   for every layer `j`   (internal atoms, all layers),
    * `Top_j(ξ,x)  :⟺ R j ξ x γ`    for `j < k`           (diagonal top predicates),
    * `Top_{k,ξ}(x) :⟺ R k ξ x γ`   for named `ξ < η`     (named top predicates).
  `R` is defined by well-founded recursion on `(top, layer, index)` in lexicographic order.

  The interface in Part 0 is restated from Phyrion, 1Y-Well-Ordering-Lean,
  `formalization/OneY/RootIndexed/Representation.lean` (Apache-2.0), definitions only.
  Tuple and ω₁ helpers are adapted from bms-elem-pattern (`Pattern/Basic.lean`,
  `Pattern/Chain.lean`).
-/
import Mathlib

open Classical Cardinal Ordinal

namespace Por

universe u

/-! ## Part 0. The abstract interface

Restated from `OneY/RootIndexed/Representation.lean` (definitions only) so that the
instantiation can be checked in a Mathlib environment. -/

structure Atom where
  layer : Nat
  root : Nat
  parent : Nat
  child : Nat

def Atom.Valid (e : Atom) (n : Nat) : Prop :=
  e.root ≤ e.parent ∧ e.parent < e.child ∧ e.child < n

structure Diagram where
  size : Nat
  atoms : List Atom
  valid : ∀ e ∈ atoms, e.Valid size

structure TopAtom where
  layer : Nat
  root : Nat
  parent : Nat

def TopAtom.Valid (e : TopAtom) (n : Nat) : Prop :=
  e.root ≤ e.parent ∧ e.parent < n

variable {α : Type u}

def Atom.Holds (R : Nat → α → α → α → Prop) (f : Nat → α) (e : Atom) : Prop :=
  R e.layer (f e.root) (f e.parent) (f e.child)

def TopAtom.Holds (R : Nat → α → α → α → Prop)
    (f : Nat → α) (top : α) (e : TopAtom) : Prop :=
  R e.layer (f e.root) (f e.parent) top

structure Representation (lt : α → α → Prop) (D : α → Prop)
    (R : Nat → α → α → α → Prop) (G : Diagram) (f : Nat → α) : Prop where
  domain : ∀ i, i < G.size → D (f i)
  ordered : ∀ i j, i < j → j < G.size → lt (f i) (f j)
  relations : ∀ e ∈ G.atoms, e.Holds R f

def Bounded (lt : α → α → Prop) (n : Nat) (f : Nat → α) (bound : α) : Prop :=
  ∀ i, i < n → lt (f i) bound

def Admissible (lt : α → α → Prop) (K cut : Nat)
    (theta : α) (f : Nat → α) (d : TopAtom) : Prop :=
  d.layer < K ∨ (d.layer = K ∧ d.root < cut ∧ lt (f d.root) theta)

def FiniteReflection (lt : α → α → Prop) (D : α → Prop)
    (R : Nat → α → α → α → Prop) : Prop :=
  ∀ (G : Diagram) (cut K : Nat) (theta beta : α) (f : Nat → α)
    (needs : List TopAtom),
    cut < G.size → Representation lt D R G f → D beta →
    Bounded lt G.size f beta →
    R K theta (f cut) beta →
    (∀ d ∈ needs, d.Valid G.size) →
    (∀ d ∈ needs, Admissible lt K cut theta f d) →
    (∀ d ∈ needs, d.Holds R f beta) →
    ∃ g : Nat → α,
      Representation lt D R G g ∧
      (∀ i, i < cut → g i = f i) ∧
      Bounded lt G.size g (f cut) ∧
      (∀ d ∈ needs, d.Holds R g (f cut))

abbrev Ord := Ordinal.{0}

/-! ## Tuples (adapted from bms-elem-pattern `Pattern/Basic.lean`) -/

/-- Concatenation: the first `k` entries come from `p`, the rest from `q`. -/
def cat (k : ℕ) (p q : ℕ → Ord) : ℕ → Ord :=
  fun i => if i < k then p i else q (i - k)

theorem cat_left {k : ℕ} {p q : ℕ → Ord} {i : ℕ} (hi : i < k) : cat k p q i = p i := by
  simp [cat, hi]

theorem cat_lt {k m : ℕ} {p x : ℕ → Ord} {B : Ord} (hp : ∀ i < k, p i < B)
    (hx : ∀ i < m, x i < B) : ∀ i < k + m, cat k p x i < B := by
  intro i hi
  unfold cat
  split_ifs with h
  · exact hp i h
  · exact hx _ (by omega)

theorem cat_congr_left {k : ℕ} {p p' q : ℕ → Ord} (h : ∀ i < k, p i = p' i) :
    cat k p q = cat k p' q := by
  funext i
  unfold cat
  split_ifs with hi
  · exact h i hi
  · rfl

/-! ## ω₁ and enumerations below countable ordinals (adapted from `Pattern/Chain.lean`) -/

noncomputable abbrev Om : Ord := ω₁

theorem om_pos : (0 : Ord) < Om := Ordinal.omega_pos 1

theorem om_succ_lt {a : Ord} (h : a < Om) : Order.succ a < Om := by
  have hl : Order.IsSuccLimit (ω₁ : Ord) := by
    rw [← Cardinal.ord_aleph]
    exact Cardinal.isSuccLimit_ord (by simp)
  exact hl.succ_lt h

theorem countable_Iio {γ : Ord} (h : γ < Om) : (Set.Iio γ).Countable := by
  rw [← Cardinal.le_aleph0_iff_set_countable, Cardinal.mk_Iio_ordinal, Cardinal.lift_le_aleph0]
  rw [Om, ← Cardinal.ord_aleph, Cardinal.lt_ord, Cardinal.lt_aleph_one_iff] at h
  exact h

/-- An enumeration of the ordinals below `γ` (onto when `0 < γ < ω₁`). -/
noncomputable def enumBelow (γ : Ord) : ℕ → Ord :=
  if h : (Set.Iio γ).Countable ∧ (Set.Iio γ).Nonempty then
    Classical.choose (h.1.exists_eq_range h.2)
  else fun _ => 0

theorem enumBelow_surj {γ : Ord} (hγ : γ < Om) {a : Ord} (ha : a < γ) :
    ∃ t, enumBelow γ t = a := by
  have h : (Set.Iio γ).Countable ∧ (Set.Iio γ).Nonempty := ⟨countable_Iio hγ, ⟨a, ha⟩⟩
  have hs := Classical.choose_spec (h.1.exists_eq_range h.2)
  have hmem : a ∈ Set.Iio γ := ha
  rw [hs] at hmem
  obtain ⟨t, ht⟩ := hmem
  exact ⟨t, by simp only [enumBelow, dif_pos h]; exact ht⟩

/-- Parameters below `γ`, coded by a list of indices. -/
noncomputable def params (γ : Ord) (l : List ℕ) : ℕ → Ord :=
  fun i => enumBelow γ (l.getD i 0)

theorem exists_params {γ : Ord} (hγ : γ < Om) {k : ℕ} {p : ℕ → Ord}
    (hp : ∀ i < k, p i < γ) : ∃ l : List ℕ, ∀ i < k, params γ l i = p i := by
  choose t ht using fun i (hi : i < k) => enumBelow_surj hγ (hp i hi)
  refine ⟨(List.range k).map fun i => if h : i < k then t i h else 0, fun i hi => ?_⟩
  unfold params
  rw [List.getD_eq_getElem _ _ (by simpa using hi)]
  simp [hi, ht]

/-! ## Part 1. Atomic diagrams and Σ₁ formulas -/


/-- Atomic diagram of an `n`-tuple with signature bound `m`: the `<` bits, the ternary
`Rel_j` bits and the binary `Top_j` bits for `j < m`. A finite type. -/
abbrev Diag (m n : ℕ) :=
  (Fin n → Fin n → Bool) × (Fin m → Fin n → Fin n → Fin n → Bool) × (Fin m → Fin n → Fin n → Bool)

/-- Internal relations `Rel_j(x,y,z)`. -/
abbrev RelF := ℕ → Ord → Ord → Ord → Prop
/-- Top predicates `Top_j(ξ,x)`. -/
abbrev TopF := ℕ → Ord → Ord → Prop

/-- The atomic diagram of `v` (first `n` entries). The bit `Top_j(v a, v b)` is only read
when `allow j a`; otherwise it is `false`. -/
noncomputable def diagM (rel : RelF) (top : TopF) (allow : ℕ → ℕ → Prop) (m n : ℕ)
    (v : ℕ → Ord) : Diag m n :=
  (fun a b => decide (v a < v b),
   fun j a b c => decide (rel j (v a) (v b) (v c)),
   fun j a b => decide (allow j a ∧ top j (v a) (v b)))

/-- `∃ y₀ … y_{bb-1} < M, D(diag(p₀ … p_{r-1}, y₀ … y_{bb-1}))`: a Σ₁ formula with `r`
parameters, evaluated in the structure of height `M`. -/
def Sat (rel : RelF) (top : TopF) (allow : ℕ → ℕ → Prop) (M : Ord) (m n : ℕ)
    (D : Set (Diag m n)) (bb r : ℕ) (p : ℕ → Ord) : Prop :=
  ∃ y : ℕ → Ord, (∀ i < bb, y i < M) ∧ diagM rel top allow m n (cat r p y) ∈ D

/-- Every top bit is visible. -/
def full : ℕ → ℕ → Prop := fun _ _ => True

/-- Visible top bits at level `(k, S)`: all lower layers (diagonal), and layer `k` only
with first argument at a named position `a ∈ S`. -/
def allowL (k : ℕ) (S : Set ℕ) (j a : ℕ) : Prop := j < k ∨ (j = k ∧ a ∈ S)

/-- Σ₁-elementarity at level `(k, η)` between the height-`a` structure (top predicates
`topA`) and the height-`b` structure (top predicates `topB`). Named positions must be
parameters with values `< η`. -/
def ElemL (rel : RelF) (topA topB : TopF) (k : ℕ) (η a b : Ord) : Prop :=
  ∀ (m n : ℕ) (D : Set (Diag m n)) (bb r : ℕ) (S : Set ℕ) (p : ℕ → Ord),
    n ≤ r + bb → (∀ i < r, p i < a) → (∀ s ∈ S, s < r ∧ p s < η) →
    (Sat rel topA (allowL k S) a m n D bb r p ↔ Sat rel topB (allowL k S) b m n D bb r p)

theorem cat_bound {r bb n : ℕ} {p y : ℕ → Ord} {M : Ord} (hn : n ≤ r + bb)
    (hp : ∀ i < r, p i < M) (hy : ∀ i < bb, y i < M) : ∀ a < n, cat r p y a < M :=
  fun a ha => cat_lt hp hy a (by omega)

/-- The diagram only reads the visible bits. -/
theorem diagM_congr {rel rel' : RelF} {top top' : TopF} {allow : ℕ → ℕ → Prop} {m n : ℕ}
    {v : ℕ → Ord}
    (hrel : ∀ j < m, ∀ a < n, ∀ b < n, ∀ c < n,
      (rel j (v a) (v b) (v c) ↔ rel' j (v a) (v b) (v c)))
    (htop : ∀ j < m, ∀ a < n, ∀ b < n, allow j a → (top j (v a) (v b) ↔ top' j (v a) (v b))) :
    diagM rel top allow m n v = diagM rel' top' allow m n v := by
  unfold diagM
  congr 1
  congr 1
  · funext j a b c
    exact decide_eq_decide.mpr (hrel j j.2 a a.2 b b.2 c c.2)
  · funext j a b
    exact decide_eq_decide.mpr (and_congr_right fun h => htop j j.2 a a.2 b b.2 h)

theorem sat_congr {rel rel' : RelF} {top top' : TopF} {allow : ℕ → ℕ → Prop} {M : Ord}
    {m n : ℕ} {D : Set (Diag m n)} {bb r : ℕ} {p : ℕ → Ord}
    (h : ∀ y : ℕ → Ord, (∀ i < bb, y i < M) →
      diagM rel top allow m n (cat r p y) = diagM rel' top' allow m n (cat r p y)) :
    Sat rel top allow M m n D bb r p ↔ Sat rel' top' allow M m n D bb r p := by
  unfold Sat
  refine exists_congr fun y => and_congr_right fun hy => ?_
  rw [h y hy]

/-- Hiding bits is a function of the full diagram. -/
noncomputable def maskD {m n : ℕ} (allow : ℕ → ℕ → Prop) (d : Diag m n) : Diag m n :=
  (d.1, d.2.1, fun j a b => decide (allow j a) && d.2.2 j a b)

theorem diagM_mask (rel : RelF) (top : TopF) (allow : ℕ → ℕ → Prop) (m n : ℕ)
    (v : ℕ → Ord) :
    diagM rel top allow m n v = maskD allow (diagM rel top full m n v) := by
  unfold diagM maskD full
  congr 1
  congr 1
  funext j a b
  by_cases h : allow j a <;> simp [h]

/-- A level-restricted formula is a full formula with a masked matrix. -/
theorem sat_mask {rel : RelF} {top : TopF} {allow : ℕ → ℕ → Prop} {M : Ord} {m n : ℕ}
    {D : Set (Diag m n)} {bb r : ℕ} {p : ℕ → Ord} :
    Sat rel top allow M m n D bb r p ↔ Sat rel top full M m n (maskD allow ⁻¹' D) bb r p := by
  unfold Sat
  simp only [Set.mem_preimage, ← diagM_mask]

/-! ## Part 2. The recursion on (top, layer, index) -/

/-- `(top, layer, index)`. -/
abbrev Idx := Ord × ℕ × Ord

abbrev ilt : Idx → Idx → Prop := Prod.Lex (· < ·) (Prod.Lex (· < ·) (· < ·))

theorem ilt_wf : WellFounded ilt :=
  WellFounded.prod_lex wellFounded_lt (WellFounded.prod_lex wellFounded_lt wellFounded_lt)

/-- One recursion step at `t = (b, k, η)`: the set of `a` with `R k η a b`, computed from the
values at lexicographically smaller triples. -/
noncomputable def stepF (t : Idx) (IH : ∀ t' : Idx, ilt t' t → Ord → Prop) : Ord → Prop :=
  fun a => t.2.2 ≤ a ∧ a < t.1 ∧
    ElemL (fun j x y z => ∃ h : z < t.1, IH (z, j, x) (Prod.Lex.left _ _ h) y)
      (fun j ξ x => ∃ h : a < t.1, IH (a, j, ξ) (Prod.Lex.left _ _ h) x)
      (fun j ξ x => ∃ h : Prod.Lex (· < ·) (· < ·) (j, ξ) t.2,
        IH (t.1, j, ξ) (Prod.Lex.right _ h) x)
      t.2.1 t.2.2 a t.1

noncomputable def RF : Idx → Ord → Prop := ilt_wf.fix stepF

/-- `R k η a b`: in layer `k` with root index `η`, the label `a` is stable into `b`. -/
noncomputable def R (k : ℕ) (η a b : Ord) : Prop := RF (b, k, η) a

theorem RF_eq (t : Idx) : RF t = stepF t (fun t' _ => RF t') :=
  WellFounded.fix_eq _ _ _

/-- The true internal relations. -/
def relR : RelF := fun j x y z => R j x y z

/-- The true top predicates of the height-`γ` structure. -/
def topR (γ : Ord) : TopF := fun j ξ x => R j ξ x γ

/-- Σ₁-elementarity at level `(k, η)` for the true structures. -/
def Elem (k : ℕ) (η a b : Ord) : Prop := ElemL relR (topR a) (topR b) k η a b

/-- Absoluteness of the recursion: the stage relations agree with the true ones on
everything a level-`(k,η)` formula can read. -/
theorem elem_stage {k : ℕ} {η a b : Ord} (hab : a < b) :
    ElemL (fun j x y z => ∃ _ : z < b, RF (z, j, x) y)
      (fun j ξ x => ∃ _ : a < b, RF (a, j, ξ) x)
      (fun j ξ x => ∃ _ : Prod.Lex (· < ·) (· < ·) (j, ξ) (k, η), RF (b, j, ξ) x)
      k η a b ↔ Elem k η a b := by
  unfold Elem ElemL
  refine forall_congr' fun m => forall_congr' fun n => forall_congr' fun D =>
    forall_congr' fun bb => forall_congr' fun r => forall_congr' fun S =>
    forall_congr' fun p => forall_congr' fun hn => forall_congr' fun hp =>
    forall_congr' fun hS => ?_
  refine iff_congr (sat_congr fun y hy => diagM_congr ?_ ?_)
    (sat_congr fun y hy => diagM_congr ?_ ?_)
  · intro j _ x _ y' _ z hz
    have hza : cat r p y z < a := cat_bound hn hp hy z hz
    exact ⟨fun ⟨_, h⟩ => h, fun h => ⟨hza.trans hab, h⟩⟩
  · intro j _ x _ y' _ _
    exact ⟨fun ⟨_, h⟩ => h, fun h => ⟨hab, h⟩⟩
  · intro j _ x _ y' _ z hz
    have hzb : cat r p y z < b := cat_bound hn (fun i hi => (hp i hi).trans hab) hy z hz
    exact ⟨fun ⟨_, h⟩ => h, fun h => ⟨hzb, h⟩⟩
  · intro j _ x _ y' _ hallow
    have hlex : Prod.Lex (· < ·) (· < ·) (j, cat r p y x) (k, η) := by
      rcases hallow with hj | ⟨rfl, hxS⟩
      · exact Prod.Lex.left _ _ hj
      · obtain ⟨hxr, hpx⟩ := hS x hxS
        rw [cat_left hxr]
        exact Prod.Lex.right _ hpx
    exact ⟨fun ⟨_, h⟩ => h, fun h => ⟨hlex, h⟩⟩

/-- The defining equation of `R`. -/
theorem R_iff {k : ℕ} {η a b : Ord} : R k η a b ↔ η ≤ a ∧ a < b ∧ Elem k η a b := by
  unfold R
  rw [RF_eq]
  exact and_congr_right fun _ =>
    ⟨fun ⟨hab, h⟩ => ⟨hab, (elem_stage hab).mp h⟩, fun ⟨hab, h⟩ => ⟨hab, (elem_stage hab).mpr h⟩⟩

/-! ## Part 3. O3 and O4 -/

/-- O3: strictness. -/
theorem R_lt {k : ℕ} {η a b : Ord} (h : R k η a b) : a < b := (R_iff.mp h).2.1

theorem R_index_le {k : ℕ} {η a b : Ord} (h : R k η a b) : η ≤ a := (R_iff.mp h).1

/-- O4: weakening of the root index (also the non-strict version holds). -/
theorem R_weaken {k : ℕ} {small large p c : Ord} (hsl : small ≤ large) (h : R k large p c) :
    R k small p c := by
  obtain ⟨hle, hpc, e⟩ := R_iff.mp h
  refine R_iff.mpr ⟨hsl.trans hle, hpc, ?_⟩
  intro m n D bb r S q hn hq hS
  exact e m n D bb r S q hn hq fun s hs => ⟨(hS s hs).1, (hS s hs).2.trans_le hsl⟩

/-! ## Part 4. O6: finite reflection -/

def getLt {m n : ℕ} (d : Diag m n) (a b : ℕ) : Bool :=
  if h : a < n ∧ b < n then d.1 ⟨a, h.1⟩ ⟨b, h.2⟩ else false

def getRel {m n : ℕ} (d : Diag m n) (j a b c : ℕ) : Bool :=
  if h : j < m ∧ a < n ∧ b < n ∧ c < n then
    d.2.1 ⟨j, h.1⟩ ⟨a, h.2.1⟩ ⟨b, h.2.2.1⟩ ⟨c, h.2.2.2⟩ else false

def getTop {m n : ℕ} (d : Diag m n) (j a b : ℕ) : Bool :=
  if h : j < m ∧ a < n ∧ b < n then d.2.2 ⟨j, h.1⟩ ⟨a, h.2.1⟩ ⟨b, h.2.2⟩ else false

theorem getLt_diagM {rel : RelF} {top : TopF} {allow : ℕ → ℕ → Prop} {m n : ℕ}
    {v : ℕ → Ord} {a b : ℕ} (ha : a < n) (hb : b < n) :
    getLt (diagM rel top allow m n v) a b = true ↔ v a < v b := by
  simp [getLt, diagM, ha, hb]

theorem getRel_diagM {rel : RelF} {top : TopF} {allow : ℕ → ℕ → Prop} {m n : ℕ}
    {v : ℕ → Ord} {j a b c : ℕ} (hj : j < m) (ha : a < n) (hb : b < n) (hc : c < n) :
    getRel (diagM rel top allow m n v) j a b c = true ↔ rel j (v a) (v b) (v c) := by
  simp [getRel, diagM, hj, ha, hb, hc]

theorem getTop_diagM {rel : RelF} {top : TopF} {allow : ℕ → ℕ → Prop} {m n : ℕ}
    {v : ℕ → Ord} {j a b : ℕ} (hj : j < m) (ha : a < n) (hb : b < n) :
    getTop (diagM rel top allow m n v) j a b = true ↔ (allow j a ∧ top j (v a) (v b)) := by
  simp [getTop, diagM, hj, ha, hb]

/-- A bound for all layers occurring in the diagram and in the demands. -/
def sigBound (G : Diagram) (needs : List TopAtom) : ℕ :=
  (G.atoms.map Atom.layer).sum + (needs.map TopAtom.layer).sum + 1

theorem atom_layer_lt {G : Diagram} {needs : List TopAtom} {e : Atom} (he : e ∈ G.atoms) :
    e.layer < sigBound G needs := by
  have := List.le_sum_of_mem (List.mem_map_of_mem (f := Atom.layer) he)
  unfold sigBound
  omega

theorem need_layer_lt {G : Diagram} {needs : List TopAtom} {d : TopAtom} (hd : d ∈ needs) :
    d.layer < sigBound G needs := by
  have := List.le_sum_of_mem (List.mem_map_of_mem (f := TopAtom.layer) hd)
  unfold sigBound
  omega

/-- The matrix of the reflected formula: order of all columns, all internal atoms, all
demands toward the top. -/
def reflMat (G : Diagram) (needs : List TopAtom) (m : ℕ) : Set (Diag m G.size) :=
  {d | (∀ i j, i < j → j < G.size → getLt d i j = true) ∧
       (∀ e ∈ G.atoms, getRel d e.layer e.root e.parent e.child = true) ∧
       (∀ dd ∈ needs, getTop d dd.layer dd.root dd.parent = true)}

theorem reflMat_iff (G : Diagram) (needs : List TopAtom)
    (hneeds : ∀ d ∈ needs, d.Valid G.size)
    (rel : RelF) (top : TopF) (allow : ℕ → ℕ → Prop) (v : ℕ → Ord) :
    diagM rel top allow (sigBound G needs) G.size v ∈ reflMat G needs (sigBound G needs) ↔
      (∀ i j, i < j → j < G.size → v i < v j) ∧
      (∀ e ∈ G.atoms, rel e.layer (v e.root) (v e.parent) (v e.child)) ∧
      (∀ dd ∈ needs, allow dd.layer dd.root ∧ top dd.layer (v dd.root) (v dd.parent)) := by
  refine and_congr (forall_congr' fun i => forall_congr' fun j => forall_congr' fun hij =>
    forall_congr' fun hj => getLt_diagM (by omega) hj) (and_congr ?_ ?_)
  · refine forall_congr' fun e => forall_congr' fun he => ?_
    obtain ⟨h1, h2, h3⟩ := G.valid e he
    exact getRel_diagM (atom_layer_lt he) (by omega) (by omega) h3
  · refine forall_congr' fun dd => forall_congr' fun hdd => ?_
    obtain ⟨h1, h2⟩ := hneeds dd hdd
    exact getTop_diagM (need_layer_lt hdd) (by omega) h2

/-- O6: `FiniteReflection` for the model. -/
theorem finiteReflection : FiniteReflection (α := Ord) (· < ·) (fun _ => True) R := by
  intro G cut K θ β f needs hcut hf _ hbound hctrl hvalid hadm hneeds
  obtain ⟨_, _, e⟩ := R_iff.mp hctrl
  let S : Set ℕ := {s | ∃ d ∈ needs, d.layer = K ∧ d.root = s}
  have hS : ∀ s ∈ S, s < cut ∧ f s < θ := by
    rintro s ⟨d, hd, hK, rfl⟩
    rcases hadm d hd with hlt | ⟨_, hr, hθ'⟩
    · exact absurd hK (Nat.ne_of_lt hlt)
    · exact ⟨hr, hθ'⟩
  have hallow : ∀ d ∈ needs, allowL K S d.layer d.root := by
    intro d hd
    rcases hadm d hd with hlt | ⟨hK, _, _⟩
    · exact Or.inl hlt
    · exact Or.inr ⟨hK, d, hd, hK, rfl⟩
  have hp : ∀ i < cut, f i < f cut := fun i hi => hf.ordered i cut hi hcut
  have hn : G.size ≤ cut + (G.size - cut) := by omega
  -- the formula holds in the structure of height `β`, witnessed by the old labels
  have hβ : Sat relR (topR β) (allowL K S) β (sigBound G needs) G.size
      (reflMat G needs (sigBound G needs)) (G.size - cut) cut f := by
    refine ⟨fun i => f (cut + i), fun i hi => hbound _ (by omega), ?_⟩
    have hv : cat cut f (fun i => f (cut + i)) = f := by
      funext i
      unfold cat
      split_ifs with h
      · rfl
      · show f (cut + (i - cut)) = f i
        congr 1
        omega
    rw [hv, reflMat_iff G needs hvalid]
    exact ⟨hf.ordered, hf.relations, fun d hd => ⟨hallow d hd, hneeds d hd⟩⟩
  -- reflect it into the structure of height `f cut`
  obtain ⟨y, hy, hD⟩ :=
    (e (sigBound G needs) G.size (reflMat G needs (sigBound G needs)) (G.size - cut) cut S f
      hn hp hS).mpr hβ
  rw [reflMat_iff G needs hvalid] at hD
  obtain ⟨hord, hrel, htop⟩ := hD
  refine ⟨cat cut f y, ⟨fun _ _ => trivial, hord, hrel⟩, fun i hi => cat_left hi,
    fun (i : ℕ) (hi : i < G.size) => cat_lt hp hy i (by omega), fun d hd => (htop d hd).2⟩

/-! ## Part 5. O7: a chain related at every level, by a closure argument in ω₁ -/


/-- `(γ; <, R, Top^{ω₁}) ≼_{Σ₁} (ω₁; <, R, Top^{ω₁})` (full language, top predicates of `ω₁`). -/
def Good (γ : Ord) : Prop :=
  ∀ (m n : ℕ) (D : Set (Diag m n)) (bb r : ℕ) (p : ℕ → Ord), n ≤ r + bb →
    (∀ i < r, p i < γ) →
    (Sat relR (topR Om) full γ m n D bb r p ↔ Sat relR (topR Om) full Om m n D bb r p)

/-- Formulas: signature bound, size, matrix, number of witnesses, number of parameters. -/
abbrev Form : Type := Σ m n : ℕ, Set (Diag m n) × ℕ × ℕ

/-- The height of a chosen witness of a true Σ₁ statement in `ω₁` (`0` otherwise). -/
noncomputable def witHeight (φ : Form) (p : ℕ → Ord) : Ord :=
  match φ with
  | ⟨m, n, D, bb, r⟩ =>
    if h : Sat relR (topR Om) full Om m n D bb r p then
      (Finset.range bb).sup fun i => Order.succ (Classical.choose h i)
    else 0

theorem witHeight_lt (φ : Form) (p : ℕ → Ord) : witHeight φ p < Om := by
  obtain ⟨m, n, D, bb, r⟩ := φ
  simp only [witHeight]
  split_ifs with h
  · refine (Finset.sup_lt_iff (lt_of_le_of_lt bot_le om_pos)).mpr fun i hi => ?_
    exact om_succ_lt ((Classical.choose_spec h).1 i (Finset.mem_range.mp hi))
  · exact om_pos

/-- One closure step. -/
noncomputable def next (γ : Ord) : Ord :=
  Order.succ (max γ (⨆ q : Form × List ℕ, witHeight q.1 (params γ q.2)))

theorem lt_next (γ : Ord) : γ < next γ :=
  lt_of_le_of_lt (le_max_left _ _) (Order.lt_succ _)

theorem next_lt {γ : Ord} (h : γ < Om) : next γ < Om :=
  om_succ_lt (max_lt h (Ordinal.iSup_lt_omega_one fun _ => witHeight_lt _ _))

theorem wit_below {γ : Ord} (hγ : γ < Om) {m n : ℕ} {D : Set (Diag m n)} {bb r : ℕ}
    {p : ℕ → Ord} (hp : ∀ i < r, p i < γ) (h : Sat relR (topR Om) full Om m n D bb r p) :
    ∃ y : ℕ → Ord, (∀ i < bb, y i < next γ) ∧
      diagM relR (topR Om) full m n (cat r p y) ∈ D := by
  obtain ⟨l, hl⟩ := exists_params hγ hp
  have hc : ∀ q : ℕ → Ord, cat r (params γ l) q = cat r p q :=
    fun q => cat_congr_left hl
  have h' : Sat relR (topR Om) full Om m n D bb r (params γ l) := by
    obtain ⟨y, hy, hD⟩ := h
    exact ⟨y, hy, by rw [hc]; exact hD⟩
  refine ⟨Classical.choose h', fun i hi => ?_, ?_⟩
  · have hw : witHeight ⟨m, n, D, bb, r⟩ (params γ l) =
        (Finset.range bb).sup fun i => Order.succ (Classical.choose h' i) := by
      simp only [witHeight, dif_pos h']
    have h1 : Order.succ (Classical.choose h' i) ≤ witHeight ⟨m, n, D, bb, r⟩ (params γ l) := by
      rw [hw]
      exact Finset.le_sup (f := fun i => Order.succ (Classical.choose h' i))
        (Finset.mem_range.mpr hi)
    have h2 : witHeight ⟨m, n, D, bb, r⟩ (params γ l) ≤
        ⨆ q : Form × List ℕ, witHeight q.1 (params γ q.2) :=
      Ordinal.le_iSup (fun q : Form × List ℕ => witHeight q.1 (params γ q.2))
        (⟨m, n, D, bb, r⟩, l)
    exact ((Order.lt_succ _).trans_le (h1.trans (h2.trans (le_max_right γ _)))).trans
      (Order.lt_succ _)
  · have := (Classical.choose_spec h').2
    rwa [hc] at this

/-- `γ, next γ, next (next γ), …` -/
noncomputable def tower (γ : Ord) : ℕ → Ord
  | 0 => γ
  | t + 1 => next (tower γ t)

noncomputable def lam (γ : Ord) : Ord := ⨆ t, tower γ t

theorem tower_lt {γ : Ord} (hγ : γ < Om) : ∀ t, tower γ t < Om
  | 0 => hγ
  | t + 1 => next_lt (tower_lt hγ t)

theorem tower_mono (γ : Ord) {t t' : ℕ} (h : t ≤ t') : tower γ t ≤ tower γ t' := by
  induction h with
  | refl => exact le_rfl
  | step _ ih => exact ih.trans (lt_next _).le

theorem tower_le_lam (γ : Ord) (t : ℕ) : tower γ t ≤ lam γ :=
  Ordinal.le_iSup (fun t => tower γ t) t

theorem lam_lt {γ : Ord} (hγ : γ < Om) : lam γ < Om :=
  Ordinal.iSup_lt_omega_one (tower_lt hγ)

theorem lt_lam (γ : Ord) : γ < lam γ :=
  (lt_next γ).trans_le (tower_le_lam γ 1)

theorem exists_tower {γ : Ord} {p : ℕ → Ord} :
    ∀ k, (∀ i < k, p i < lam γ) → ∃ t, ∀ i < k, p i < tower γ t
  | 0, _ => ⟨0, fun i hi => absurd hi (by omega)⟩
  | k + 1, hp => by
    obtain ⟨t, ht⟩ := exists_tower k fun i hi => hp i (by omega)
    obtain ⟨t', ht'⟩ := Ordinal.lt_iSup_iff.mp (hp k (by omega))
    refine ⟨max t t', fun i hi => ?_⟩
    rcases (by omega : i < k ∨ i = k) with h | rfl
    · exact (ht i h).trans_le (tower_mono γ (le_max_left _ _))
    · exact ht'.trans_le (tower_mono γ (le_max_right _ _))

/-- The closure points are Σ₁-elementary in `ω₁`. -/
theorem lam_good {γ : Ord} (hγ : γ < Om) : Good (lam γ) := by
  intro m n D bb r p _ hp
  constructor
  · rintro ⟨y, hy, hD⟩
    exact ⟨y, fun i hi => (hy i hi).trans (lam_lt hγ), hD⟩
  · intro h
    obtain ⟨t, ht⟩ := exists_tower r hp
    obtain ⟨y, hy, hD⟩ := wit_below (tower_lt hγ t) ht h
    exact ⟨y, fun i hi => (hy i hi).trans_le (tower_le_lam γ (t + 1)), hD⟩

/-- One step of the absoluteness induction. -/
theorem sat_abs {α : Ord} (hα : Good α) {j : ℕ} {ζ : Ord}
    (ih : ∀ q : ℕ × Ord, Prod.Lex (· < ·) (· < ·) q (j, ζ) → q.2 < α →
      ∀ x < α, (R q.1 q.2 x α ↔ R q.1 q.2 x Om))
    {m n : ℕ} {D : Set (Diag m n)} {bb r : ℕ} {S : Set ℕ} {p : ℕ → Ord}
    (hn : n ≤ r + bb) (hp : ∀ i < r, p i < α) (hS : ∀ s ∈ S, s < r ∧ p s < ζ) :
    Sat relR (topR α) (allowL j S) α m n D bb r p ↔
      Sat relR (topR Om) (allowL j S) Om m n D bb r p := by
  have h1 : Sat relR (topR α) (allowL j S) α m n D bb r p ↔
      Sat relR (topR Om) (allowL j S) α m n D bb r p := by
    refine sat_congr fun y hy => diagM_congr (fun _ _ _ _ _ _ _ _ => Iff.rfl) ?_
    intro i _ a ha b hb hallow
    have hva := cat_bound hn hp hy a ha
    have hvb := cat_bound hn hp hy b hb
    rcases hallow with hi | ⟨rfl, haS⟩
    · exact ih (i, _) (Prod.Lex.left _ _ hi) hva _ hvb
    · obtain ⟨har, hpa⟩ := hS a haS
      have hva' : cat r p y a < ζ := by rw [cat_left har]; exact hpa
      exact ih (i, _) (Prod.Lex.right _ hva') hva _ hvb
  rw [h1]
  exact sat_mask.trans ((hα m n _ bb r p hn hp).trans sat_mask.symm)

/-- Absoluteness of the top predicates at a good `α`: `Top^α = Top^{ω₁}` below `α`. -/
theorem top_abs {α : Ord} (hα : Good α) (hαΩ : α < Om) (q : ℕ × Ord) :
    q.2 < α → ∀ x < α, (R q.1 q.2 x α ↔ R q.1 q.2 x Om) := by
  refine (WellFounded.prod_lex (wellFounded_lt (α := ℕ)) (wellFounded_lt (α := Ord))).induction
    (C := fun q : ℕ × Ord => q.2 < α → ∀ x < α, (R q.1 q.2 x α ↔ R q.1 q.2 x Om)) q ?_
  rintro ⟨j, ζ⟩ ih _ x hx
  rw [R_iff, R_iff]
  refine and_congr_right fun _ => ⟨fun ⟨_, e⟩ => ⟨hx.trans hαΩ, ?_⟩, fun ⟨_, e⟩ => ⟨hx, ?_⟩⟩
  · intro m n D bb r S p hn hp hS
    rw [← sat_abs hα ih hn (fun i hi => (hp i hi).trans hx) hS]
    exact e m n D bb r S p hn hp hS
  · intro m n D bb r S p hn hp hS
    rw [sat_abs hα ih hn (fun i hi => (hp i hi).trans hx) hS]
    exact e m n D bb r S p hn hp hS

/-- `lam 0 < lam (lam 0) < ⋯`, all good. -/
noncomputable def cC : ℕ → Ord
  | 0 => lam 0
  | t + 1 => lam (cC t)

theorem cC_lt : ∀ t, cC t < Om
  | 0 => lam_lt om_pos
  | t + 1 => lam_lt (cC_lt t)

theorem cC_strictMono : StrictMono cC :=
  strictMono_nat_of_lt_succ fun t => lt_lam (cC t)

theorem cC_good : ∀ t, Good (cC t)
  | 0 => lam_good om_pos
  | t + 1 => lam_good (cC_lt t)

/-- Members of the chain are related at every layer and every root index `η ≤` the smaller. -/
theorem chain_R {i j : ℕ} (hij : i < j) (k : ℕ) {η : Ord} (hη : η ≤ cC i) :
    R k η (cC i) (cC j) := by
  have hlt : cC i < cC j := cC_strictMono hij
  refine R_iff.mpr ⟨hη, hlt, ?_⟩
  intro m n D bb r S p hn hp _
  have hA : ∀ {γ : Ord}, Good γ → γ < Om → ∀ {q : ℕ → Ord}, (∀ i < r, q i < γ) →
      (Sat relR (topR γ) (allowL k S) γ m n D bb r q ↔
        Sat relR (topR Om) full Om m n (maskD (allowL k S) ⁻¹' D) bb r q) := by
    intro γ hγ hγΩ q hq
    rw [← hγ m n _ bb r q hn hq, ← sat_mask]
    refine sat_congr fun y hy => diagM_congr (fun _ _ _ _ _ _ _ _ => Iff.rfl) ?_
    intro i' _ a ha b hb _
    exact top_abs hγ hγΩ (i', _) (cat_bound hn hq hy a ha) _ (cat_bound hn hq hy b hb)
  rw [hA (cC_good i) (cC_lt i) hp, hA (cC_good j) (cC_lt j) fun i' hi' => (hp i' hi').trans hlt]

/-- O7 (stronger): every finite diagram has a representation. -/
theorem initial_all (G : Diagram) :
    ∃ f, Representation (α := Ord) (· < ·) (fun _ => True) R G f := by
  refine ⟨cC, ⟨fun _ _ => trivial, fun i j hij _ => cC_strictMono hij, fun e he => ?_⟩⟩
  obtain ⟨h1, h2, _⟩ := G.valid e he
  exact chain_R h2 e.layer (cC_strictMono.monotone h1)

/-! ## Summary: all hypotheses of `OneY.RootIndexed.actual_expansion_wellFounded` -/

theorem model_obligations :
    WellFounded (α := Ord) (· < ·) ∧
    (∀ {a b c : Ord}, a < b → b < c → a < c) ∧
    (∀ {k : ℕ} {index a b : Ord}, R k index a b → a < b) ∧
    (∀ {k : ℕ} {small large p c : Ord}, small < large → R k large p c → R k small p c) ∧
    FiniteReflection (α := Ord) (· < ·) (fun _ => True) R ∧
    (∀ G : Diagram, ∃ f, Representation (α := Ord) (· < ·) (fun _ => True) R G f) :=
  ⟨Ordinal.lt_wf, fun h1 h2 => h1.trans h2, fun h => R_lt h, fun h hR => R_weaken h.le hR,
    finiteReflection, initial_all⟩

end Por

#print axioms Por.model_obligations
