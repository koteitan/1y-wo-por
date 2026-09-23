[← PLAN](../PLAN.md) | [移植計画 →](02-port.md)

# 設計：patterns of resemblance による 1-Y の整礎性

PLAN の手順 1、2 のノートである。意味の層が満たすべき義務を正確に並べ（§2）、それを満たす関係を順序数だけで定義し（§3）、各義務を証明する（§4）。§5 に残るリスク、§6 に Lean での実装の手順を書く。組合せの層の移植は [02-port.md](02-port.md) に分けた。

Phyrion 氏のリポジトリ [Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)（Apache-2.0）は、リビジョン [`6533b29`](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean/tree/6533b2975f3cafb3582dc8f8127e9ea7144d7e69) を使う。以下、そのファイルはリポジトリの根からの相対パスで書く。

## 0. 要約

- 目標：1-Y 数列システムの展開の整礎性と、標準形の整列性を示す。許容順序数も、構成的宇宙 $`L`$ も、`Adequate` も使わない。
- 方法：Phyrion 氏の証明の組合せの層（`formalization/OneY`、`formalization/ZeroY`）は変えずに使う。意味の層（`formalization/Concrete/OneYTruth`）を、順序数の上に直接定義した関係 $`R`$ に取り替える。
- 関係：$`R(k,η,a,b)`$ は「段 $`(k,η)`$ の言語で、高さ $`a`$ の構造が高さ $`b`$ の構造の $`Σ_1`$ 初等部分構造である」ことである。言語は、すべての層の $`R`$（高さより下の点どうし）と、高さへの $`R`$ を表す上端述語を持つ。$`R`$ は（上端、層、根の添字）の辞書式順序による整礎再帰で定義する。
- 状態（2026-09-23）：
  - 定義と全義務の証明を Lean で書いた。`Por/Model.lean`（653 行、`import Mathlib` だけ、名前空間 `Por`）である。Lean 4.33.1 と Mathlib v4.33.1 で緑。公理は `propext`、`Classical.choice`、`Quot.sound` だけである。
  - 同じモデルを、Phyrion 氏の組合せの層（`6533b29` のビルド済み `.olean`、無改変）に差し込んだ。1-Y の 4 つの最終定理が緑になった。公理は同じ 3 つである。
  - `Por/Model.lean` は、コアのインターフェースを書き写した版（Part 0）の上で証明している。Phyrion 氏の `Representation.lean`（Std だけに依存）を取り込んで、書き写しを本物の import に替え、ファイルを分ける（§6）。最終定理 4 つは、コアの移植のあとで入れる。
- 残る仕事は数学ではなく移植である。組合せの層は、ライセンスの無い YesMetaZFC に依存する。その部分を自前で書き直す（[02-port.md](02-port.md)）。
- このノートは 1-Y だけを扱う。ω-Y（wy-wo-por）は 1-Y の後で扱う。

## 1. 全体の形

Phyrion 氏の証明は二層に分かれる。

- 組合せの層。1-Y 数列の山を有限の図式（`Diagram`）にし、各列に順序数のラベルを付ける。展開したあとの図式にも、末尾のラベルがもっと小さいラベル付けがあることを示す。ラベルの順序は整礎なので、展開も整礎になる。この層が使うのは、ラベルの型 $`α`$、順序 `lt`、定義域 `D`、関係 `R` と、それらについての 6 つの仮定だけである。
- 意味の層。6 つの仮定を満たす $`(α, \mathrm{lt}, D, R)`$ を与える。Phyrion 氏の意味の層では、$`α`$ は順序数、$`D`$ は `Adequate`（$`L_a`$ が分出と収集を満たす。許容順序数に当たる）、$`R`$ は $`L`$ の上の混合真理の塔の $`Σ_1`$ 保存である。

このリポジトリは意味の層だけを取り替える。組合せの層の定理はそのまま使う。

[bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) は BMS で同じことをした。許容順序数のラベルを、Carlson の構造 $`\mathcal R_N = (\mathrm{Ord}; ≤, ≤_1, …, ≤_N)`$ に替えた。1-Y では段の添字が $`ω × ω_1`$ の 2 次元になる。$`Σ_n`$ の段の数では超限の添字を表せない。そこで段はすべて $`Σ_1`$ にし、上端への関係を原子記号として持たせる（§3.8）。

## 2. 義務の一覧

### 2.1 入口の定理

組合せの層の入口は、`formalization/OneY/RootIndexed/ExpansionWellFounded.lean` の次の定理である（Phyrion 氏のコード、Apache-2.0）。

```lean
namespace OneY.RootIndexed
variable {α : Type u}

theorem actual_expansion_wellFounded
    (lt : α → α → Prop) (D : α → Prop) (R : Nat → α → α → α → Prop)
    (hWF : WellFounded lt)
    (hTrans : ∀ {a b c}, lt a b → lt b c → lt a c)
    (hStrict : ∀ {k index a b}, R k index a b → lt a b)
    (hWeak : ∀ {k small large p c}, lt small large → R k large p c → R k small p c)
    (reflection : FiniteReflection lt D R)
    (initial : ∀ s : ZeroY.Expr, ∃ f, Representation lt D R (exprDiagram s) f) :
    WellFounded (ZeroY.ExpansionStep expand)
```

- `α` は宇宙について多相である。`α := Ordinal.{0}`（`Type 1`）でよい。
- `expand` は `OneY.Numeric.expand`（1-Y の展開）である。`exprDiagram s := sequenceDiagram s.values s.legal (sequenceBound s.values)` は、式 `s` の実際の山の図式である。

残りの 3 つの最終定理は `formalization/OneY/Dynamics.lean`（名前空間 `OneY.Numeric`）にある。どれも `hWF : WellFounded Step`（`Step := ZeroY.ExpansionStep expand`）だけを仮定に取り、ほかに意味の入力は無い。

- `generated_strictWellOrder hWF : StrictWellOrder GeneratedExpr GeneratedLt`
- `descendants_strictWellOrder hWF (root : ZeroY.Expr) : StrictWellOrder (Descendant root) DescendantLt`
- `expansion_chain_reaches_empty hWF chain hNext : ∃ n, (chain n).values = []`

したがって、意味の層が満たすべきものは、`actual_expansion_wellFounded` の 4 つのデータと 6 つの仮定で全部である。

### 2.2 インターフェースの定義

`formalization/OneY/RootIndexed/Representation.lean` から引用する（Apache-2.0。`deriving DecidableEq` だけ省いた）。

```lean
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
```

読み方。

- `R k η a b`：層 $`k`$、根の添字 $`η`$ で、親のラベル $`a`$ が、子のラベルまたは上端 $`b`$ へ安定している。
- `Atom` $`(k,r,p,q)`$ は $`r ≤ p \lt q`$ の内部の辺で、$`R(k, f(r), f(p), f(q))`$ を要求する。
- `TopAtom` $`(k,r,p)`$ は外の上端 $`β`$ への要求で、$`R(k, f(r), f(p), β)`$ を要求する。
- `Admissible`：要求の層が $`K`$ より低いか、または層が $`K`$ で、根が切れ目 `cut` より前にあり、根のラベルが $`θ`$ より小さい。

### 2.3 義務の表

