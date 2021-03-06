@echo off
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& './scripts/win/check-go-version.ps1'"
if %ERRORLEVEL% GTR 0 exit /B 1

call ./scripts/win/install-protobuf.bat

FOR /F "tokens=* USEBACKQ" %%F IN (`go list -m -f {{.Path}} github.com/golang/protobuf`) DO (
SET protobuf_path=%%F
)
IF [%protobuf_path%]==[] (
  ECHO Failed to find path for github.com/golang/protobuf
  exit /B 1
)

ECHO installing protoc-gen-go...
go install %protobuf_path%/protoc-gen-go

FOR /F "tokens=* USEBACKQ" %%F IN (`go list -m -f {{.Path}} github.com/grpc-ecosystem/grpc-gateway`) DO (
SET grpc_gateway_path=%%F
)
IF [%grpc_gateway_path%]==[] (
  ECHO Failed to find path for github.com/grpc-ecosystem/grpc-gateway
  exit /B 1
)

ECHO installing protoc-gen-grpc-gateway...
go install %grpc_gateway_path%/protoc-gen-grpc-gateway
ECHO installing protoc-gen-swagger...
go install %grpc_gateway_path%/protoc-gen-swagger

