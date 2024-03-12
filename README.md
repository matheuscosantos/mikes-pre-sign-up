# Lambda Handler: Pré-Sign-Up Cognito

Este Lambda function é responsável por configurar a resposta automática de confirmação de usuário durante o processo de pré-sign-up no pool de usuários do Cognito. Ele recebe um evento contendo informações sobre a solicitação de registro de usuário e define a confirmação automática do usuário como verdadeira, permitindo que o usuário seja registrado sem a necessidade de confirmação por e-mail ou SMS.

[Desenho da arquitetura](https://drive.google.com/file/d/12gofNmXk8W2QnhxiFWCI4OmvVH6Vsgun/view?usp=drive_link)

## Estrutura do Evento

A função espera um evento no seguinte formato:

```json
{
  "version": "string",
  "triggerSource": "string",
  "region": "string",
  "userPoolId": "string",
  "userName": "string",
  "callerContext": {
    "awsSdkVersion": "string",
    "clientId": "string"
  },
  "request": {
    "userAttributes": {
      "string": "string",
      ...
    },
    "validationData": {
      "string": "string",
      ...
    }
  },
  "response": {}
}
```

A função modifica o campo response para incluir a chave autoConfirmUser como True.

## Nota

Este Lambda function deve ser associado ao trigger de pré-sign-up no pool de usuários do Cognito para que a configuração de confirmação automática seja aplicada.

## Dependências

Nenhuma dependência externa é necessária para esta função além das bibliotecas padrão do Python.

## Política

Para que o Lambda function possa ser executado, é necessário que a função tenha permissão para assumir um papel no AWS Identity and Access Management (IAM). A política de assunção de papel necessária pode ser definida no arquivo policy/lambda_assume_role_policy.json com o seguinte conteúdo:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
```

## Terraform

Este Lambda function pode ser provisionado utilizando o Terraform. Um exemplo de configuração do Terraform é fornecido abaixo:

```json
terraform {
  backend "s3" {
  bucket         = "mikes-terraform-state"
  key            = "mikes-lambda-pre-sign-up.tfstate"
  region         = "us-east-2"
  encrypt        = true
}
}

provider "aws" {
region = var.region
}

resource "aws_iam_role" "mikes_lambda_pre_sign_up_role" {
name               = "mikes_lambda_pre_sign_up_role"
assume_role_policy = file("policy/lambda_assume_role_policy.json")
}

resource "aws_lambda_function" "mikes_lambda_pre_sign_up" {
function_name = "mikes_lambda_pre_sign_up"
handler       = "app/lambda_function.handler"
runtime       = "python3.11"
role          = aws_iam_role.mikes_lambda_pre_sign_up_role.arn

filename = "lambda_function.zip"

source_code_hash = filebase64sha256("lambda_function.zip")

depends_on = [
aws_iam_role.mikes_lambda_pre_sign_up_role
]
}

variable "region" {
type    = string
default = "us-east-2"
}
```

Lembre-se de substituir os valores de bucket e key no bloco backend "s3" com o nome do seu bucket do S3 e o nome do arquivo de estado desejado, respectivamente. Também é importante ajustar o arquivo policy/lambda_assume_role_policy.json conforme necessário para atender aos requisitos de segurança da sua aplicação.