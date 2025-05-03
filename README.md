# ecs-fargate-kotlin-canary-datadog

## 🏷️ v.1.0.0 - Canary Blue/Green Deployment com ECS e CodeDeploy via Terraform

Este projeto provisiona uma infraestrutura completa para realizar deployments com estratégia *blue/green* em serviços ECS Fargate, utilizando AWS CodeDeploy. 

A pasta /app contém uma aplicação básica em `Kotlin` (SEM SPRING) para testar o rollout  e rollback do Canary. 

---
## 📂 Estrutura de Pastas

```
.
├── infra/
│   ├── codedeploy/
│   │   └── appspec_sample_template.yaml         # Exemplo de AppSpec para CodeDeploy
│   │
│   ├── inventories/
│   │   └── variables.tfvars                     # Variáveis de entrada (valores)
│   │
│   ├── application_load_balancer.tf            # Recurso ALB
│   ├── code-deploy_application.tf              # CodeDeploy App
│   ├── code-deploy_deployment-group.tf         # CodeDeploy Deployment Group
│   ├── data.tf                                 # Data sources (VPC, subnets, etc.)
│   ├── ecs_cluster.tf                          # ECS Cluster
│   ├── ecs_service.tf                          # Serviço ECS com suporte a blue/green
│   ├── force-deploy.sh                         # Script para forçar deploy automático
│   ├── listener.tf                             # ALB Listener (porta 80)
│   ├── local_appspec.tf                        # AppSpec gerado dinamicamente
│   ├── local_deployment_group_force.tf         # Lógica para forçar novo deploy
│   ├── locals.tf                               # Definições locais reutilizáveis
│   ├── log_group.tf                            # CloudWatch Log Group
│   ├── outputs.tf                              # Outputs do projeto
│   ├── providers.tf                            # Providers e backends
│   ├── s3_revision_object.tf                   # Upload do AppSpec para S3
│   ├── service_autoscaling_target.tf           # Configuração de auto scaling
│   ├── service_task_definition.tf              # Task Definition do ECS
│   └── target_group.tf                         # Target Groups blue e green
```

---
## 🔧 Componentes Principais

- **ECS Fargate**: Ambiente de execução para os containers.
- **Application Load Balancer (ALB)**: Balanceador com listener único na porta 80.
- **Target Groups**: Criados dinamicamente para `blue` e `green`.
- **AWS CodeDeploy**: Orquestra a troca de tráfego entre versões.
- **AppSpec**: Template para controlar o comportamento do deploy.
- **Scripts locais**: Sobrescrevendo o arquivo appspec.yaml do CodeDeploy e forçando novos deploys diretamente no terminal.
---
## 📋 Pré requisitos
0. Possuir um conta AWS. 
1. Ter um repositório ECR com uma imagem dockerizada de aplicação. 
2. Ter role com acessos para o com ECS, CodeDeploy e ECR.
3. Possuir o binário do Terraform instalado em sua máquina. 
4. Executar o Terraform um shell bash. (Para o funcionamento dos resource local)
---

## 📦 Como usar

### 0. Altere a região
Nativamente, está adicionada a region `us-east-1` devido a orquestração na conta free-tier. 

### 1. Configure variáveis
Preencha `variables.tfvars` com os valores da sua conta AWS, nomes de cluster, etc.

### 2. Inicialize, valide as configurações e aplique
```bash
cd ./infra
terraform init
terraform validate
terraform plan
terraform apply -var-file="variables.tfvars"
```
---

## 📌 Observações

- Só é possível ter **um listener por porta** no ALB. A inteligência de alternar entre `blue` e `green` é do **CodeDeploy**.
- O listener padrão aponta inicialmente para o `blue`.
- O `AppSpec` é gerado localmente via `.yaml` e excluído LOCAL após um novo deployment ser realizado via terminal.
- Um novo deploy é na execução do terraform local. Caso a aplicação já tenha um deployment em execução, o comando para execução de um novo deploy é ignorado. 
---

## ⌨️ Próximos passos

### 🏷️v1.5.0 - Integração da aplicação Kotlin com API externa

- [ ]  Remoção dos logs da aplicação de soma aleatória.
- [ ]  Diminuir o intervalo entre as somas aleatórias.
- [ ]  Incluir a API Numbers ([http://numbersapi.com/](http://numbersapi.com/#42)).
- [ ]  Formatar log da API Numbers na aplicação.

### 🏷️v2.0.0 - Monitoramento com Datadog APM

- [ ]  Criar role com políticas do Datadog (ECS)
- [ ]  Instrumentar o Datadog no ECS
- [ ]  Incluir `DD_API_KEY` como env var na task definition
- [ ]  Criar secrets para o Datadog
- [ ]  Validar ingestão de logs e APM
- [ ]  Taguear serviço ECS com Terraform
---
## ❌ Falhas ao executar? 
Abra uma issue! Assim que possível aplicamos a correção. Contribuições são bem vindas!