| 記号 | 入口の定理での名前 | 内容 | 本モデルの Lean 名 |
|---|---|---|---|
| O0 | `α` `lt` `D` `R` | ラベルの型と関係 | `Ord := Ordinal.{0}`、`(· < ·)`、`fun _ => True`、`R` |
| O1 | `hWF` | `lt` は整礎 | `Ordinal.lt_wf` |
| O2 | `hTrans` | `lt` は推移的 | `fun h₁ h₂ => h₁.trans h₂` |
| O3 | `hStrict` | $`R(k,η,a,b)`$ なら $`a \lt b`$ | `R_lt` |
| O4 | `hWeak` | $`η' \lt η`$ かつ $`R(k,η,p,c)`$ なら $`R(k,η',p,c)`$ | `R_weaken`（非厳密版）。渡すのは `fun h hR => R_weaken h.le hR` |
| O5 | （定義） | `Representation` | 義務なし |
| O6 | `reflection` | `FiniteReflection lt D R` | `finiteReflection` |
| O7 | `initial` | 各式の図式に表現がある | `initial_all`（すべての `Diagram` について） |

モデルの Lean 名は `Por/Model.lean`（名前空間 `Por`）のものである。まとめの定理 `model_obligations` は、6 つの仮定を入口の定理と同じ形で述べる。最終定理は `expansion_wellFounded`、`generated_strictWellOrder`、`descendants_strictWellOrder`、`expansion_chain_reaches_empty` とする。これらは結合検査のファイルで緑になった（§4.10）。このリポジトリには、移植のあとで入れる。

### 2.4 コアでの使われ方

- O1：最初の表現の末尾ラベルの `Acc` で帰納法をする（`expansion_accessible_of_lastRepresentation`）。
- O2：継ぎ合わせたラベルの順序と上界（`spliceLabel_ordered`、`spliceLabel_bounded`）。
- O3：制御関係 $`R(K, f(\mathrm{controlRoot}), f(\mathrm{cut}), β)`$ から $`f(\mathrm{cut}) \lt β`$ を得る（`exists_bounded_representation_splice`）。
- O4：根が前のブロックへ移る辺（`representation_splice` の `CopyCase`）と、末尾列の型から仮想的な要求を作るところ（`virtual_demands_from_templates`）。厳密版だけを使う。
- O6：ブロックごとに 1 回呼ぶ（`exists_bounded_representation_splice`）。引数は $`θ = f(\mathrm{controlRoot})`$、$`β = f(x)`$（古い末尾ラベル）、`needs` はコピーの要求である。ただし型としては、任意の `Diagram` について要求される。内部の辺の層は $`K`$ より高くてもよい。
- O7：任意の `ZeroY.Expr`（種だけではない）の図式に要る。上界は要らない。

### 2.5 コアが要らないもの

入口の定理の仮定に無いので、モデルが満たす必要は無い。

- 上端の $`D(β)`$ を別に示すこと。コアでは $`β`$ はいつも古い末尾ラベルなので、表現から出る。本モデルでは $`D`$ = True である。
- 仮想的な要求、要求の `Admissible` 性、制御関係。どれもコアの中で組合せ的に作られる。
- $`R`$ の推移性（L モデルの `R.trans`）、層を下げる性質（`R.lower_block`）、層についての単調性、非厳密な弱化、$`D`$ の閉包性、上界のある種の供給。

### 2.6 L モデルの内部の義務の行き先

L モデルの有限反映 `OneYTruth.RootSemantics.actual_finiteReflection` は、1 つの $`Σ_1`$ 論理式を制御写像に沿って反映する。その論理式を書くために、次の内部の義務があった。本モデルでの行き先を並べる。

| L モデル | 内容 | 本モデル |
|---|---|---|
| O6a | 制御関係が真理の塔の間の $`Σ_1`$ 保存写像になる（`R.closedMap`） | $`R`$ の定義そのもの |
| O6b | `Adequate` が $`Σ_1`$ で書け、下へ健全、上端で完全 | 消える（$`D`$ = True） |
| O6c | 上端より下の $`R`$ が、すべての層で $`Σ_1`$ で書ける。証明書のために上端の `Adequate` が要る | 原子記号 $`\mathrm{Rel}_j`$ |
| O6d | 上端への要求が書ける。層 $`\lt K`$ は対角述語、層 $`K`$ は名前付き述語 | 原子記号 $`\mathrm{Top}_j`$。対角と名前付きの区別はそのまま |
| O6e | パラメータ $`ω`$、$`∅`$、層の番号が小さい方の構造にある | 消える（層は記号の添字） |

## 3. 定義

### 3.1 記号

- $`\mathrm{Ord}`$ は順序数全体（Lean では `Ordinal.{0}`）。$`ω_1`$ は最初の非可算順序数（Lean では `ω₁`）。
- $`ℕ × \mathrm{Ord}`$ の辞書式順序：$`(j,ξ) ≺ (k,η) :⟺ j \lt k ∨ (j = k ∧ ξ \lt η)`$。
- 3 つ組（上端、層、添字）の辞書式順序：$`(b',k',η') \lhd (b,k,η) :⟺ b' \lt b ∨ (b' = b ∧ (k',η') ≺ (k,η))`$。上端が一番外側である。整列順序 3 つの辞書式積なので、$`\lhd`$ は整礎である。

### 3.2 言語と Σ₁ 論理式

記号は次の 3 種類である。

- 2 項の $`\lt`$。
- 各 $`j ∈ ℕ`$ について、3 項の $`\mathrm{Rel}_j`$。
- 各 $`j ∈ ℕ`$ について、2 項の $`\mathrm{Top}_j`$。

$`Σ_1`$ 論理式は $`∃ \vec y\ ψ(\vec p, \vec y)`$ の形で、$`ψ`$ は量化子を含まない。1 つの論理式は有限個の記号しか使わない。

Lean では、論理式を 5 つ組 $`(m, n, Δ, \mathit{bb}, r)`$ で表す。

- $`m`$ は記号の上限で、$`\mathrm{Rel}_j`$ と $`\mathrm{Top}_j`$ は $`j \lt m`$ だけを使う。
- $`r`$ はパラメータの数、$`\mathit{bb}`$ は存在量化する変数の数、$`n ≤ r + \mathit{bb}`$ は行列が読む変数の数である。
- $`Δ`$（Lean では `D`）は行列で、`Diag m n` の部分集合である。`Diag m n` は $`n`$ 点の完全な原子図式（$`\lt`$、$`\mathrm{Rel}_j`$、$`\mathrm{Top}_j`$ のビット）の型で、有限である。量化子の無い論理式は、それを満たす完全な原子図式の集合で表せる。
- 変数の値の列は、パラメータ $`p_0, …, p_{r-1}`$ のあとに証人 $`y_0, …, y_{\mathit{bb}-1}`$ を並べたもの（`cat r p y`）である。

$`\lt`$ のビットは線形順序を決めるので、等号も決まる。等号の記号は要らない。

### 3.3 段 (k, η) の構造

$`R`$ が、必要なところで定義済みだとする。高さ $`γ`$、段 $`(k,η)`$ の構造を次で定める。領域は $`\{x : x \lt γ\}`$ である。

```math
\mathfrak A^{γ}_{k,η} = \bigl(γ;\ \lt,\ (\mathrm{Rel}_j)_{j∈ℕ},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,ξ})_{ξ \lt η}\bigr)
```

```math
\begin{aligned}
\mathrm{Rel}_j(x,y,z) &:⟺ R(j,x,y,z) && (j ∈ ℕ),\cr
\mathrm{Top}_j(ξ,x) &:⟺ R(j,ξ,x,γ) && (j \lt k),\cr
\mathrm{Top}_{k,ξ}(x) &:⟺ R(k,ξ,x,γ) && (ξ \lt η).
\end{aligned}
```

