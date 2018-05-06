# Introduction
Yeah? Really still a work in progress

# 1. Database
We use flyway for database Migrations and JOOQ as an ORM

## 1.1 Migrations: 

Migrations should be placed in:
 ```
 database/schema/src/main/resources/db/migration/
 ```
 The naming convention to follow for new migrations is 
 ``V + CCYYMMDD + _ + HHMM + __ + a short description``
 
 Example: V20180131_1234__An_Example_Migration.sql
 
 We use this naming convention to help prevent any out of order migrations from developers working at the same time.
 Highly doubt this will ever be an issue, but the naming convention will prevent this from happening within reason.
 
 ## 1.2 Commands:
 
 Migrate:
 
 ``sbt schema/flywayMigrate``
 
 Clean:
 
 ``sbt schema/flywayClean``
 
 Migrate and JOOQ Codegen:
 
  ``sbt database/jooqCodegen``