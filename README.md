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
│   └── .env.sample (DB 환경변수 샘플 파일)
├── service-script (각 서비스 Vault 설정용 쉘 스크립트)
│   ├── .env.sample (PG 프로젝트 환경변수 샘플 파일)
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

<img width="678" alt="Screen Shot 2021-11-13 at 20 44 46" src="https://user-images.githubusercontent.com/22961251/141642520-490a30b5-9c50-4db0-aef7-949dc268099b.png">

접속은 해당 `VAULT_ROOT_TOKEN=s.EFQqF8P57d1QPAVwETJknG6c` 값으로 로그인하여 볼 수 있음. 

3. Vault 초기 세팅이 끝난 후

`./service-script/setup-pg-auth-vault-approle.sh && ./service-script/setup-pg-main-vault-approle.sh`

로 세팅하여 사용 가능.


## 세팅 확인

`http://localhost:8200/ui/vault/secrets/database/overview` 에 접속해서 아래와 같은 그림이 나오면 정상적으로 DB init까지 완료된 것으로 확인할 수 있다.

<img width="1383" alt="Screen Shot 2021-11-13 at 20 45 11" src="https://user-images.githubusercontent.com/22961251/141642529-42c05c65-2154-4dbf-9f43-b63a057b1ee1.png">


`./service-script/setup-pg-auth-vault-approle.sh && ./service-script/setup-pg-main-vault-approle.sh`

까지 끝난 케이스면


<img width="1382" alt="Screen Shot 2021-11-13 at 20 47 20" src="https://user-images.githubusercontent.com/22961251/141642587-a27cb8cc-3372-46da-a35f-3c1b4be8972d.png">


위와 같이 Role이 2개로 추가된 것을 볼 수 있다. 



