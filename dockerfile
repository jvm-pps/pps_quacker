# Primera fase: Instalar dependencias
FROM python:3.11-slim AS builder

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo de requerimientos
COPY requirements.txt .

# Instalar las dependencias
RUN python -m venv venv && \
    venv/bin/pip install --no-cache-dir -r requirements.txt

# Segunda fase: Ejecutar la aplicación
FROM python:3.11-slim AS runner

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos necesarios desde la fase de construcción
COPY --from=builder /app/venv venv
COPY . .

# Copia los archivos necesarios para la aplicación
COPY dao/ ./dao
COPY model/ ./model
COPY service/ ./service
COPY static/ ./static
COPY templates/ ./templates
COPY app.py .
COPY mongo.py .

# Exponer el puerto en el que se ejecuta la aplicación
EXPOSE 5000

# Establecer las variables de entorno necesarias
ENV MONGO_IP="mongo"
ENV MONGO_PORT="27017"

# Comando para ejecutar la aplicación
CMD ["venv/bin/python", "app.py", "--host=0.0.0.0"]
