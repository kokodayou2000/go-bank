createdb:
	docker exec -it pg12 createdb --username=root --owner=root simple_bank
	
stop:
	docker stop pg12
start:
	docker start pg12
dropdb:
	docker exec -it pg12 dropdb simple_bank
postgres:
	docker run --name pg12 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
rm: stop	
	docker rm pg12	
migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

startAll: postgres start createdb migrateup

sqlc:
	docker run --rm -v "C:\Users\03062\Desktop\Code\workspace\project\golang\simplebank:/src" -w /src kjconroy/sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc
