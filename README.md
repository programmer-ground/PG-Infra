# ProgrammerGround Infra 

## 폴더 구조 
```
├──consul (사용X -> 기존 Euraka 사용 예정)
│   ├── config
│   └── data 
├── mysql
│   ├── conf.d
│   │     └── my.cnf 
│   ├── data 
│   └── .env.sample 
├── service-script (각 서비스 Vault 설정용 쉘 스크립트)
│   ├── .env.sample
│   ├── setup-pg-auth-vault-approle.sh (Auth Service 초기 설정 쉘 스크립트)
│   └── setup-pg-main-vault-approle.sh (Main Service 초기 설정 쉘 스크립트)
├── vault
│   ├── config
│   │     └── config.hcl (Vault 설정 http://localhost:8082로 접근 가능)
│   └── data
└── unseal-vault-enable-approle-database.sh (Docker Compose 올린 후 초기 Vault Setup 쉘 스크립트)
```

## 사용법

1. 도커 컨테이너 동작 명령어

`docker-compose up -d`

2. Mysql이 정상 로드된 것을 확인 후 초기 셋업 쉘 스크립트 수행

`./unseal-vault-enable-approle-database.sh`

```
************************************************************
export VAULT_ROOT_TOKEN=s.EFQqF8P57d1QPAVwETJknG6c
************************************************************
```

수행이 정상적으로 완료되면 마지막에 뜨는 명령어를 수행

`http://localhost:8082` 에서 설정 값 확인 가능

접속은 해당 `VAULT_ROOT_TOKEN=s.EFQqF8P57d1QPAVwETJknG6c` 값으로 로그인하여 볼 수 있음. 

3. Vault 초기 세팅이 끝난 후

`./service-script/setup-pg-auth-vault-approle.sh && ./service-script/setup-pg-main-vault-approle.sh`

로 세팅하여 사용 가능.

