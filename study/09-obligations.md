[← Back](README.md) | [English](en/09-obligations.md) | [Japanese](09-obligations.md)

# 義務の証明

前提

| ノート | ここで使う言葉 |
|---|---|
| [06 Phyrion 氏の組合せの層](06-combinatorial-layer.md) | 図式、表現、上端のアトム、`Admissible`、`FiniteReflection`、6 つの仮定 |
| [07 関係 R](07-relation-r.md) | $`R`$、`R_iff`、`allowL`、`R_lt`、`R_weaken` |
| [08 ω₁ より下の閉包と鎖](08-closure-chain.md) | $`\mathfrak B`$、Good、鎖 $`c_t`$ |

このノートは、関係 $`R`$ が組合せの層の 6 つの仮定をどう満たすかを説明する。中心は有限反映（§3）と、最初の表現（§4）である。

## 1. 仮定の一覧

ラベルのデータは $`\alpha = \mathrm{Ord}`$、$`\lt`$、$`D = \mathrm{True}`$、$`R`$ である（[notes/01-design.md](../notes/01-design.md) §3.5）。

| 記号 | 仮定 | Lean 名 | 節 |
|---|---|---|---|
| O1 | `hWF` | `Ordinal.lt_wf` | §2 |
| O2 | `hTrans` | `fun h₁ h₂ => h₁.trans h₂` | §2 |
| O3 | `hStrict` | `R_lt` | §2 |
| O4 | `hWeak` | `fun h hR => R_weaken h.le hR` | §2 |
| O6 | `reflection` | `finiteReflection` | §3 |
| O7 | `initial` | `initial_all` | §4 |

O5 は `Representation` の定義で、義務は無い。

## 2. O1〜O4

- O1：順序数の $`\lt`$ は整礎である（[01](01-ordinals.md) §1）。
- O2：順序数の $`\lt`$ は推移的である。
- O3：`R_iff` の第 2 項（[07](07-relation-r.md) §7）。
- O4：`R_weaken` は $`\eta' \le \eta`$ で示してある。コアは $`\eta' \lt \eta`$ の版を求めるので、`h.le` で渡す。

## 3. O6：有限反映

**示すこと.** [06](06-combinatorial-layer.md) §4 の仮定の下で、$`g`$ を作る。記号は次のとおりである。$`n`$ は $`G`$ のサイズ、$`f`$ は表現、制御関係は $`R(K, \theta, f(\mathrm{cut}), \beta)`$、要求は $`d = (k_d, r_d, p_d)`$ である。

**証明.**

1. $`a := f(\mathrm{cut})`$ と置く。`R_iff` から $`\theta \le a \lt \beta`$ と $`\mathrm{Elem}(K, \theta, a, \beta)`$ が出る。
2. 名前の位置を $`S := \{r_d \mid d \in \mathrm{needs},\ k_d = K\}`$ とする。$`k_d = K`$ なら `Admissible` の第 1 の場合は起きないので、$`r_d \lt \mathrm{cut}`$ かつ $`f(r_d) \lt \theta`$ である。
3. パラメータは $`f(0), \ldots, f(\mathrm{cut} - 1)`$ とする。$`f`$ は増加なので、どれも $`\lt a`$ である。
4. 次の $`\Sigma_1`$ 論理式 $`\Phi`$ を作る。$`i \lt \mathrm{cut}`$ なら $`z_i := f(i)`$、$`\mathrm{cut} \le i \lt n`$ なら $`z_i := y_i`$ とする。

```math
\Phi :\equiv \exists y_{\mathrm{cut}} \cdots \exists y_{n-1}\ \Bigl[\ \bigwedge_{i \lt j \lt n} z_i \lt z_j \ \land\ \bigwedge_{e \in G} \mathrm{Rel}_{k_e}(z_{r_e}, z_{p_e}, z_{q_e}) \ \land\ \bigwedge_{d \in \mathrm{needs}} \mathrm{Top}_{k_d}(z_{r_d}, z_{p_d})\ \Bigr]
```

