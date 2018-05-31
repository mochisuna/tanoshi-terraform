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
```
$ terraform init
$ terraform apply -var 'aws_access_key=<YOUR_KEY>' -var 'aws_secret_key=<YOUR_SECRET>'
```