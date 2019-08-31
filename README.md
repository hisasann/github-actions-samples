## ⛑ github-actions-samples

`github actions` のサンプル集です。

## シンプルなHello-World

[github-actions-samples/hello.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/hello.yml)

```yaml
name: Hello, World! # ワークフローの名前
on: push  # イベント、 [push, pull_request] とすると複数指定可能

jobs: # ジョブを定義
  build:  # ジョブの ID（jobs 内でユニークであればよい）
    name: Greeting  # ジョブ名
    runs-on: ubuntu-latest  # ジョブが実行される仮想環境
    steps:  # ジョブ内で実行されるステップ
      - run: echo "Hello, World!" # ステップで実行するコマンド
```

## プルリクエスト作成時に実行するActions

[github-actions-samples/pull_request.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/pull_request.yml)

参考として、コードを変更せずにプルリクエストを出す方法のリンクを貼っておきます。

[空コミットで実装前にプルリクエストを出す - Qiita](https://qiita.com/katsukii/items/5368598cbecbaefd1ed8)

## Cronで一定間隔で実行するActions

[github-actions-samples/cron.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/cron.yml)

一分間隔で実行したい場合は以下のように書きます。

```yaml
on:
  schedule:
    - cron: "*/1 * * * *"
```

## ジョブの実行順序を制御するActions

[github-actions-samples/needs.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/needs.yml)

ジョブは並列に実行されますが、 `job1` が終わったあとに `job2` を実行したいなどの制御が **needs** で可能になります。

```yaml
jobs:
  job3:
    name: Greeting3
    needs: [job1, job2]
    runs-on: ubuntu-latest
    steps:
      - run: echo "Hello, World 3"
```

## 📚 参考記事

[新 GitHub Actions 入門 - 生産性向上ブログ](https://www.kaizenprogrammer.com/entry/2019/08/18/205010)