- $`\mathrm{Rel}_j`$ は内部の辺である。すべての層 $`j`$ を持つ。点はどれも高さより下にある。
- $`\mathrm{Top}_j`$（$`j \lt k`$）は対角の上端述語である。第 1 引数（根の添字）は普通の変数でよい。
- $`\mathrm{Top}_{k,ξ}`$ は名前付きの上端述語である。名前 $`ξ \lt η`$ ごとに 1 項の記号が 1 つある。
- $`j \gt k`$ の $`\mathrm{Top}_j`$ は言語に無い。

段 $`(k,η)`$ の論理式とは、この言語の $`Σ_1`$ 論理式である。名前付き述語の名前はパラメータとして与える。

Lean では、名前付き述語 $`\mathrm{Top}_{k,ξ}(x)`$ を、2 項の $`\mathrm{Top}_k(s, x)`$ で $`s`$ がパラメータの位置のものとして表す。論理式と一緒に位置の集合 $`S`$ を与え、$`s ∈ S`$ なら $`s \lt r`$ かつ $`p_s \lt η`$ を要求する。見えるビットは次で決まり、見えないビットは偽と読む（`diagM`）。

```math
\mathtt{allowL}\ k\ S\ j\ s \;:⟺\; j \lt k \ ∨\ (j = k ∧ s ∈ S)
```

見えるかどうかは位置だけで決まり、点の値に依らない。この性質は §4.8 で使う。

### 3.4 関係 R

```math
R(k,η,a,b) \;:⟺\; η ≤ a \ ∧\ a \lt b \ ∧\ \mathfrak A^{a}_{k,η} ≼_{Σ_1} \mathfrak A^{b}_{k,η}
```

ここで $`\mathfrak A^{a}_{k,η} ≼_{Σ_1} \mathfrak A^{b}_{k,η}`$ は、段 $`(k,η)`$ のすべての $`Σ_1`$ 論理式 $`φ`$ と、すべてのパラメータ $`\vec p \lt a`$（名前は $`\lt η`$）について、次が成り立つことである。

```math
\mathfrak A^{a}_{k,η} ⊨ φ(\vec p) \iff \mathfrak A^{b}_{k,η} ⊨ φ(\vec p)
```

- 2 つの構造の上端述語は別の関係である。$`\mathfrak A^{a}`$ では $`a`$ への $`R`$、$`\mathfrak A^{b}`$ では $`b`$ への $`R`$ である。
- 量化子の無い $`φ`$ を取ると、$`a`$ より下の点では、見える原子の真偽が一致する。特に、$`ξ, x \lt a`$ と見える $`(j,ξ)`$ について $`R(j,ξ,x,a) ⟺ R(j,ξ,x,b)`$ である。したがって $`\mathfrak A^{a}_{k,η}`$ は $`\mathfrak A^{b}_{k,η}`$ の部分構造で、しかも $`Σ_1`$ 初等である。
- 読み方は $`a ≤_{(k,η)} b`$、つまり「層 $`k`$、根の添字 $`η`$ で、$`a`$ は $`b`$ へ安定している」である。
- 条件 $`η ≤ a`$ は L モデルの `R.index_le` と同じである。辺も要求も根 $`≤`$ 親なので、増加するラベル付けではこの条件はいつも満たされる。

再帰。$`R`$ は $`(b,k,η)`$ についての $`\lhd`$ による整礎再帰で、すべての $`a`$ について一度に定義する。$`(b,k,η)`$ の定義が読む $`R`$ は次の 3 種類だけで、どれも鍵が小さい。

1. $`\mathrm{Rel}_j(x,y,z)`$：点はすべて高さ（$`a`$ か $`b`$）より下なので $`z \lt b`$。鍵は $`(z,j,x) \lhd (b,k,η)`$。
2. $`\mathfrak A^{a}`$ の上端述語：鍵は $`(a,j,ξ)`$ で、$`a \lt b`$。
3. $`\mathfrak A^{b}`$ の見える上端述語：鍵は $`(b,j,ξ)`$ で、$`(j,ξ) ≺ (k,η)`$。$`j \lt k`$ か、$`j = k`$ で $`ξ`$ が名前（$`\lt η`$）だからである。

$`R`$ は $`\mathrm{Ord}`$ 全体で定義される。ラベルとして使うのは可算順序数である。$`ω_1`$ は O7 の補助の上端にだけ現れる。

### 3.5 ラベルのデータ（O0）

$`α := \mathrm{Ord}`$、`lt` は $`\lt`$、$`D := \mathrm{True}`$、$`R`$ は §3.4 のものとする。

$`D := (\cdot \lt ω_1)`$ としても、少し足すだけで全部の証明が通る。反映は $`f(\mathrm{cut})`$ より下のラベルしか作らず、O7 の鎖は $`ω_1`$ より下にあるからである。必要が無いので True を選ぶ。

### 3.6 O7 のための補助

- 周りの構造 $`\mathfrak B := (ω_1;\ \lt,\ (\mathrm{Rel}_j)_{j∈ℕ},\ (\mathrm{Top}^{ω_1}_j)_{j∈ℕ})`$。ここで $`\mathrm{Top}^{ω_1}_j(ξ,x) :⟺ R(j,ξ,x,ω_1)`$ で、すべての層の上端述語を対角で持つ。
- $`\mathrm{Good}(α) :⟺ \mathfrak B{\restriction}α ≼_{Σ_1} \mathfrak B`$（すべての記号を使う言語で）。$`\mathfrak B{\restriction}α`$ は $`\mathfrak B`$ を $`α`$ に制限したもので、上端述語は $`ω_1`$ へのもののままである。
- $`0 \lt γ \lt ω_1`$ に対し、全射 $`e_γ : ℕ → γ`$ を 1 つ選ぶ（`enumBelow`）。
- $`h(φ, \vec p)`$（`witHeight`）：$`\mathfrak B ⊨ φ(\vec p)`$ なら、選んだ証人 $`\vec y`$ について $`\sup_i (y_i + 1)`$。そうでなければ 0。
- $`\mathrm{next}(γ) := \max\bigl(γ, \sup_{(φ,l)} h(φ, e_γ ∘ l)\bigr) + 1`$（`next`）。$`φ`$ は $`Σ_1`$ 論理式全体を、$`l`$ は自然数の有限列全体を動く。
- $`λ(γ) := \sup_{t ∈ ℕ} \mathrm{next}^t(γ)`$（`lam`）。
- 鎖：$`c_0 := λ(0)`$、$`c_{t+1} := λ(c_t)`$（`cC`）。

$`\mathrm{Good}`$ な点の集合が閉じていることは示していないし、使わない。そのため club とは呼ばない。

### 3.7 Lean の名前との対応

| 数学 | Lean 名（`Por/Model.lean`） |
|---|---|
| 完全な原子図式の型 | `Diag m n` |
| 点の列の原子図式（見えないビットは偽） | `diagM rel top allow m n v` |
| 高さ $`M`$ で $`Σ_1`$ 論理式が真 | `Sat rel top allow M m n D bb r p` |
| 見えるビット | `allowL k S`（段 $`(k,S)`$）、`full`（全部） |
| $`Σ_1`$ 初等性 | `ElemL rel topA topB k η a b`、真の関係では `Elem k η a b` |
| 見えないビットを偽にする | `maskD` |
| 鍵と順序 | `Idx := Ord × ℕ × Ord`、`ilt`、`ilt_wf` |
| 再帰 | `stepF`、`RF := ilt_wf.fix stepF`、`R k η a b := RF (b, k, η) a` |
| 真の内部関係と上端述語 | `relR`、`topR γ` |
| 補助 | `Good`、`Form`、`witHeight`、`next`、`tower`、`lam`、`cC` |

