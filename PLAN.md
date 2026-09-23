# PLAN — 1y-wo-por

- 組合せの層の移植（`notes/02-port.md`）
  - BMS の層を自前で書く（`Por/BMS/`、Std だけ、YesMetaZFC は写さない）
    - 🤖 `ParentAncestor.lean`：親と祖先の補題
    - `Context.lean`：`ExpansionContext` とコピーの座標
    - `CopyLemma.lean`：コピーの補題（BMS の補題 2.5）
  - 取り込んだコア（`ZeroY/`、`OneY/`）を層ごとにビルドし、壊れたところを直す
  - 要らない 19 モジュールと宣言を外す
  - 入口の定理の公理を確かめる
- つなぐ：`Por/WellOrdering.lean` に最終定理 4 つ、このリポジトリの `leanman build` で端から端
- `Por/Model.lean` を `notes/01-design.md` §6 のファイルに分ける
- 文書：README（日英）、NOTICE の更新、公理の監査
- ライセンスの判断（著作者）
  - `Por/Model.lean` の bms-elem-pattern 由来の補助（CC BY-SA 4.0）を Apache-2.0 でも出すか
