# おすすめくん
## 更新手順
### Lambda関数用のパッケージ作成手順
```
1. Dockerコンテナを起動し、シェルに入る
$ docker run --rm -it -v $PWD:/var/task -w /var/task awsruby32

2. bundlerのインストール先を指定して、インストールする
bash-4.2# bundle config set --local path 'vendor/bundle' && bundle install

3. アップロード用のzipファイルを作成
bash-4.2# zip -r my_deployment_package.zip lambda_function.rb vendor

4. AWS lambd Consoleで更新したいlambda関数のページを開き、"アップロード元"から"my_deployment_package.zip"をアップロードする

5. 完了
```

### Lambdaレイヤー用のlayer作成手順
```
1. Dockerコンテナを起動し、シェルに入る
$ docker run --rm -it -v $PWD:/var/task -w /var/task awsruby32

2. bundlerのインストール先を指定して、インストールする
bash-4.2# bundle config set --local path 'vendor/bundle' && bundle install

3. アップロード用のzipファイルを作成
bash-4.2# (cd vendor/bundle && zip -r ../my_deployment_layer.zip ruby)
"

4. AWS lambd Consoleで更新したいレイヤーのページを開き、バージョンの作成をする。"アップロード元"から"my_deployment_layer.zip"をアップロードする

5. 完了
```

## 開発環境の作成手順
### Dcoekrを使ってビルド環境を作成
```
$ docker build -t awsruby32 .
```

## 参考
https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/ruby-package.html
