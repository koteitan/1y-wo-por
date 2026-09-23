[← Back](README.md) | [English](en/08-closure-chain.md) | [Japanese](08-closure-chain.md)

# ω₁ より下の閉包と鎖

前提

| ノート | ここで使う言葉 |
|---|---|
| [01 順序数と ω₁](01-ordinals.md) | $`\omega_1`$、正則性、`enumBelow`、`params` |
| [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) | Tarski–Vaught 判定法、`Sat`、`full` |
| [07 関係 R](07-relation-r.md) | $`R`$、`relR`、`topR` |

このノートは、$`\omega_1`$ より下に「$`\Sigma_1`$ の証人で閉じた点」を作る方法を説明する。これは Löwenheim–Skolem の定理と同じ考え方で、証人を足して上限を取る。できた点を並べた鎖が、[09](09-obligations.md) で最初のラベルになる。Lean のファイルは [Por/Closure.lean](../Por/Closure.lean) と [Por/Chain.lean](../Por/Chain.lean) である。

## 1. 周りの構造と Good

**定義（周りの構造）.** すべての記号を持つ高さ $`\omega_1`$ の構造を $`\mathfrak B`$ とする。

```math
\mathfrak B = \bigl(\omega_1;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}^{\omega_1}_j)_{j \in \mathbb N}\bigr), \qquad \mathrm{Top}^{\omega_1}_j(\xi, x) :\iff R(j, \xi, x, \omega_1)
```

上端述語はすべての層で、対角で持つ。見えるビットは `full`（すべて）である。

**定義（Good）.** $`\mathfrak B{\restriction}\gamma`$ を、$`\mathfrak B`$ の領域を $`\{x \mid x \lt \gamma\}`$ に制限したものとする。上端述語は $`\omega_1`$ へのもののままである。

```math
\mathrm{Good}(\gamma) :\iff \mathfrak B{\restriction}\gamma \preccurlyeq_{\Sigma_1} \mathfrak B
```

Lean の `Good γ` は、$`\vec p \lt \gamma`$ のすべての $`\Sigma_1`$ 論理式で、次が同値であることである。

```lean
Sat relR (topR Om) full γ m n D bb r p ↔ Sat relR (topR Om) full Om m n D bb r p
```

$`\mathfrak B{\restriction}\gamma`$ は $`\mathfrak B`$ の本当の部分構造である（解釈が同じで、領域だけが違う）。だから [03](03-sigma1-elementary.md) §6 の Tarski–Vaught 判定法がそのまま使える。

## 2. 論理式は可算個

**定義（`Form`）.** 論理式の型は、5 つ組 $`(m, n, D, \mathit{bb}, r)`$ の型である。

```lean
abbrev Form : Type := Σ m n : ℕ, Set (Diag m n) × ℕ × ℕ
```

**可算である理由.** $`m, n`$ を決めると、`Diag m n` は有限型である（[03](03-sigma1-elementary.md) §3）。その部分集合 $`D`$ も有限個しかない。$`m, n, \mathit{bb}, r`$ は自然数である。よって `Form` は可算である。`List ℕ` も可算なので、`Form × List ℕ` も可算である。

1 つの論理式が使う記号を有限個（上限 $`m`$）にしたのはこのためである。無限個の記号を使える論理式を許すと、論理式の全体が可算にならない（[notes/01-design.md](../notes/01-design.md) §3.8）。

## 3. 証人の高さ

**定義（`witHeight`）.** 論理式 $`\varphi = (m, n, D, \mathit{bb}, r)`$ とパラメータ $`\vec p`$ について：

- $`\mathfrak B \models \varphi(\vec p)`$ なら、証人 $`y_0, \ldots, y_{\mathit{bb}-1} \lt \omega_1`$ を 1 組選び（`Classical.choose`）、$`h(\varphi, \vec p) := \sup_{i \lt \mathit{bb}} (y_i + 1)`$ とする。
- そうでなければ $`h(\varphi, \vec p) := 0`$ とする。

**定理（`witHeight_lt`）.** $`h(\varphi, \vec p) \lt \omega_1`$。

**証明.** 有限個の $`y_i + 1`$ の最大値で、どれも $`\omega_1`$ より下である（`om_succ_lt`）。$`\square`$

選んだ証人はどれも $`h(\varphi, \vec p)`$ より下にある。

## 4. 閉包の 1 段

**定義（`next`）.**

```math
\mathrm{next}(\gamma) := \max\Bigl(\gamma,\ \sup_{(\varphi, l)} h\bigl(\varphi, \mathrm{params}_\gamma(l)\bigr)\Bigr) + 1
```

上限は $`\varphi \in`$ `Form`、$`l \in`$ `List ℕ` の全体を動く。$`\mathrm{params}_\gamma(l)`$ は [01](01-ordinals.md) §6 の、自然数の列で表したパラメータである。

| 定理 | 内容 | 理由 |
|---|---|---|
| `lt_next` | $`\gamma \lt \mathrm{next}(\gamma)`$ | $`+1`$ |
| `next_lt` | $`\gamma \lt \omega_1 \implies \mathrm{next}(\gamma) \lt \omega_1`$ | 可算個の上限（[01](01-ordinals.md) §5） |
| `wit_below` | $`\gamma \lt \omega_1`$、$`\vec p \lt \gamma`$、$`\mathfrak B \models \varphi(\vec p)`$ なら、証人を $`\mathrm{next}(\gamma)`$ より下に取れる | 下の証明 |

