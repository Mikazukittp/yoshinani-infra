## CI_SERVERについて
基本的にあまりアクセストークンの運用はしたくない（漏れた時のリスク）ので、信頼のおける作業用サーバを用意してそのインスタンスに権限を付与する、という構成にしております。

AWSではインスタンス事態にロールを割り当てることができるので、全ての作業をこのサーバ経由で行うことによりアクセスキーが不要になります。
ロールの詳細ですが、terraformを使う関係で（ほぼ全ての権限がないと無理）Administratorにしております。

立ち上げっぱなしだとお金かかるので普段は寝かせています。
もし必要あれば叩き起こしてあげてくださいまし。

ちなみにElastic IPとかはやってないので毎度public ip は変わります。

## Packer
### 使い方
* CI_SERVERにsshログインする
* packerのディレクトリ（centos.jsonがあるディレクトリ）で以下のコマンドを実行する

```
$ packer build -var-file='packer_vars/aws_variables.json' centos.json
```

#### やろうと思ったができていないこと
* セキュリティグループの設定
* ssh周りの設定
* key周りの設定

## terraform
### 現状の構成
json見てもらえるとわかりやすいかと思いますが、
以下が現時点で自動化できている内容です。

* VPCの作成
* VPCに紐づくpublic/privateサブネットをそれぞれひとつづつ作成
* インターネットゲートウェイを作成
* ルートテーブルの設定でpublicサブネットがインターネットに出れるようにする
* pablicサブネットにyoshinaniのマシンイメージから作成したEC2を作成

### 使い方
* CI_SERVERにsshログインする
* terraform/dev（server.tfがあるディレクトリ）で以下のコマンドを実行する
（destroyで綺麗さっぱい消えてくれるのでテストやりまくってもOKです）

```
# Dry Run
$ terraform plan

# terraform実行
$ terraform apply

# 実行結果の確認
$ terraform show

# お片づけ
$ terraform destroy
```

## Ansible
まだ特に何も用意していません。

ゆくゆくは、packer build 時にansible-localで実行し、provisioning済みのAMIができるイメージ
