dir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir) #Establecer el directorio de trabajo

datos = read.csv("data.csv", header = TRUE)
dim(datos)
head(datos) #muestra las primeras 6 filas

#Diagnosis se coloca a 0 y 1 porque la regresión calcula la probabilidad
#en el rango de 0 a 1 (benigno a maligno)
datos$Diagnosis[datos$Diagnosis == "MALIGNO"] = 1
datos$Diagnosis[datos$Diagnosis == "BENIGNO"] = 0

dim(datos)
head(datos)
filas = dim(datos)[1]

#---1 Dividir el dataset en 2 conjuntos
set.seed(0) #Fijar el generador aleatorio
indexes = sample(x=1:filas, size= as.integer(filas*0.66))
train = datos[indexes, ]
head(train)
#Datos de validación
test = datos[-indexes, ] #Seleccionar registros que no estén en indexes
head(test)

#readline("Presione cualquier tecla para continuar...")

#2 construir modelo (red neuronal)
library(neuralnet)
f = as.formula("Diagnosis ~.")
model = neuralnet(f,data=train,hidden=c(21,7,3),linear.output=T)
plot(model, rep = "best")

#3 Validar contra los datos de prueba
predictions <- compute(model,test[,1:9])
predictions = as.vector(predictions$net.result)
as.vector(predictions[1:20])

#3 Calcular la precisión del modelo
predictions <- ifelse(predictions > 0.5,1,0)
as.vector(predictions[1:20])
test$Diagnosis[1:20]
t = table( #Construir tabla de frecuencias
  x = predictions,   #predicciones hechas por el modelo
  y = test$Diagnosis   #clase contenida en los datos de prueba
)
t

#accuracy = sum(diag(t))/dim(test)[1]
#paste('Accuracy: ',accuracy*100,"%", sep = "")
save(model, file = "RedTumor.RData")