**`wit_below` の証明.** `exists_params` から、$`\vec p = \mathrm{params}_\gamma(l)`$ となる列 $`l`$ がある。$`(\varphi, l)`$ について選んだ証人は、$`h(\varphi, \mathrm{params}_\gamma(l))`$ より下にある。これは上限の項の 1 つなので、$`\mathrm{next}(\gamma)`$ より下である。$`\square`$

## 5. 塔と λ

**定義（`tower`、`lam`）.**

```math
\mathrm{next}^0(\gamma) := \gamma, \quad \mathrm{next}^{t+1}(\gamma) := \mathrm{next}\bigl(\mathrm{next}^t(\gamma)\bigr), \qquad \lambda(\gamma) := \sup_{t \in \mathbb N} \mathrm{next}^t(\gamma)
```

| 定理 | 内容 |
|---|---|
| `tower_lt` | $`\gamma \lt \omega_1 \implies \mathrm{next}^t(\gamma) \lt \omega_1`$ |
| `tower_mono` | $`t \le t' \implies \mathrm{next}^t(\gamma) \le \mathrm{next}^{t'}(\gamma)`$ |
| `lam_lt` | $`\gamma \lt \omega_1 \implies \lambda(\gamma) \lt \omega_1`$（可算個の上限） |
| `lt_lam` | $`\gamma \lt \lambda(\gamma)`$ |
| `exists_tower` | $`p_0, \ldots, p_{k-1} \lt \lambda(\gamma)`$ なら、ある $`t`$ で全部 $`\lt \mathrm{next}^t(\gamma)`$ |

`exists_tower` は $`k`$ についての帰納法で示す。各 $`p_i`$ は上限より小さいので、ある $`t_i`$ で $`p_i \lt \mathrm{next}^{t_i}(\gamma)`$ である。$`t := \max_i t_i`$ を取る。

## 6. λ(γ) は Good

**定理（`lam_good`）.** $`\gamma \lt \omega_1`$ なら $`\mathrm{Good}(\lambda(\gamma))`$。

**証明.** Tarski–Vaught 判定法（[03](03-sigma1-elementary.md) §6）の形で示す。$`\vec p \lt \lambda(\gamma)`$ とする。

- $`\Rightarrow`$：$`\lambda(\gamma)`$ より下の証人は、$`\omega_1`$ より下の証人でもある（`lam_lt`）。行列の評価は同じである。
- $`\Leftarrow`$：`exists_tower` から、ある $`t`$ で $`\vec p \lt \mathrm{next}^t(\gamma)`$ である。`wit_below` を $`\mathrm{next}^t(\gamma)`$ で使うと、証人は $`\mathrm{next}^{t+1}(\gamma) \le \lambda(\gamma)`$ より下に取れる。$`\square`$

**例（形だけ）.** $`\gamma = 0`$ とする。$`\lambda(0)`$ は、「$`\mathfrak B`$ で真の $`\Sigma_1`$ の主張で、パラメータが $`\lambda(0)`$ より下のもの」の証人をすべて含む。$`\lambda(0)`$ の具体的な値は分からない。証明は値を使わず、$`\lambda(0) \lt \omega_1`$ と $`\mathrm{Good}(\lambda(0))`$ だけを使う。

**Good な点の集合について.** Good な点の集合が $`\omega_1`$ の中で閉じていることは示していないし、使わない。そのため club（閉非有界集合）とは呼ばない。

## 7. 鎖

**定義（`cC`）.**

```math
c_0 := \lambda(0), \qquad c_{t+1} := \lambda(c_t)
```

| 定理 | 内容 |
|---|---|
| `cC_lt` | $`c_t \lt \omega_1`$ |
| `cC_strictMono` | $`c_0 \lt c_1 \lt c_2 \lt \cdots`$ |
| `cC_good` | $`\mathrm{Good}(c_t)`$ |

どれも §5、§6 から $`t`$ についての帰納法で出る。

この鎖の 2 点は、すべての層と、小さい方までのすべての根の添字で $`R`$ の関係にある（`chain_R`）。その証明には、Good な点で上端述語が $`\omega_1`$ の上端述語と一致すること（`top_abs`）が要る。どちらも [09](09-obligations.md) §4 で説明する。

## 8. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「6 つの仮定の行き先」 | 「初期のラベル付けは、$`\omega_1`$ より下の閉包点の鎖で作る」 |
| [notes/01-design.md](../notes/01-design.md) §3.6、§4.7 | 周りの構造、Good、next、λ、鎖、`lam_good` の証明 |
| [Por/Closure.lean](../Por/Closure.lean) | §1〜§6 |
| [Por/Chain.lean](../Por/Chain.lean) | §7 |

## 9. Lean での対応

| 概念 | Lean | ファイル |
|---|---|---|
| Good | `Good` | [Por/Closure.lean](../Por/Closure.lean) |
| 論理式の型 | `Form` | 同上 |
| 証人の高さ | `witHeight`、`witHeight_lt` | 同上 |
| 閉包の 1 段 | `next`、`lt_next`、`next_lt`、`wit_below` | 同上 |
| 塔と λ | `tower`、`lam`、`tower_lt`、`tower_mono`、`tower_le_lam`、`lam_lt`、`lt_lam`、`exists_tower` | 同上 |
| λ は Good | `lam_good` | 同上 |
| 鎖 | `cC`、`cC_lt`、`cC_strictMono`、`cC_good` | [Por/Chain.lean](../Por/Chain.lean) |