中心の定義は次のとおりである（`Por/Model.lean` から）。

```lean
def allowL (k : ℕ) (S : Set ℕ) (j a : ℕ) : Prop := j < k ∨ (j = k ∧ a ∈ S)

def ElemL (rel : RelF) (topA topB : TopF) (k : ℕ) (η a b : Ord) : Prop :=
  ∀ (m n : ℕ) (D : Set (Diag m n)) (bb r : ℕ) (S : Set ℕ) (p : ℕ → Ord),
    n ≤ r + bb → (∀ i < r, p i < a) → (∀ s ∈ S, s < r ∧ p s < η) →
    (Sat rel topA (allowL k S) a m n D bb r p ↔ Sat rel topB (allowL k S) b m n D bb r p)

noncomputable def stepF (t : Idx) (IH : ∀ t' : Idx, ilt t' t → Ord → Prop) : Ord → Prop :=
  fun a => t.2.2 ≤ a ∧ a < t.1 ∧
    ElemL (fun j x y z => ∃ h : z < t.1, IH (z, j, x) (Prod.Lex.left _ _ h) y)
      (fun j ξ x => ∃ h : a < t.1, IH (a, j, ξ) (Prod.Lex.left _ _ h) x)
      (fun j ξ x => ∃ h : Prod.Lex (· < ·) (· < ·) (j, ξ) t.2,
        IH (t.1, j, ξ) (Prod.Lex.right _ h) x)
      t.2.1 t.2.2 a t.1

noncomputable def RF : Idx → Ord → Prop := ilt_wf.fix stepF

noncomputable def R (k : ℕ) (η a b : Ord) : Prop := RF (b, k, η) a

theorem R_iff {k : ℕ} {η a b : Ord} : R k η a b ↔ η ≤ a ∧ a < b ∧ Elem k η a b
```

### 3.8 形を決めた理由

次の 4 つの特徴は、どれも証明のどこかで使う。外すと証明が通らない。

1. どの段の言語も、すべての層の $`\mathrm{Rel}_j`$ を持つ。そのため上端を再帰の一番外に置く。
   - 理由：`FiniteReflection` はすべての図式について要求され、内部の辺の層は $`K`$ より高くてもよい。コアが実際に使うコピーの図式にも、$`K`$ より高い層の辺がある。段 $`(K,θ)`$ の反映でそれらを運ぶには、それらが段 $`(K,θ)`$ の言語で書けなければならない。原子記号にすれば書ける。
   - 合法である理由：$`\mathrm{Rel}_j`$ は高さより下の点どうしの関係なので、その値の上端は小さい。
   - 低い添字の関係だけを持つ言語で、$`(k,η)`$ を外側にして再帰すると、$`K`$ より高い層の内部の辺を書けない。L モデルはここで `Adequate` の証明書を使った（O6c）。順序数だけでこれに代わる方法は見つかっていない。
2. 上端述語 $`\mathrm{Top}_j`$ を原子記号として持つ。添字は $`≺ (k,η)`$ のものだけである。
   - 理由：上端への要求 $`R(j, v, w, \mathrm{top})`$ は、上端を元に持たない構造の中で書く必要がある。$`R`$ の定義を展開して書くと $`Σ_1`$ にならない。Carlson の $`\mathcal R_N`$ はこれを $`Σ_{n+1}`$ の段と連続性の補題で扱うが、段の添字が超限の $`η`$ になるとこの方法は使えない。
   - 添字を $`≺ (k,η)`$ に限る理由：$`\mathfrak A^{b}_{k,η}`$ の上端述語は、同じ上端 $`b`$ の $`R`$ を読む。添字が小さくないと再帰が循環する。
3. 同じ層の上端述語は、名前付きにする。
   - 理由：見えるかどうかが位置だけで決まるので、段 $`(k,η)`$ の論理式は、見えないビットを偽にするだけで、すべての記号を使う言語の論理式に訳せる（`maskD`）。O7 の証明はこの翻訳を使う（§4.8）。
   - 条件付きの対角述語 $`\mathrm{Top}_k(ξ,x) ∧ ξ \lt η`$ を使うと、$`η = a`$ のとき、条件 $`ξ \lt a`$ を $`a`$ より下のパラメータで書けない。根と親が同じ辺では $`R(k,a,a,b)`$ が要り、そこで O7 の証明が止まる。この変種の反例は見つかっていないが、証明も無い。
   - 名前付きにすると、O4 は言語の包含になる。
4. $`Σ_1`$ だけを使う。$`Σ_n`$（$`n ≥ 2`$）も、bms-elem-pattern の $`Φ_m`$ や連続性・共終性の補題も要らない。上端との関係が原子記号だからである。

加えて、1 つの論理式が使う記号は有限個（上限 $`m`$）にする。そうしないと論理式の全体が可算にならず、$`\mathrm{next}(γ) \lt ω_1`$ が言えない。

### 3.9 ほかの案と、査読の指摘への対応

設計の段階で 3 つの案を作り、どれも 3 人の査読を通った。反駁された案は無い。

| 案 | 関係 $`R`$ | Lean での検査 |
|---|---|---|
| A | 本案とほぼ同じ（$`Σ_1`$ と上端述語）。定義の細部が違う | インターフェースを書き写した版に対して緑 |
| B（写し） | $`b`$ 未満の有限の配置を $`a`$ 未満へ写せること、を定義にする。向きは下向きだけで、正の原子だけを運ぶ | Lean 4.30 で、インターフェースを書き写した版に対して緑 |
| C（本案） | §3.4 | 本物のコアに差し込んで緑（§4.10） |

C を選んだ。本物のコアと一緒に検査したのは C だけだからである。A と C は同じ考えで、C は A の定義を整理したものである。

ほかの案から取り入れたもの。

- B の「写し」の読み方を、O6 の説明に使う（§4.5 の注）。B は予備として残す。C に想定外の問題が出たら、B に切り替えられる。
- A の分析（簡単な変種では証明が通らない理由）を §3.8 に入れた。
- A の査読の提案に従い、補助の性質を club ではなく Good と呼ぶ。

査読の指摘への対応。

- 推移性、添字についての単調性、局所性は Lean で検査していない。→ §4.11 に「使わない性質」として分けた。コアはこれらを使わない。
- 「YesMetaZFC から使うのは `StrictWellOrder` だけ」という前提は、定数の水準では誤りだった。→ 正しい数を §5 と [02-port.md](02-port.md) に書いた。
- コアと組み合わせた検査は、手で組んだ環境で行った。→ 移植のあとに、このリポジトリの正式なビルドでやり直す（§6 の手順 6）。
- B についての「等号の原子」の指摘は C には当たらない。C の行列は $`\lt`$ のビットをすべて決めるので、等号も決まる。

## 4. 証明

### 4.1 R はうまく定義され、定義の式を満たす

Lean：`ilt_wf`、`RF_eq`、`elem_stage`、`R_iff`。

**主張.** 右辺の構造を真の $`R`$ で解釈して、次が成り立つ。

```math
R(k,η,a,b) \iff η ≤ a \ ∧\ a \lt b \ ∧\ \mathfrak A^{a}_{k,η} ≼_{Σ_1} \mathfrak A^{b}_{k,η}
```

**証明.**

