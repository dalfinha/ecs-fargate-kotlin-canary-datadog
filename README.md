# ecs-fargate-kotlin-canary-datadog

## 🏷️ v2.0.0 - Integração da aplicação Kotlin com API Numbers (http://numbersapi.com/)

Este projeto provisiona uma infraestrutura completa para realizar deployments com estratégia *blue/green* em serviços ECS Fargate, utilizando AWS CodeDeploy. Agora, dividido em módulos, é possível criar apenas os componentes que desejar, como apenas o CodeDeploy ou apenas o Application Load Balancer.

A pasta `/app` contém uma aplicação básica em `Kotlin` com SPRING para testar o rollout e rollback do Canary. A aplicação obtem dois números aleatórios, soma o número e consulta informações de uma trivia através da API Numbers, uma API pública que permite consultas sem credenciais. Também foi configurado um payload de log para uso durante a instrumentação do Datadog. 


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
└──scripts
   ├── local_pull_ecr.sh
   └── local_gradle_build.sh
./infra
├── application-load-balancer
│   ├── application_load_balancer.tf
│   ├── listener.tf
│   ├── outputs.tf
│   ├── target_group.tf
│   └── variables.tf
├── codedeploy-scope
│   ├── appspec_template
│   │   └── appspec_sample_template.yaml
│   ├── code-deploy_application.tf
│   ├── code-deploy_deployment-group.tf
│   ├── data.tf
│   ├── local_appspec.tf
│   ├── local_deployment_group_force.tf
│   ├── locals.tf
│   ├── outputs.tf
│   ├── s3_revision_object.tf
│   ├── scripts
│   │   └── local_force_deploy.sh
│   └── variables.tf
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
└── example
    ├── data.tf
    ├── inventories
    │   └── variables.tfvars
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```
---
## 📜 Scripts auxiliares (`/app/scripts`)

- `local_gradle_build.sh`: Compila o projeto com Gradle, gera o JAR, cria a imagem Docker e chama o local_pull_ecr.sh para versionar e enviar a imagem ao ECR.
- `local_pull_ecr.sh`: Autentica no ECR, busca a próxima versão disponível, cria uma nova tag baseada nela e faz o push da imagem Docker para o repositório.
---
## 🔧 Componentes Principais

- **ECS Fargate**: Ambiente de execução para os containers.
- **Application Load Balancer (ALB)**: Balanceador com listener único na porta 8080.
- **Target Groups**: Criados dinamicamente para `blue` e `green`.
- **AWS CodeDeploy**: Orquestra a troca de tráfego entre versões.
- **AppSpec**: Template para controlar o comportamento do deploy.
- **Scripts locais**: Sobrescrevem o appspec.yaml, forçam novos deploys de forma automática, buildam o Gradlew e executam o Docker para validação. Também permitem o pull automático para um ECR repository.

---

## 📋 Pré-requisitos

0. Conta AWS válida.
1. Repositório ECR com imagem da aplicação.
2. Role com acesso ao ECS, CodeDeploy e ECR.
3. Terraform instalado.
4. Shell bash para execução do Terraform (uso de recursos `local`).

---

## 📦 Como usar cada módulo

### 0. Altere a região

Por padrão, está `us-east-1` para compatibilidade com a conta free-tier.

### 1. Adicione os módulos desejados

```hcl
terraform {
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=v2.0.0"
}
```

Preencha o `variables.tfvars` com dados da sua conta, ou use `data` para busca dinâmica. Veja o diretório `example` para exemplos.

### 2. Inicialize e aplique

```bash
terraform init
terraform validate
terraform plan
terraform apply -var-file="variables.tfvars"
```

Ou:

```bash
terraform apply -var-file="inventories/variables.tfvars"
```

---

## 📌 Observações

- Só pode haver **um listener por porta** no ALB.
- A troca entre `blue` e `green` é gerenciada pelo **CodeDeploy**.
- O listener padrão aponta inicialmente para o `blue`.
- O `AppSpec` é gerado e excluído localmente após o deploy.
- Um novo deploy ocorre via execução local do Terraform.
- Módulos são independentes, mas exigem dependências previamente criadas. Em situações de reuso, garanta que a infraestrutura seja compatível.

---

## ⌨️ Próximos passos

#### ✅ v1.0.0 - Canary Blue/Green Deployment com ECS e CodeDeploy via Terraform
#### ✅ v1.5.0  - Modularização na criação do Load Balancer, ECS Service e CodeDeploy
#### ✅ v2.0.0 - Integração da aplicação Kotlin com API externa -> http://numbersapi.com/

### 🏷️ v2.5.0 - Monitoramento com Datadog APM
- [ ] Criar secrets no Terraform
- [ ] Adicionar `DD_API_KEYs` como env var
- [ ] Criar role com políticas do Datadog (ECS)
- [ ] Instrumentação do OpenTelemetry
- [ ] Instrumentar ECS com Datadog
- [ ] Validar ingestão de logs e APM
- [ ] Taguear serviço ECS com Terraform
---

## ❌ Falhas ao executar?

Abra uma **issue**! Correções e contricd buições são bem-vindas.