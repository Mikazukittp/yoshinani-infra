## Packer
### 使い方
現状、packer上にawsのアクセスキーを持たせていないため、ローカルで実行しても動きません。

yoshinaniの環境で利用するためには以下が必要です（下記インスタンス、作成して停止してあります）
* 「CI_SERVER」というロールを設定したEC2インスタンスを作成する
* そのサーバ上にansible,packer,terraformをインストールする

```
sudo pip install ansible
wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip
sudo unzip /tmp/packer.zip -d /usr/local/bin/
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.7.4/terraform_0.7.4_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/local/bin/
```

* このリポジトリをcloneする
* packerのディレクトリ（centos.jsonがあるディレクトリ）で以下のコマンドを実行する

```
$ packer build -var-file='packer_vars/aws_variables.json' centos.json
```

#### CI_SERVERというロールについて
基本的にあまりアクセストークンの運用はしたくない（漏れた時のリスク）ので、信頼のおける作業用サーバを用意してそのインスタンスに権限を付与する、という構成にしております。

このロールの詳細ですが、ec2インスタンスのみに紐付け可能なロールで権限はAdministratorAccess（今後terraformなども使おうとしているので権限かなり強い）です。


#### やろうと思ったができていないこと
* セキュリティグループの設定
* ssh周りの設定
* key周りの設定

## Ansible
まだ特に何も用意していません。

ゆくゆくは、packer build 時にansible-localで実行し、provisioning済みのAMIができるイメージ
