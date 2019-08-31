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

## シンプルにnode.jsを実行するActions

[github-actions-samples/node.js.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/node.js.yml)

```yaml
jobs:
  build:
    name: Greeting
    runs-on: ubuntu-latest
    steps:
      - run: node -e 'console.log("Hello, World!");'
```

`runs-on` で指定している環境内で使える CLI コマンドや、インストールされているものは以下を参照してください。

`TypeScript` や `Parcel` なども入っていて、 `AWS-CLI` も入っているので、困ることはなさそうです。

[Software in virtual environments for GitHub Actions - GitHub Help](https://help.github.com/en/articles/software-in-virtual-environments-for-github-actions)

## 環境変数を使うActions

[github-actions-samples/env.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/env.yml)

```yaml
jobs:
  build:
    name: Greeting
    runs-on: ubuntu-latest
    steps:
      - env:
          NAME: hisasann
        run: echo "Hello, ${NAME}!"
```

[Virtual environments for GitHub Actions - GitHub Help](https://help.github.com/en/articles/virtual-environments-for-github-actions#environment-variables)

## Marketplaceに公開されているnode.jsを使ってみる

[github-actions-samples/setup-node.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/setup-node.yml)

```yaml
jobs:
  build:
    name: Greeting
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: actions/setup-node@v1
        with:
          node-version: '10.x'
      - run: npm install
      - run: npm test
        env:
          NAME: hisasann
```

以下の公開されている `setup-node` を使ってみました。

[actions/setup-node: Set up your GitHub Actions workflow with a specific version of node.js](https://github.com/actions/setup-node)

また、自分でマーケットプレイスに公開することもできるようなので、作りたいのを見つかったら公開してみたいと思います。

[【GitHub Actions】Slack通知用のactionをTypeScriptで開発してみた - Qiita](https://qiita.com/homines22/items/0bc6c17e038b35fc8113)

余談ですが、 **env** の使い方で、以下のようにハイフンのブロック範囲を間違えて env を指定すると `npm test` に渡らないので注意が必要です。

```yaml
  - run: npm install
    env:
      NAME: hisasann
  - run: npm test
```

こっちが正解🌭

```yaml
  - run: npm install
  - run: npm test
    env:
      NAME: hisasann
```

## マトリクスビルドActions

[github-actions-samples/matrix-build.yml](https://github.com/hisasann/github-actions-samples/blob/master/.github/workflows/matrix-build.yml)

このあたりになってくると、個人的にかなり使うジャンルに入ってきました。

いろんな環境で `npm test` が通るかは、 npm module を開発するときにとても重宝するので、 github 上でこうゆうテストが実行できるのはありがたいです！

```yaml
jobs:
  build:
    name: Node.js ${{ matrix.os }} ${{ matrix.node }}
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        node: [ '10', '8' ]
    steps:
      - uses: actions/checkout@master
      - name: Setup node
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node }}
      - run: yarn install
      - run: yarn test
        env:
          NAME: hisasann
```

### appveyor.ymlでの書き方

余談ですが、普段この手のテストは `appveyor` を使っているので、その感じを書いておきます。

```yaml
version: "{build}"

clone_depth: 10

init:
  - git config --global core.autocrlf false

environment:
  matrix:
    # node.js
    - nodejs_version: 8
    - nodejs_version: 10

install:
  - ps: Install-Product node $env:nodejs_version
  - IF %nodejs_version% LSS 8 npm -g install npm@5
  - npm install --ignore-scripts

build: off

test_script:
  - node --version && npm --version
  - npm run test

matrix:
  fast_finish: false
```

[typescript-nuxtjs-boilerplate/appveyor.yml](https://github.com/typescript-nuxtjs-boilerplate/typescript-nuxtjs-boilerplate/blob/master/appveyor.yml)

## 📚 参考記事

[新 GitHub Actions 入門 - 生産性向上ブログ](https://www.kaizenprogrammer.com/entry/2019/08/18/205010)
