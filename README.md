# Todoey

## 🎯 Todoey는?
**🗣️ Code-base 기반 UIKit과 Core Data Framework 이용한 할 일 목록 App 입니다.**
> ↪ Branch: [develop_Realm](https://github.com/jphong1005/Todoey/tree/develop_Realm)은 **Realm Database**를 사용하였습니다. 

<br>

## 🚀 주요 기능
- 할 일 목록과 카테고리를 CRUD 할 수 있습니다.
- Search Bar를 이용하여 할 일 리스트를 검색할 수 있습니다.

<br>

## 🛠️ 기술스택
- Swift (version 5.9.2)
- Xcode (version 15.1)
- UIKit Framework
- Core Data Framework
- MVC Design Pattern
- SOLID Principle
- Dependency Injection & Inversion of Control
- [CocoaPods] SwipeCellKit
- [CocoaPods] ChameleonFramework

<br>

## ✅ 실행
```
# Clone this project

$ git clone <https://github.com/jphong1005/Todoey.git>
```

<img src="https://github.com/jphong1005/Todoey/assets/52193695/878a2072-6ec1-4416-84a3-5ca140b05d77">

> ⚠️ .xcworkspace를 열어 TARGETS 안에 있는 모든 Pods의 Minimum Deployments를 17.0으로 설정해주세요. 😇

<br>

## 📱 결과
|<img src="https://github.com/jphong1005/Todoey/assets/52193695/344f526d-6ff4-4fec-91c3-a1801b9f14f2"></img>|<img src="https://github.com/jphong1005/Todoey/assets/52193695/6c0f16c1-8752-4896-9125-befad0adf06f"></img>|<img src="https://github.com/jphong1005/Todoey/assets/52193695/986eefe7-b34b-400c-ad19-3c13ebdd1f98"></img>|<img src="https://github.com/jphong1005/Todoey/assets/52193695/2286af8f-e24c-4ad8-8a46-c25a2c5a35a7"></img>|<img src="https://github.com/jphong1005/Todoey/assets/52193695/0783cb39-dbae-421c-b512-c34b824c9140"></img>|
|:---:|:---:|:---:|:---:|:---:|
|`CREATE`|`READ`|`UPDATE`|`SEARCH`|`DELETE`|

<br>

## ⌨️ SQL QUERY Statement

|<b>`[CREATE] Category 테이블`</b>|<b>`[CREATE] Item 테이블`</b>|
|:-:|:-:|
|<img width="100%" src="https://github.com/jphong1005/Todoey/assets/52193695/a365b8ab-f62d-4b78-84dd-73a2a8aff5f8">|<img width="100%" src="https://github.com/jphong1005/Todoey/assets/52193695/f3e45f0e-4489-4c3e-9b3f-87d516fc57f1">|

|<b>`[UPDATE] Item 테이블`</b>|<b>`[DELETE] Category 테이블`</b>|
|:-:|:-:|
|<img width="100%" src="https://github.com/jphong1005/Todoey/assets/52193695/cc051291-c223-45e8-92aa-e9a19681cd99">|<img width="100%" src="https://github.com/jphong1005/Todoey/assets/52193695/66052182-a4da-4f48-84fa-6e6936062f7f">|

<br>

## 🧐 개선사항
- MVC to MVVM 마이그레이션과 데이터 및 UI 바인딩 예정 (with RxSwift/RxCocoa) → 현재 진행중
- SOLID 원칙, Dependency Injection 및 Inversion of Control 보완

<br>

## 🎉 성과
- **SOLID 원칙**과 **Dependency Injection 및 Inversion of Control**을 적용함으로써 유지보수와 가독성 및 이해도 향상
- **객체 관계 매핑(Object-relational mapping; 이하 ORM) Core Data Framework**의 이해
- 데이터 CRUD의 상태를 SQL Query를 활용하여 확인
