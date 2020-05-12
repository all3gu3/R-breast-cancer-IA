dir=dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

f <- read.csv("data2.csv", header = TRUE, sep = "," )
casos = as.data.frame(f)
dim(casos)
head(casos)

set.seed(0)

indexes=sample(x=1:569, size=376)
train = casos[indexes, ]
head(train)
test= casos[-indexes, ]
head(test)

casos$Diagnosis =as.character(casos$Diagnosis)
casos$Diagnosis[casos$Diagnosis == "M"] = "MALIGNO"
casos$Diagnosis[casos$Diagnosis == "B"] = "BENIGNO"
casos$Diagnosis = as.factor(casos$Diagnosis)



library(tree)
model = tree(
  formula =  Diagnosis ~ .,
  data=train
)
plot(model)
text(model)


####
predictions = predict(
  object = model,
  newdata = test, #nuevos registros no conocidos por el modelo
  type = "class"
)
t = table( #Construir tabla de frecuencias
  x = predictions,   #predicciones hechas por el modelo
  y = test$Diagnosis   #clase contenida en los datos de prueba
)
t
#predictions[1:6]
#test$Diagnosis[1:6]
#accuracy = sum(diag(t))/dim(test)[1]
#paste('Accuracy: ',accuracy*100,"%", sep = "")


save(model, file = "ArbolTumor.RData")

