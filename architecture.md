# Despliegue en la nube

Frontend:
- Sitio estático (carpeta `frontend`) alojado en Amazon S3.

Backend:
- API Gateway recibe las peticiones HTTP (integración proxy).
- AWS Lambda ejecuta `lowcost.cloud.LambdaHandler`, que usa el mismo `ApiRouter` y `ReservationService` que el servidor local.
- Los creadores (Factory Method) arman el boleto, los decoradores calculan el precio y `ReservationBuilder` valida y crea la reserva.

Flujo:

Navegador -> Frontend en S3 -> API Gateway -> Lambda -> Creadores + Decoradores + Builder -> Respuesta

## Cómo empaquetarlo

```powershell
javac -encoding UTF-8 -d out -sourcepath src src/lowcost/cloud/LambdaHandler.java
jar cf lowcost-lambda.jar -C out .
```

En la consola de AWS: crea una función con runtime Java 17 o 21, sube `lowcost-lambda.jar` y configura el handler `lowcost.cloud.LambdaHandler::handleRequest`.

El handler no necesita librerías de AWS: Lambda entrega el evento de API Gateway como `Map` y devuelve `statusCode`, `headers` y `body`. Atiende `GET /flights`, `GET /services`, `POST /quote` y `POST /reservations`, con o sin el prefijo `/api`.

Nota: los asientos reservados se guardan en memoria. En producción deberían guardarse en una base de datos como DynamoDB, porque cada instancia de Lambda tiene su propia memoria.