5. $`\Phi`$ は段 $`(K, \theta)`$ の論理式である。$`k_d \lt K`$ の $`\mathrm{Top}_{k_d}`$ は対角なので、第 1 引数 $`z_{r_d}`$ が証人でもよい。$`k_d = K`$ なら $`r_d \in S`$ で、名前付きの $`\mathrm{Top}_{K, f(r_d)}`$ である。
6. 高さ $`\beta`$ で $`\Phi`$ は真である。証人を $`y_i := f(i)`$ と取ると $`z = f`$ になる。順序は表現の 2 番目、$`\mathrm{Rel}`$ は表現の 3 番目、$`\mathrm{Top}`$ は要求の仮定（$`R(k_d, f(r_d), f(p_d), \beta)`$）から出る。
7. 1 の初等性から、高さ $`a`$ でも $`\Phi`$ は真である。その証人 $`y'_i \lt a`$ を取る。
8. $`g := `$ `cat cut f y'` とする。つまり $`i \lt \mathrm{cut}`$ なら $`g(i) = f(i)`$、そうでなければ $`g(i) = y'_i`$。
   - $`g`$ は増加である（順序の項）。
   - $`G`$ の各アトムで $`R`$ が成り立つ（$`\mathrm{Rel}`$ の項）。
   - $`g(i) \lt a`$（左の部分は $`f(i) \lt f(\mathrm{cut})`$、右の部分は証人が $`\lt a`$）。
   - 各要求で $`R(k_d, g(r_d), g(p_d), a)`$（高さ $`a`$ では $`\mathrm{Top}_j(\xi, x)`$ は $`R(j, \xi, x, a)`$）。$`\square`$

**例.** $`G`$ を $`(1, 2, 4)`$ の図式とする（アトムは $`(0,0,0,1)`$、$`(0,0,1,2)`$、$`(0,1,1,2)`$）。$`\mathrm{cut} = 1`$、$`K = 0`$、要求を $`d = (0, 0, 2)`$ の 1 つとする。$`f(0) \lt \theta`$ なら $`d`$ は許される。$`S = \{0\}`$、パラメータは $`p_0 = f(0)`$ で、$`\Phi`$ は次のとおりである。

```math
\exists y_1\ \exists y_2\ \bigl[\ p_0 \lt y_1 \land p_0 \lt y_2 \land y_1 \lt y_2 \land \mathrm{Rel}_0(p_0, p_0, y_1) \land \mathrm{Rel}_0(p_0, y_1, y_2) \land \mathrm{Rel}_0(y_1, y_1, y_2) \land \mathrm{Top}_{0, p_0}(y_2)\ \bigr]
```

高さ $`\beta`$ では $`(y_1, y_2) = (f(1), f(2))`$ が証人である。反映すると、$`f(1)`$ より下に新しい $`(y'_1, y'_2)`$ が取れる。

**Lean での形.** 記号の上限を `sigBound G needs`（アトムの層の和 + 要求の層の和 + 1）とし、行列を `reflMat G needs m` とする。`reflMat_iff` が行列の中身を読む。読み出しには `getLt`、`getRel`、`getTop` とその `_diagM` 補題を使う。

**使わなかったもの.** $`D(\beta)`$、$`a`$ や $`\beta`$ が極限であること、閉包点であること。

## 4. O7：最初の表現

### 4.1 上端述語の絶対性

**定理（`top_abs`）.** $`\mathrm{Good}(\alpha)`$ かつ $`\alpha \lt \omega_1`$ とする。すべての $`j`$ と $`\zeta, x \lt \alpha`$ について次が成り立つ。

```math
R(j, \zeta, x, \alpha) \iff R(j, \zeta, x, \omega_1)
```

**証明.** $`(j, \zeta)`$ について、$`\mathbb N \times \mathrm{Ord}`$ の辞書式順序で整礎帰納法をする（[02](02-well-founded.md) §2）。

1. `R_iff` で両辺を開く。$`\zeta \le x`$ は共通で、$`x \lt \alpha`$ も $`x \lt \omega_1`$ も真である。残りは、段 $`(j, \zeta)`$ の論理式 $`\psi`$（パラメータ $`\lt x`$）について、高さ $`\alpha`$ と高さ $`\omega_1`$ での真偽が一致することである（`sat_abs`）。
2. $`\psi`$ が読む上端述語のビット $`\mathrm{Top}_i(u, v)`$（$`u, v \lt \alpha`$）は $`(i, u) \prec (j, \zeta)`$ を満たす。帰納法の仮定から、高さ $`\alpha`$ と $`\omega_1`$ で真偽が同じである。
3. よって高さ $`\alpha`$ の構造は、見えるビットで $`\mathfrak B{\restriction}\alpha`$ と一致する。`sat_mask` で、段の論理式を、見えないビットを偽にした全記号の論理式 $`\psi^*`$ に訳す。
4. $`\mathrm{Good}(\alpha)`$ から、$`\mathfrak B{\restriction}\alpha \models \psi^* \iff \mathfrak B \models \psi^*`$。
5. もう一度 `sat_mask` で戻すと、高さ $`\omega_1`$ の段 $`(j, \zeta)`$ の構造での真偽になる。$`\square`$

3 で「見えるかどうかは位置だけで決まる」（[03](03-sigma1-elementary.md) §8）を使う。名前付きの上端述語にした理由はここにある（[notes/01-design.md](../notes/01-design.md) §3.8 の 3）。

### 4.2 鎖の 2 点は R の関係にある

**定理（`chain_R`）.** $`i \lt j`$、任意の層 $`k`$、$`\eta \le c_i`$ について $`R(k, \eta, c_i, c_j)`$。

