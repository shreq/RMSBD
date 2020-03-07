FROM mcr.microsoft.com/mssql/server:2019-latest as build
ENV PATH="/opt/mssql/bin:/opt/mssql-tools/bin:${PATH}"