1. $`\lhd`$ は整礎である（`WellFounded.prod_lex` を 2 回）。`RF := ilt_wf.fix stepF` とすると、`WellFounded.fix_eq` から `RF t = stepF t RF` が成り立つ（`RF_eq`）。
2. `stepF` は、呼ぶ鍵が小さいことの証明を引数に持つ「段の関係」を使う。高さ $`b`$、段 $`(k,η)`$ では次の 3 つである。
   - $`\mathrm{Rel}^{\mathrm{st}}_j(x,y,z) :⟺ z \lt b ∧ R(j,x,y,z)`$
   - $`\mathrm{Top}^{\mathrm{st},a}_j(ξ,x) :⟺ a \lt b ∧ R(j,ξ,x,a)`$
   - $`\mathrm{Top}^{\mathrm{st},b}_j(ξ,x) :⟺ (j,ξ) ≺ (k,η) ∧ R(j,ξ,x,b)`$
3. $`a \lt b`$ とする。段 $`(k,η)`$ の論理式が読むビットでは、付けた条件はいつも真である（`elem_stage`）。
   - $`\mathrm{Rel}`$ のビット：点は高さ $`≤ b`$ より下にあるので $`z \lt b`$（`cat_bound`）。
   - 高さ $`a`$ の上端述語：$`a \lt b`$。
   - 高さ $`b`$ の見える上端述語：`allowL` から、$`j \lt k`$ であるか、$`j = k`$ で位置が $`S`$ にあり、その値が $`\lt η`$ である。どちらでも $`(j, \cdot) ≺ (k,η)`$。
4. 見えないビットは、どちらの解釈でも偽である。よって原子図式は等しく（`diagM_congr`）、論理式の真偽も等しい（`sat_congr`）。
5. $`a ≥ b`$ なら両辺とも偽である。$`\square`$

### 4.2 O0、O1、O2

- O0：§3.5 のとおり。
- O1：`Ordinal.lt_wf`。
- O2：`fun h₁ h₂ => h₁.trans h₂`。

### 4.3 O3

Lean：`R_lt`、`R_index_le`。

$`R(k,η,a,b)`$ なら、`R_iff` の第 2 項から $`a \lt b`$、第 1 項から $`η ≤ a`$ である。

### 4.4 O4

Lean：`R_weaken`（`(hsl : small ≤ large) (h : R k large p c) : R k small p c`）。

**主張.** $`η' ≤ η`$ かつ $`R(k,η,p,c)`$ なら、$`R(k,η',p,c)`$ である。コアへは厳密版 `fun h hR => R_weaken h.le hR` を渡す。

**証明.**

1. 条件の部分：$`η' ≤ η ≤ p`$、$`p \lt c`$。
2. 段 $`(k,η')`$ の論理式は、名前が $`\lt η' ≤ η`$ なので、段 $`(k,η)`$ の論理式でもある。
3. 2 つの段は、見える記号を同じに解釈する。$`\mathrm{Rel}_j`$、$`j \lt k`$ の $`\mathrm{Top}_j`$、名前の位置の $`\mathrm{Top}_k`$ である。違うのは、許される名前の範囲だけである。
4. よって $`\mathfrak A^{p}_{k,η} ≼_{Σ_1} \mathfrak A^{c}_{k,η}`$ から $`\mathfrak A^{p}_{k,η'} ≼_{Σ_1} \mathfrak A^{c}_{k,η'}`$ が出る。$`\square`$

Lean では、`ElemL` の仮定 $`p_s \lt η'`$ から $`p_s \lt η`$ を作るだけである（6 行）。

### 4.5 O6：有限反映

Lean：`finiteReflection : FiniteReflection (α := Ord) (· < ·) (fun _ => True) R`。

**仮定.** $`n := |G|`$、$`\mathrm{cut} \lt n`$ とする。

- $`f`$ は $`G`$ の表現である。$`n`$ 未満で狭義増加で、$`G`$ のすべての辺 $`e = (k_e, r_e, p_e, q_e)`$ で $`R(k_e, f(r_e), f(p_e), f(q_e))`$ が成り立つ。
- $`i \lt n`$ なら $`f(i) \lt β`$。
- 制御関係 $`R(K, θ, f(\mathrm{cut}), β)`$。
- 各要求 $`d = (k_d, r_d, p_d)`$ は $`r_d ≤ p_d \lt n`$ を満たし、`Admissible`（$`k_d \lt K`$、または $`k_d = K ∧ r_d \lt \mathrm{cut} ∧ f(r_d) \lt θ`$）で、$`R(k_d, f(r_d), f(p_d), β)`$ が成り立つ。

**示すこと.** 次を満たす $`g`$ がある。$`g`$ は $`G`$ の表現で、$`i \lt \mathrm{cut}`$ なら $`g(i) = f(i)`$、$`i \lt n`$ なら $`g(i) \lt f(\mathrm{cut})`$、各要求で $`R(k_d, g(r_d), g(p_d), f(\mathrm{cut}))`$。

**証明.**

1. $`a := f(\mathrm{cut})`$ と置く。`R_iff` から $`θ ≤ a \lt β`$ と $`\mathfrak A^{a}_{K,θ} ≼_{Σ_1} \mathfrak A^{β}_{K,θ}`$ が出る。
2. 名前の位置を $`S := \{ r_d : d ∈ \mathrm{needs},\ k_d = K \}`$ とする。$`k_d = K`$ なら `Admissible` の第 1 の場合は起きないので、$`r_d \lt \mathrm{cut}`$ かつ $`f(r_d) \lt θ`$ である。
3. パラメータは $`f(0), …, f(\mathrm{cut}-1)`$ とする。$`f`$ は増加なので、どれも $`\lt a`$ である。
4. $`i \lt \mathrm{cut}`$ なら $`z_i := f(i)`$、$`\mathrm{cut} ≤ i \lt n`$ なら $`z_i := y_i`$ と置いて、次の論理式を作る。

```math
Φ :≡ ∃ y_{\mathrm{cut}} \dots ∃ y_{n-1}\ \Bigl[\ \bigwedge_{i \lt j \lt n} z_i \lt z_j \ ∧\ \bigwedge_{e ∈ G} \mathrm{Rel}_{k_e}(z_{r_e}, z_{p_e}, z_{q_e}) \ ∧\ \bigwedge_{d ∈ \mathrm{needs}} \mathrm{Top}_{k_d}(z_{r_d}, z_{p_d})\ \Bigr]
```

5. $`Φ`$ は段 $`(K,θ)`$ の論理式である。$`k_d \lt K`$ の $`\mathrm{Top}_{k_d}`$ は対角なので、$`r_d`$ は証人の位置でもよい。$`k_d = K`$ なら $`r_d ∈ S`$ で、これは名前付き述語 $`\mathrm{Top}_{K, f(r_d)}`$ である。Lean では、`Admissible` から、各要求のビットが `allowL K S` で見えることと、$`S`$ の位置が $`s \lt \mathrm{cut}`$ かつ $`f(s) \lt θ`$ を満たすことが出る。
6. $`\mathfrak A^{β}_{K,θ} ⊨ Φ`$ である。$`y_i := f(i) \lt β`$ と取ると $`z = f`$ になる。
   - $`\lt`$ の項は `Representation.ordered` から出る。
   - $`\mathrm{Rel}`$ の項は `Representation.relations` から出る（$`\mathrm{Rel}_j`$ は $`R(j,\cdot,\cdot,\cdot)`$）。
   - $`\mathrm{Top}`$ の項は要求の仮定から出る（高さ $`β`$ では $`\mathrm{Top}_j(ξ,x)`$ は $`R(j,ξ,x,β)`$）。
