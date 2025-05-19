# ecs-fargate-kotlin-canary-datadog

## 🏷️ v1.5.0 - Modularização na criação do Load Balancer, ECS Service e CodeDeploy

Este projeto provisiona uma infraestrutura completa para realizar deployments com estratégia *blue/green* em serviços ECS Fargate, utilizando AWS CodeDeploy. Agora, dividido em módulos, é possível criar apenas os componentes que desejar, como apenas o CodeDeploy ou apenas o Application Load Balancer. 

A pasta `/app` contém uma aplicação básica em `Kotlin` (SEM SPRING) para testar o rollout e rollback do Canary.

---

## 📂 Estrutura de Pastas

```
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
│   │   └── force-deploy.sh
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

## 🔧 Componentes Principais

- **ECS Fargate**: Ambiente de execução para os containers.
- **Application Load Balancer (ALB)**: Balanceador com listener único na porta 8080.
- **Target Groups**: Criados dinamicamente para `blue` e `green`.
- **AWS CodeDeploy**: Orquestra a troca de tráfego entre versões.
- **AppSpec**: Template para controlar o comportamento do deploy.
- **Scripts locais**: Sobrescrevem o appspec.yaml e forçam novos deploys de forma automática. 

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
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=develop"
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
- Módulos são independentes, mas exigem dependências previamente criadas. Em situações de reuso, garanta que a infraestrutura seja compatível, 

---

## ⌨️ Próximos passos

### ✅ v1.0.0
Canary Blue/Green Deployment com ECS e CodeDeploy via Terraform

### ✅ v1.5.0
Modularização na criação do Load Balancer, ECS Service e CodeDeploy

### 🏷️ v2.0.0
Integração da aplicação Kotlin com API externa

- [ ] Remoção dos logs da aplicação de soma aleatória
- [ ] Diminuir intervalo entre somas aleatórias
- [ ] Incluir API Numbers ([http://numbersapi.com/](http://numbersapi.com/#42))
- [ ] Formatar log da API Numbers

### 🏷️ v2.5.0
Monitoramento com Datadog APM

- [ ] Criar role com políticas do Datadog (ECS)
- [ ] Instrumentar ECS com Datadog
- [ ] Adicionar `DD_API_KEY` como env var
- [ ] Criar secrets no Terraform
- [ ] Validar ingestão de logs e APM
- [ ] Taguear serviço ECS com Terraform

---

## ❌ Falhas ao executar?

Abra uma **issue**! Correções e contribuições são bem-vindas.