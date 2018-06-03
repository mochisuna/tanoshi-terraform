# tanoshi-terraform
たのしくterraformを勉強しよう

# 作るもの
- VPC
- EC2
- ELB（気力次第）
- WAF（気力次第）
- workspaceをS3に配備（気力次第）

# 真面目にやるなら
module分割したほうがいい。
ハンズオンのサンプルなので今回はそこまで頑張らないない。


# USAGE
最初にS3 bucketとDynamoDBを作成します。
```
$ cd ./modules/tfstate/
$ AWS_PROFILE=<profile> terraform apply
```
これがないとエラーになるので注意

その後、モジュールの生成をします。
```
$ AWS_PROFILE=<profile> terraform init
$ AWS_PROFILE=<profile> terraform apply -var 'aws_access_key=<YOUR_KEY>' -var 'aws_secret_key=<YOUR_SECRET>'
```