7. $`Σ_1`$ 初等性から $`\mathfrak A^{a}_{K,θ} ⊨ Φ`$ である。その証人 $`y'_i \lt a`$ を取る。
8. $`g := `$ `cat cut f y'` とする。つまり $`i \lt \mathrm{cut}`$ なら $`g(i) = f(i)`$、そうでなければ $`g(i) = y'_i`$ である。
   - $`g`$ は $`n`$ 未満で狭義増加である（$`\lt`$ の項）。
   - $`G`$ の各辺で $`R(k_e, g(r_e), g(p_e), g(q_e))`$ が成り立つ（$`\mathrm{Rel}`$ の項）。
   - $`i \lt \mathrm{cut}`$ なら $`g(i) = f(i)`$。
   - $`i \lt n`$ なら $`g(i) \lt a`$。$`i \lt \mathrm{cut}`$ なら $`f(i) \lt f(\mathrm{cut})`$、そうでなければ $`y'_i \lt a`$ だからである。
   - 各要求で $`R(k_d, g(r_d), g(p_d), a)`$ が成り立つ（高さ $`a`$ では $`\mathrm{Top}_j(ξ,x)`$ は $`R(j,ξ,x,a)`$）。
   - $`D`$ は True なので、定義域の条件は自明である。$`\square`$

Lean では、記号の上限を `sigBound G needs`（辺の層の和 + 要求の層の和 + 1）とし、行列を `reflMat G needs m` とする。`reflMat_iff` が行列の中身を読む。

使わなかったもの：$`D(β)`$、$`a`$ や $`β`$ が極限であること、閉包点であること。

**注（写しとしての読み方。案 B から）.** $`R(K,θ,a,β)`$ は次のことを言っている。$`β`$ より下の有限個の点の配置は、$`a`$ より下のパラメータを動かさずに、$`a`$ より下へ写せる。写しは順序と、選んだ有限個の層の $`\mathrm{Rel}`$ を保ち、見える上端述語の事実を $`β`$ 向きから $`a`$ 向きへ移す。`FiniteReflection` はこの写しを 1 回使うだけである。案 B は、この性質そのものを $`R`$ の定義にした。

### 4.6 L モデルの内部の義務について

§2.6 の表のとおり、O6a–O6e は本モデルでは定義の一部になるか、消える。

- O6a：$`R(K,θ,a,β)`$ は定義によって段 $`(K,θ)`$ の $`Σ_1`$ 初等性を含む。構造の領域が空でないこと、$`a`$ が極限であることなどは要らない。
- O6b：$`D`$ は True なので、定義域の論理式は無い。
- O6c：内部の辺は原子論理式 $`\mathrm{Rel}_{k_e}(\cdot,\cdot,\cdot)`$ である。どの段の言語も、高さより下で真の $`R`$ と解釈される $`\mathrm{Rel}_j`$ をすべての $`j`$ について持つ。健全性も完全性も恒等的に成り立つ。
- O6d：上端への要求は原子論理式 $`\mathrm{Top}_{k_d}(\cdot,\cdot)`$ である。`Admissible` の条件は、段 $`(K,θ)`$ で見えることとちょうど一致する。
- O6e：パラメータは $`f(0), …, f(\mathrm{cut}-1)`$ だけである。$`ω`$、$`∅`$、層の符号は要らない。

### 4.7 O7 の準備：閉包点

Lean：`witHeight_lt`、`next_lt`、`lam_lt`、`lt_lam`、`exists_tower`、`wit_below`、`lam_good`。

**主張.** $`γ \lt ω_1`$ なら、$`γ \lt λ(γ) \lt ω_1`$ かつ $`\mathrm{Good}(λ(γ))`$ である。

**証明.**

1. $`\mathrm{next}(γ) \lt ω_1`$ である。
   - 添字の集合（$`Σ_1`$ 論理式と自然数の有限列の組）は可算である。各行列は有限集合 `Diag m n` の部分集合だからである。
   - 各 $`h(φ, \vec p)`$ は、$`ω_1`$ より下の順序数の後者の、有限個の上限なので $`\lt ω_1`$ である（`om_succ_lt`）。
   - $`ω_1`$ より下の順序数の可算個の上限は $`\lt ω_1`$ である（`Ordinal.iSup_lt_omega_one`。$`ω_1`$ の正則性）。
2. 同じ理由で $`λ(γ) \lt ω_1`$ である。また $`γ \lt \mathrm{next}(γ) ≤ λ(γ)`$。
3. $`\mathrm{Good}(λ(γ))`$ の $`⇒`$：$`λ(γ)`$ より下の証人は $`ω_1`$ より下の証人でもある。$`\mathfrak B{\restriction}λ(γ)`$ は $`\mathfrak B`$ の制限なので、行列は同じに評価される。
4. $`\mathrm{Good}(λ(γ))`$ の $`⇐`$：パラメータ $`\vec p \lt λ(γ)`$ は有限個なので、ある $`t`$ で全部 $`\lt \mathrm{next}^t(γ)`$ になる（`exists_tower`）。$`\mathrm{next}^t(γ)`$ は可算なので、$`\vec p = e_{\mathrm{next}^t(γ)} ∘ l`$ となる $`l`$ がある（`exists_params`）。$`(φ, l)`$ について選んだ証人は $`\lt \mathrm{next}^{t+1}(γ) ≤ λ(γ)`$ である（`wit_below`）。$`\square`$

### 4.8 O7 の中心：上端述語の絶対性

Lean：`sat_abs`、`top_abs`。

**主張.** $`\mathrm{Good}(α)`$ かつ $`α \lt ω_1`$ なら、すべての $`j`$ と $`ζ, x \lt α`$ について次が成り立つ。

```math
R(j,ζ,x,α) \iff R(j,ζ,x,ω_1)
```

**証明.** $`(j,ζ)`$ について、$`≺`$ による整礎帰納法をする。

1. `R_iff` で両辺を開く。条件 $`ζ ≤ x`$ は共通で、$`x \lt α`$ も $`x \lt ω_1`$ も真である。残るのは、段 $`(j,ζ)`$ の論理式 $`ψ`$（パラメータ $`\lt x`$、名前 $`\lt ζ`$）について、$`\mathfrak A^{α}_{j,ζ} ⊨ ψ ⟺ \mathfrak A^{ω_1}_{j,ζ} ⊨ ψ`$ を示すことである（`sat_abs`）。
2. $`ψ`$ が読む上端述語のビット $`\mathrm{Top}_i(u,v)`$（$`u, v \lt α`$）は $`(i,u) ≺ (j,ζ)`$ を満たす。$`i \lt j`$ であるか、$`i = j`$ で $`u`$ が名前（$`\lt ζ`$）だからである。帰納法の仮定から $`R(i,u,v,α) ⟺ R(i,u,v,ω_1)`$ である。
3. よって $`\mathfrak A^{α}_{j,ζ} ⊨ ψ ⟺ \mathfrak B{\restriction}α ⊨ ψ^{*}`$ である。ここで $`ψ^{*}`$ は、$`ψ`$ の見えないビットを偽にした、すべての記号を使う言語の論理式である（`sat_mask`）。
4. $`\mathrm{Good}(α)`$ から $`\mathfrak B{\restriction}α ⊨ ψ^{*} ⟺ \mathfrak B ⊨ ψ^{*}`$ である。パラメータは $`\lt x \lt α`$ である。
5. 見えるビットの読み方は同じなので、$`\mathfrak B ⊨ ψ^{*} ⟺ \mathfrak A^{ω_1}_{j,ζ} ⊨ ψ`$ である。$`\square`$

