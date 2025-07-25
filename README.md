# ecs-fargate-kotlin-canary-datadog

## 🏷️ v2.5.0 - Adição do Datadog Logs e Datadog APM no container da aplicação. 

Este projeto provisiona uma infraestrutura em Terraform pronta para realizar deployments com estratégia *blue/green* em serviços ECS Fargate, utilizando o AWS CodeDeploy. Agora, dividido em módulos, é possível criar apenas os componentes desejados, como apenas o CodeDeploy ou apenas o Application Load Balancer. Nesta nova versão, também é possível utilizar o Datadog para envio automático de logs e traces da aplicação, bastando definir a variável `enable_datadog = true` e ter um Secret do Secret Manager com os valores da API KEY.

A pasta /app contém uma aplicação básica em Kotlin com SPRING para testar o rollout e rollback do Canary. A aplicação obtém dois números aleatórios, soma o número e consulta informações de uma trivia através da [API Numbers](http://numbersapi.com/). Os logs agora incluem payloads estruturados. 

---
### 🌀 Dependências 
```mermaid
flowchart TD
    subgraph Entrypoint
        ALB[Application Load Balancer]
    end

    subgraph ECS Cluster
        ECS[ECS Fargate]
        Service[ECS Service]
        ECS --> Service
        Service -->|Logs e APM| Datadog[(Datadog)]
    end

    subgraph CodeDeploy Stack
        CodeDeploy[AWS CodeDeploy]
        S3["S3: AppSpec e revisões"]
        CodeDeploy --> S3
    end

    ALB --> TGBlue[Target Group Blue]
    ALB --> TGGreen[Target Group Green]

    Service --> TGBlue
    Service --> TGGreen

    TGBlue --> CodeDeploy
    TGGreen --> CodeDeploy
```

> [!TIP] 
> Também é possível utilizar o `terraform graph` para mapear as dependências explícitas da infraestrutura! [graph](graphviz.png)

---
### 📃 Payload da saída de log
```json
{
    "@timestamp": "2025-05-27T01:40:58.995531147Z",
    "@version": "1",
    "message": "sort number: sortFirst=98, sortSecond=0, sum: sortSum=98, response: response=NumberFact(text=98 is the highest jersey number allowed in the National Hockey League (as 99 was retired by the entire league to honor Wayne Gretzky)., number=98, found=true, type=trivia)",
    "logger_name": "app.ScheduledTask",
    "thread_name": "scheduling-1",
    "level": "INFO",
    "level_value": 20000,
    "sortFirst": 98,
    "sortSecond": 0,
    "sortSum": 98,
    "response": {
        "text": "98 is the highest jersey number allowed in the National Hockey League (as 99 was retired by the entire league to honor Wayne Gretzky).",
        "number": 98,
        "found": true,
        "type": "trivia"
    }
}
```
---

## 📂 Estrutura de Pastas

```
./app
└── scripts
    ├── local_pull_ecr.sh
    └── local_gradle_build.sh

./infra
├── application-load-balancer
│   ├── application_load_balancer.tf
│   ├── listener.tf
│   ├── outputs.tf
│   ├── target_group.tf
│   └── variables.tf
│
├── codedeploy
│   ├── appspec_template
│   │   └── appspec_sample_template.yaml
│   ├── code_deploy_application.tf
│   ├── code_deploy_deployment_group.tf
│   ├── data.tf
│   ├── local_appspec.tf
│   ├── local_deployment_group_force.tf
│   ├── locals.tf
│   ├── outputs.tf
│   ├── s3_revision_object.tf
│   ├── scripts
│   │   └── local_force_deploy.sh
│   └── variables.tf
│
├── ecs-service
│   ├── data.tf
│   ├── ecs_cluster.tf
│   ├── ecs_service.tf
│   ├── locals.tf
│   ├── log_group.tf
│   ├── outputs.tf
│   ├── service_autoscaling_target.tf
│   ├── service_task_definition.tf
│   └── variables.tf
│
└── example
    ├── data.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```
---
## 📜 Scripts auxiliares (`./scripts`)

- `local_gradle_build.sh`: Compila o projeto com Gradle, gera o JAR, cria a imagem Docker e chama o local_pull_ecr.sh para versionar e enviar a imagem ao ECR.
- `local_pull_ecr.sh`: Autentica no ECR, busca a próxima versão disponível, cria uma nova tag baseada nela e faz o push da imagem Docker para o repositório.
- `local_force_deploy.sh` : Verifica se há um deployment em andamento no AWS CodeDeploy e, se não houver, faz upload do appspec.yaml para o S3 e inicia um novo deployment, removendo o arquivo local após o envio.
---
## 🔧 Componentes Principais

- **ECS Fargate**: Ambiente de execução para os containers.
- **Application Load Balancer (ALB)**: Balanceador com listener único na porta 8080.
- **Target Groups**: Criados dinamicamente para `blue` e `green`.
- **ECS Service**: Com a task_definition, faz o deploy do serviço com as configurações do Datadog.
- **AWS CodeDeploy**: Orquestra a troca de tráfego entre versões.
- **AppSpec**: Template para controlar o comportamento do deploy.
- **Scripts locais**: Sobrescrevem o appspec.yaml, forçam novos deploys de forma automática, buildam o Gradlew e executam o Docker para validação. Também permitem o pull automático para um ECR repository.
---
## 📋 Pré-requisitos

0. Conta AWS ativa.
1. Repositório ECR com imagem da aplicação.
2. Role IAM com acesso ao ECS, CodeDeploy, ECR e Secret Manager.
3. Terraform instalado.
4. Shell bash para execução do Terraform (uso de recursos `local`).
5. Secret do Secret Manager com a API KEY do Datadog para envio do trace e logs.
---

## 📦 Como usar cada módulo
### 0. Altere a região
Por padrão, está `us-east-1` para compatibilidade com a conta free-tier.

### 1. Adicione os módulos desejados
```hcl
terraform {
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=v3.0.0"
}
```
Preencha o `variables.tfvars` com dados da sua conta, ou use `data` para busca dinâmica. Veja o diretório `infra/example` para exemplo de como inserir as informações dinamicamente.
### 2. Inicialize e aplique

```bash
terraform init
terraform validate
terraform plan
terraform apply -var-file="variables.tfvars"
```

Ou:

```bash
terraform apply -var-file="variables.tfvars"
```

---
## 📌 Observações
- Só pode haver **um listener por porta** no ALB.
- A troca entre `blue` e `green` é gerenciada pelo **CodeDeploy**.
- O listener padrão aponta inicialmente para o `blue`.
- O `AppSpec` é gerado e excluído localmente após o deploy.
- Um novo deploy ocorre via execução local do Terraform.
- Módulos são independentes, mas exigem dependências previamente criadas. Em situações de reuso, garanta que a infraestrutura seja compatível.
- Para usar o Datadog, é necessário um Secret no **AWS Secrets Manager** contendo a API Key, para que o agente envie traces e logs.
- É imprescindível ter uma **IAM Role** com permissões para **Secrets Manager**, **ECS**, **Auto Scaling** e **CodeDeploy**.
---

## ⌨️ Histórico (Tags)

- [x] v1.0.0 - Canary Blue/Green Deployment com ECS e CodeDeploy via Terraform
- [x] v1.5.0 - Modularização na criação do Load Balancer, ECS Service e CodeDeploy
- [x]  v2.0.0 - Integração da aplicação Kotlin com API externa -> http://numbersapi.com/
- [x]  v2.5.0 - Adição do Datadog APM e Datadog Logs
- [ ]  v3.0.0 - Adição do Github Actions para criação da infraestrutura via pipeline
- [ ]  vx.x.x - Migração de ECS Fargate para EKS Fargate

---
## ❌ Falhas ao executar?
Abra uma **issue**! Correções e contribuições são bem-vindas.