**証明.** $`\eta \le c_i \lt c_j`$ なので、条件の部分は満たされる。段 $`(k, \eta)`$ の論理式 $`\psi`$ と、パラメータ $`\vec p \lt c_i`$ について、次の同値をつなぐ。

```math
\mathfrak A^{c_i}_{k,\eta} \models \psi \iff \mathfrak B{\restriction}c_i \models \psi^* \iff \mathfrak B \models \psi^* \iff \mathfrak B{\restriction}c_j \models \psi^* \iff \mathfrak A^{c_j}_{k,\eta} \models \psi
```

1 番目と 4 番目は `top_abs`（$`c_i`$ と $`c_j`$ で使う）と `sat_mask`、2 番目と 3 番目は $`\mathrm{Good}(c_i)`$ と $`\mathrm{Good}(c_j)`$ である。$`\square`$

### 4.3 すべての図式の表現

**定理（`initial_all`）.** どの図式 $`G`$ にも表現がある。

**証明.** $`f := c`$（鎖）とする。

- $`D`$ は True なので、定義域の条件は自明である。
- $`f`$ は狭義増加である（`cC_strictMono`）。
- アトム $`(k, r, p, q)`$ は $`r \le p \lt q`$ なので $`c_r \le c_p \lt c_q`$ である。`chain_R` を $`\eta := c_r`$ で使うと $`R(k, c_r, c_p, c_q)`$。$`\square`$

1 つの $`f`$ がすべての図式を同時に表現する。特に `exprDiagram s` を表現するので、O7 が成り立つ。上界や種の条件は要らない。

## 5. まとめと最終定理

`model_obligations`（[Por/Model.lean](../Por/Model.lean)）は、6 つの仮定を入口の定理と同じ形で並べた定理である。

```lean
theorem model_obligations :
    WellFounded (α := Ord) (· < ·) ∧
    (∀ {a b c : Ord}, a < b → b < c → a < c) ∧
    (∀ {k : ℕ} {index a b : Ord}, R k index a b → a < b) ∧
    (∀ {k : ℕ} {small large p c : Ord}, small < large → R k large p c → R k small p c) ∧
    FiniteReflection (α := Ord) (· < ·) (fun _ => True) R ∧
    (∀ G : Diagram, ∃ f, Representation (α := Ord) (· < ·) (fun _ => True) R G f)
```

[Por/WellOrdering.lean](../Por/WellOrdering.lean) はこれを `OneY.RootIndexed.actual_expansion_wellFounded` に渡して `expansion_wellFounded` を得る。残りの 3 つは `OneY.Numeric` の系に `expansion_wellFounded` を渡すだけである。

**公理.** 主な定理はどれも `propext`、`Classical.choice`、`Quot.sound` だけに依存する（[README](../README.md)「公理の監査」）。

**強さ.** 証明は選択公理と $`\omega_1`$ の正則性を使う。ラベルは $`\omega_1`$ より下の閉包点で、具体的な値は分からない。順序数の上界や表記系は得られない。

## 6. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「6 つの仮定の行き先」 | 仮定の表と、有限反映・初期のラベル付けの要約 |
| [notes/01-design.md](../notes/01-design.md) §2.3、§4.2〜§4.10 | 義務の表と、各義務の証明 |
| [Por/Reflection.lean](../Por/Reflection.lean) | §3 |
| [Por/Chain.lean](../Por/Chain.lean) | §4 |
| [Por/Model.lean](../Por/Model.lean)、[Por/WellOrdering.lean](../Por/WellOrdering.lean) | §5 |
| [Audit.lean](../Audit.lean) | §5 の公理 |

## 7. Lean での対応

| 概念 | Lean | ファイル |
|---|---|---|
| 行列の読み出し | `getLt`、`getRel`、`getTop`、`getLt_diagM`、`getRel_diagM`、`getTop_diagM` | [Por/Reflection.lean](../Por/Reflection.lean) |
| 記号の上限 | `sigBound`、`atom_layer_lt`、`need_layer_lt` | 同上 |
| 反映する論理式 | `reflMat`、`reflMat_iff` | 同上 |
| O6 | `finiteReflection` | 同上 |
| 絶対性の 1 段 | `sat_abs` | [Por/Chain.lean](../Por/Chain.lean) |
| 上端述語の絶対性 | `top_abs` | 同上 |
| 鎖の関係 | `chain_R` | 同上 |
| O7 | `initial_all` | 同上 |
| 6 つのまとめ | `model_obligations` | [Por/Model.lean](../Por/Model.lean) |
| 最終定理 | `expansion_wellFounded`、`generated_strictWellOrder`、`descendants_strictWellOrder`、`expansion_chain_reaches_empty` | [Por/WellOrdering.lean](../Por/WellOrdering.lean) |