§3.8 の 3（名前付き）はここで使う。見えるかどうかが位置で決まるので、$`ψ^{*}`$ が作れる。

### 4.9 O7：鎖と初期表現

Lean：`cC_lt`、`cC_strictMono`、`cC_good`、`chain_R`、`initial_all`。

**主張（`chain_R`）.** $`i \lt j`$、任意の層 $`k`$、$`η ≤ c_i`$ について $`R(k, η, c_i, c_j)`$ である。

**証明.** §4.7 から $`c_t \lt ω_1`$、$`c_t \lt c_{t+1}`$、$`\mathrm{Good}(c_t)`$ である。$`η ≤ c_i \lt c_j`$ なので、条件の部分は満たされる。段 $`(k,η)`$ の論理式 $`ψ`$ とパラメータ $`\lt c_i`$ について、次の同値が成り立つ。

```math
\mathfrak A^{c_i}_{k,η} ⊨ ψ \iff \mathfrak B{\restriction}c_i ⊨ ψ^{*} \iff \mathfrak B ⊨ ψ^{*} \iff \mathfrak B{\restriction}c_j ⊨ ψ^{*} \iff \mathfrak A^{c_j}_{k,η} ⊨ ψ
```

1 番目と 4 番目は §4.8（$`c_i`$ と $`c_j`$ で使う）、2 番目と 3 番目は $`\mathrm{Good}`$ である。$`\square`$

**O7（`initial_all`）.** $`f := c`$ とする。

- $`f`$ は狭義増加である。
- 辺 $`(k,r,p,q)`$ は $`r ≤ p \lt q`$ なので $`c_r ≤ c_p \lt c_q`$ である。`chain_R` を $`η := c_r`$ で使うと $`R(k, c_r, c_p, c_q)`$。
- $`D`$ は True である。

よって 1 つの $`f`$ が、すべての `Diagram` を同時に表現する。特に `exprDiagram s` を表現する。上界や種の条件は要らない。$`\square`$

### 4.10 コアとの結合：最終定理

```lean
theorem expansion_wellFounded : WellFounded (ZeroY.ExpansionStep OneY.Numeric.expand) :=
  OneY.RootIndexed.actual_expansion_wellFounded (α := Ord) (· < ·) (fun _ => True) R
    Ordinal.lt_wf (fun h₁ h₂ => h₁.trans h₂) (fun h => R_lt h) (fun h hR => R_weaken h.le hR)
    finiteReflection (fun s => initial_all (exprDiagram s))
```

残りの 3 つは、`OneY.Numeric.generated_strictWellOrder`、`OneY.Numeric.descendants_strictWellOrder`、`OneY.Numeric.expansion_chain_reaches_empty` に `expansion_wellFounded` を渡すだけである。

検査（2026-09-23 に再実行した）。

- モデル単体（`Por/Model.lean` と同じ内容。インターフェースは書き写した版）：Lean 4.33.1 と Mathlib v4.33.1 で緑。`model_obligations` の公理は `[propext, Classical.choice, Quot.sound]`。
- コアとの結合（本物の `OneY.RootIndexed.ExpansionWellFounded` と `OneY.Dynamics` を import）：緑。`finiteReflection`、`initial_all` と最終定理 4 つの公理は、どれも同じ 3 つ。`#print axioms` は依存の閉包全体を見るので、コアにも `sorryAx` は無い。
- 対照：同じファイルに偽の `example : (1:ℕ) = 2 := rfl` を足すと、検査は失敗した（exit 2）。検査は本当にファイルを展開している。

### 4.11 使わない性質（Lean で未検査）

コアはこれらを使わない。参考として書く。

- 推移性：$`R(k,η,a,b) ∧ R(k,η,b,c) ⇒ R(k,η,a,c)`$。パラメータは $`\lt a \lt b`$ なので、2 つの同値をつなげばよい。
- 添字についての単調性：$`(k,η) ≺ (k',η')`$（または等しい）、$`η ≤ a`$、$`R(k',η',a,b)`$ なら $`R(k,η,a,b)`$。段 $`(k,η)`$ で見えるビットは、段 $`(k',η')`$ でも見えるからである（$`k \lt k'`$ なら層 $`k`$ の述語は対角になる）。
- 局所性：上端が $`≤ δ`$ の $`R`$ は、$`δ + 1`$ より下の再帰だけで決まる。

## 5. 残るリスク

数学の部分は、本物のコアと一緒に Lean で検査した。残るリスクは主に工学とライセンスである。

1. **移植の規模.** コアの import 閉包は 161 モジュール、24,420 行ある（定数の水準で要るのは 142 モジュール、21,926 行）。コアはライセンスの無い YesMetaZFC に依存する。コアが直接使う名前は 106 個で、YesMetaZFC の中でのその閉包は 494 宣言、5,098 行ある。最終定理の定数閉包には、YesMetaZFC の定数が 453 個入っている。「使うのは `StrictWellOrder` だけ」という最初の見立ては誤りだった。これを自前で書き直す必要がある（[02-port.md](02-port.md)）。
2. **結合検査の環境.** 検査は、このリポジトリの Mathlib と、Phyrion 氏のリポジトリ（`6533b29`、作業木に変更なし）のビルド済み `.olean` を並べた、手で組んだ `LEAN_PATH` で行った。コアをソースから作り直してはいない。`.olean` はどれもソースより新しいので、古い `.olean` の可能性は低い。移植のあと、このリポジトリの `leanman build` でやり直す。
3. **Mathlib の見える環境でのコアの展開.** 結合検査は、コアを展開し直していない。BMS の層（または Bm4）が Mathlib を import すると、コアのファイルが Mathlib の simp 集合と名前の下で展開される。simp の結果が変わって証明が壊れるかもしれない。まだ測っていない。対策は [02-port.md](02-port.md) の手順 B0 にある。
4. **定義の形への依存.** コアは YesMetaZFC の定義を開いて計算する。定義の等式や match の等式を使う証明項が約 10 個、BMS の定義名を含む simp、rw、unfold の行が約 69 行ある。自前の定義は同じ再帰の形にするか、それらの行を直す必要がある。
5. **ライセンス.**
   - bms-elem-pattern（CC BY-SA 4.0）から持ってくる補助（`cat` の類、`Om` の類、`enumBelow`、`params`、閉包の組み立て）がある。このリポジトリは Apache-2.0 である。著作者本人が Apache-2.0 でも出すと決めるか、書き直す必要がある。今は `NOTICE` に、この判断が保留だと書いてある。Bm4 を使う場合も同じである。
   - YesMetaZFC について：コードは写さない。コアが呼ぶ名前と命題の形には合わせる。命題の形はコアの使用箇所（Apache-2.0）から取る。これで足りるかは、著作者が判断することである。
6. **仕様への信頼.** 1-Y の展開が `OneY.Numeric.expand` で正しく書かれていることは、Phyrion 氏の形式化に依る。このリポジトリは仕様を検査し直さない。
7. **強さ.** 証明は $`ω_1`$ の正則性（可算選択）と選択公理を使う。ラベルは $`ω_1`$ より下の閉包点で、順序数の上界や表記系は得られない。L モデルも同じなので、これは後退ではない。
8. **名前.** $`R`$ は Carlson の $`\mathcal R_N`$ そのものではない。上端述語を持つ $`Σ_1`$ 初等性を、上端を外側にした再帰で定義したものである。標準的な patterns of resemblance の構造と同じだとは主張しない。
9. **付随の主張.** §4.11 の性質は Lean で検査していない。コアは使わない。
10. **ツールチェーン.** Lean 4.33.1 と Mathlib v4.33.1 に固定する。コアは Lean 4.30 では 3 か所で壊れる（`ZeroY.Mountain.SumInverse`、`ZeroY.Structural.DecodeTower`、`OneY.Expansion`）。bms-elem-pattern（Lean 4.30）から持ってくる補助は、`Por/Model.lean` ですでに 4.33.1 に合わせてある。

この方法はうまくいくと考える。意味の層は、本物のコアと組み合わせて 4 つの最終定理まで検査が通った。残りは移植の手間と、ライセンスの判断である。

## 6. Lean での実装計画

### 6.1 ファイル

今は `Por/Model.lean` の 1 ファイル（653 行）に、インターフェースの書き写し（Part 0）、補助、モデル、全義務の証明が入っている。これを次の表のように分ける。コアのモジュール名（`OneY.*`、`ZeroY.*`）は Phyrion 氏のものをそのまま使う。こうするとコアの import 行を変えずに済む。モデルの名前空間は `Por` のままにする。

| # | ファイル | 中身 | 行数の目安 |
|---|---|---|---|
| 1 | `OneY/RootIndexed/Representation.lean` | Phyrion 氏のファイルそのもの（`import Std` だけ）。先頭に出どころと変更点を書き、`NOTICE` に載せる | 533 |
| 2 | `Por/Tuple.lean` | `cat`、`cat_left`、`cat_lt`、`cat_congr_left`、`cat_bound` | 30 |
| 3 | `Por/Omega1.lean` | `Om`、`om_pos`、`om_succ_lt`、`countable_Iio`、`enumBelow`、`enumBelow_surj`、`params`、`exists_params` | 50 |
| 4 | `Por/Formula.lean` | `Diag`、`RelF`、`TopF`、`diagM`、`Sat`、`full`、`allowL`、`ElemL`、`diagM_congr`、`sat_congr`、`maskD`、`diagM_mask`、`sat_mask` | 90 |
| 5 | `Por/Relation.lean` | `Idx`、`ilt`、`ilt_wf`、`stepF`、`RF`、`R`、`RF_eq`、`relR`、`topR`、`Elem`、`elem_stage`、`R_iff`、`R_lt`、`R_index_le`、`R_weaken` | 90 |
| 6 | `Por/Reflection.lean` | `getLt`、`getRel`、`getTop` とその `_diagM` 補題、`sigBound`、`atom_layer_lt`、`need_layer_lt`、`reflMat`、`reflMat_iff`、`finiteReflection` | 110 |
| 7 | `Por/Closure.lean` | `Good`、`Form`、`witHeight`、`witHeight_lt`、`next`、`lt_next`、`next_lt`、`wit_below`、`tower`、`lam`、`tower_lt`、`tower_mono`、`tower_le_lam`、`lam_lt`、`lt_lam`、`exists_tower`、`lam_good` | 115 |
| 8 | `Por/Chain.lean` | `sat_abs`、`top_abs`、`cC`、`cC_lt`、`cC_strictMono`、`cC_good`、`chain_R`、`initial_all` | 80 |
| 9 | `Por/Model.lean` | `model_obligations` と `#print axioms` だけを残す | 25 |
| 10 | `Por/WellOrdering.lean` | 最終定理 4 つと `#print axioms`（移植のあと） | 40 |

1 番を入れると、Part 0 の書き写しは要らなくなる。`Representation.lean` は Std だけに依存するので、コアの残りより先に入れられる。`lakefile.toml` に `[[lean_lib]] name = "OneY"` を足す（移植のときに `ZeroY` も足す）。

### 6.2 順序

1. 手順 4（済）：`Por/Model.lean` を入れた。全義務が緑。
2. 手順 4 の続き：1 番を入れ、`Por/Model.lean` の Part 0 を消して、その import に替える。次に 2〜9 番へ分ける。1 ファイルごとに `leanman build` する。`model_obligations` の公理が `[propext, Classical.choice, Quot.sound]` のままであることを確かめる。この作業は手順 5 と並べて行ってよい。
3. 手順 5：組合せの層を移植する（[02-port.md](02-port.md)）。
4. 手順 6：10 番を入れ、`leanman build` で結合検査をこのリポジトリの中でやり直す。§5 の 2 の注意はこれで消える。
5. 手順 7：文書と公理の監査。`#print axioms` を最終定理 4 つと `finiteReflection`、`initial_all` について記録する。

どの手順も、緑を確かめてから commit する。

### 6.3 bms-elem-pattern から持ってくるもの

[bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) の `lean/Pattern` から次を使う。`Por/Model.lean` ではすでに Lean 4.33.1 に合わせてある。

- `Basic.lean`
  - そのまま：`cat`、`cat_left`、`cat_lt`、`cat_congr_left`。
  - 組み立てを流用する：`stage`、`RFix`、`RFix_eq`、`stage_agree`、`elem_congr`、`rel_iff` の組み立てが、`stepF`、`RF`、`RF_eq`、`elem_stage`、`R_iff` になる。再帰の鍵は上端 1 つから（上端、層、添字）の 3 つ組に変わる。段の関係と真の関係の一致は、見えるビットの条件 `allowL` を通して示す。
  - 置き換え：ブロックを並べた `Sig` は、ブロック 1 つの `Sat` になる。原子図式は、記号の上限 $`m`$ を持つ `Diag m n` になる。
- `Chain.lean`
  - ほぼそのまま：`Om`、`om_pos`、`om_succ_lt`、`countable_Iio`、`enumBelow`、`enumBelow_surj`、`params`、`exists_params`。閉包の組み立て `Form`、`witHeight`、`witHeight_lt`、`next`、`lt_next`、`next_lt`、`wit_below`、`tower`、`lam`、`tower_lt`、`tower_mono`、`tower_le_lam`、`lam_lt`、`lt_lam`、`exists_tower`（論理式の型だけ替える）。
  - 置き換え：`lam_elem`（$`Σ_n`$ の一致）は `lam_good`（$`Σ_1`$ だけ）になる。`lab_lam` は `chain_R` になり、新しい補題 `top_abs` が要る。言語に上端述語が入ったからである。`lamChain` とその補題は `cC` とその補題になる。
- 使わないもの：`General.lean`（P4′、$`Φ_m`$、共終な連続性）、`Reflect.lean`（`reflect_one`、`reflect_two` など）、`Main.lean`、`Basic.lean` の $`Σ_n`$ の段の補題（`lev`、`lab` の類、`elem_cofinal` など）。

ライセンス：これらは koteitan 氏のコードで、CC BY-SA 4.0 である。`Por/Model.lean` にはすでに入っていて、`NOTICE` に出どころと、判断が保留であることが書いてある。著作者が Apache-2.0 でも出すと決めるか、書き直す（§5 の 5）。

### 6.4 検査の方法

- 検査は leanman だけで行う。リポジトリの根で `leanman build`、1 ファイルなら `leanman check -C . <ファイル>`。
- 判定は終了コードで行う（0 が緑）。`#print axioms` の出力は、終了コードが 0 か 1 のときだけ意味がある。
- 最終定理の公理は `[propext, Classical.choice, Quot.sound]` になるはずである。ほかの公理（特に `sorryAx`）が出たら止まる。
