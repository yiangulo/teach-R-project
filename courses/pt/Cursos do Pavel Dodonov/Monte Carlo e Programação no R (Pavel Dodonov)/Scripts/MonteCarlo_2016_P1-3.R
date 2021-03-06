#######Estat�stica Monte Carlo e fundamentos de programa��o em R para ecologia
###### Pavel Dodonov - pdodonov@gmail.com
##### Laborat�rio de Ecologia Aplicada � Conserva��o - UESC / Ilh�us-BA e Laborat�rio de Ecologia Espacial e Conserva��o - Unesp / Rio Claro - SP

#### Aula 1 - Introdu��o ao R e a algoritmos

### O R � uma linguagem de programa��o orientada a objetos. Sendo assim, sempre trabalhamos com objetos.
### Objetos armazenam informa��es, como n�meros, texto etc
### Podemos inserir objetos a partir de arquivos de dados - vamos abrir a partir de uma planilha de texto
### Primeiro, estabelecemos um diret�rio inicial
setwd("F:/Profissional/Ensino/Disciplinas/MonteCarlo_PPGECB_UESC_2016/Planilhas/")
### Para rodar uma linha: apertem CTRL R no Windows ou CMD ENTER no Mac
### Linhas que come�am com # n�o s�o executadas (usadas para coment�rios)
### setwd: Set Working Directory
### Coloquem o caminho para a pasta (diret�rio) onde voc�s salvaram os arquivos.
### Cuidado! Usem sempre a barra / e n�o a barra \
### Ou usem \\
setwd("F:\\Profissional\\Ensino\\Disciplinas\\MonteCarlo_PPGECB_UESC_2016\\Planilhas\\")
### Para verificar se deu certo, usamos o comando getwd()
getwd()
### getwd: Get Working Directory
### Agora vamos abrir um arquivo
dados.bruto <- read.table("Pteridium_01.txt", header=T, sep="\t")
### header=T significa que os dados cont�m uma coluna de cabe�alho
### sep="\t" significa que as colunas s�o separadas por tabula��es
### Vamos ver como � a estrutura destes dados:
str(dados.bruto)
### Este comando mostra como � a nossa planilha.
### Mostra que temos vari�veis de dois tipos:
##### int: n�meros inteiros
##### num: n�meros inteiros ou decimais
### Podemos tamb�m examinar ele inteiro (j� que s�o apenas 40 valores)
dados.bruto
### Reparem que temos duas �reas, ou seja, coletas feitas em duas �reas distintas
### O nosso interesse aqui est� em comparar entre essas duas �reas
### Vamos agora examinar uma �nica coluna - Altura
dados.bruto$Altura
### E vamos criar um objeto para ela
altura <- dados.bruto$Altura
altura
### Examinando a estrutura dele:
str(altura)
### Este objeto � um vetor num�rico. Um vetor � uma sequ�ncia de n�meros (ou texto).
### Vamos agora separar ele pelas duas �reas diferentes
area <- dados.bruto$Area
which(area==1)
### Isso nos mostra quais as linhas correspondentes � �rea 1
linhas.area1 <- which(area==1)
linhas.area2 <- which(area==2)
linhas.area1
linhas.area2
altura.area1 <- altura[linhas.area1]
altura.area2 <- altura[linhas.area2]
### Os colchetes [ ] s�o usados para indexa��o
### Ou seja, para escolher apenas uma parte de um dado objeto.
str(altura.area1)
str(altura.area2)
### Reparem que cada objeto agora tem 20 observa��es.
### Ser�o as m�dias das duas observa��es diferentes?
mean(altura.area1)
mean(altura.area2)
### Parece que sim! Mas vamos olhar a dispers�o dos dados...
### Vamos fazer isso em um jitter plot...
plot(altura ~ area)
### Dif�cil de observar por causa da valores sobrepostos.
area.jitter <- jitter(area)
plot(altura~area.jitter)
### A fun��o jitter adiciona ru�do aleat�rio a uma vari�vel.
### Parece que as alturas na �rea 1 s�o de fato maiores que na �rea 2.
#### Se quiserem, podemos salvar as figuras usando o comando png
png(filename="P1_Fig1_Altura.png", width=20, height=20, unit="cm", res=300)
plot(altura~area.jitter)
dev.off()
### Na fun��o png(), definimos o nome do arquivo (filename),
#### a altura (height) e largura (width) da imagem, as unidades
#### em que a altura e a largura s�o medidas (unit="cm"), e a
#### resolu��o da imagem em DPI (res=300).

###### Exerc�cio 1#######
#### Fa�am os mesmos gr�ficos para as outras vari�veis


####### Aula 2 - Permuta��es simples #########
setwd("F:/Profissional/Ensino/Disciplinas/MonteCarlo_PPGECB_UESC_2016/Planilhas/")
getwd()
dados.orig <- read.table("Pteridium_01.txt", header=T, sep="\t")
altura <- dados.orig$Altura
areas <- dados.orig$Area
altura.area1 <- altura[areas==1]
altura.area2 <- altura[areas==2]
### A parte sep="\t" mostra que as colunas s�o separadas por tabula��es
### Para verificar se deu certo, usamos o comando getwd()
#### Tendo feito os outros gr�ficos, vamos ver se de fato h� diferen�a na m�dia
### O teste param�trico seria um teste t de Student:
t.test(altura.area1, altura.area2)
### Um P-valor altamente significativo
### Ser� que os dados s�o normais?
hist(altura.area1, breaks=10)
### Vixxxx....
hist(altura.area2, breaks=10)
### T�, quem sabe...
### Um outro teste gr�fico � o grafico quantil-quantil
### Compara os quantis dos dados com uma distribui��o normal
qqnorm(altura.area1)
qqline(altura.area1)
### N�o est� na linha, ou seja, provavelmente os dados n�o v�m de uma distribui��o normal.
#### Ent�o como seria um teste por permuta��es?
### Nosso interesse: diferen�a entre as m�dias.
### Qual a diferen�a real?
altura.med.area1 <- mean(altura.area1)
altura.med.area2 <- mean(altura.area2)
altura.dif <- altura.med.area1 - altura.med.area2
altura.dif
### O que seria esperado sob o modelo nulo?
### Hip�tese nula - as amostras v�m da mesma popula��o
altura.juntas <- c(altura.area1, altura.area2)
str(altura.juntas)
### Um vetor com 40 n�meros
### Na hip�tese nula, tiramos 20 indiv�duos aleatoriamente para cada �rea
### O jeito mais pr�tica de fazer isso: reordenar os valores.
altura.juntas.rand <- sample(altura.juntas)
### O comando sample aleatoriza valores
### Uso o termo rand para valores aleat�rios ("random")
### Agora - vamos pegar 20 primeiros para �rea 1 e os outros para �rea 2
altura.area1.rand <- altura.juntas.rand[1:20]
altura.area2.rand <- altura.juntas.rand[21:40]
### Calcular a diferen�a
altura.med.area1.rand <- mean(altura.area1.rand)
altura.med.area2.rand <- mean(altura.area2.rand)
altura.dif.rand <- altura.med.area1.rand - altura.med.area2.rand
altura.dif.rand
### Provavelmente ser� bem menor do que o valor real observado...
### Vamos repetir isso algumas vezes e anotar os valores...
### Basta selecionar as linhas e rodar de novo
### A partir de qual linha?
### Da linha altura.juntas.rand, que tem o comando sample
### Vamos fazer um vetor em R que armazene estes valores
altura.dif.rand <- c() #Preencher com valores obtidos
### Mas n�o queremos fazer isso manualmente, ent�o vamos automatizar!
altura.dif.rand <- numeric()
### Aqui criamos um vetor vazio para armazenar os valores
### numeric porque � um vetor que ser� preenchido com n�meros
### E vamos fazer um loop para o R rodar isso de uma vez
for (i in 1:5000) {
	altura.juntas.rand <- sample(altura.juntas)
	altura.area1.rand <- altura.juntas.rand[1:20]
	altura.area2.rand <- altura.juntas.rand[21:40]
	altura.med.area1.rand <- mean(altura.area1.rand)
	altura.med.area2.rand <- mean(altura.area2.rand)
	altura.dif.rand[i] <- altura.med.area1.rand - altura.med.area2.rand
}
### Basicamente, colocamos dentro do loop o c�digo que deve ser repetido
### E colocamos o �ndice [i] para armazenar um valor por vez no vetor
#### Para ver o seu funcionamento - definar i <- 1, i <- 2 por vez
### e rodem o conte�do do loop (sem os colchetes.
str(altura.dif.rand)
### Agora temos um vetor com 5000 valores de altura sob a hip�tese nula
hist(altura.dif.rand)
abline(v=altura.dif, col="red")
### O valor real est� t�o longe que nem aparece no gr�fico
### Vamos fazer um histograma incluindo o valor real...
hist(c(altura.dif.rand, altura.dif))
abline(v=altura.dif, col="red")
### Um diferen�a altamente significativa, ao que parece!
### Agora para calcular signific�ncia
### Com que frequ�ncia valores maiores ou iguais ao observado s�o simulados?
teste.uni <- altura.dif.rand >= altura.dif
str(teste.uni)
sum(teste.uni)
signif.uni <- sum(teste.uni) / 5000
signif.uni
teste.bi <- abs(altura.dif.rand) >= abs(altura.dif)
str(teste.bi)
signif.bi <- sum(teste.bi) / 5000
signif.bi
### Mas... isso t� estranho
### N�o faz sentido falar que o resultado observado tem uma probabilidade zero de ocorrer
### Afinal, ele foi observado!
### Portanto, incluimos o resultado observado nas permuta��es:
altura.dif.rand <- numeric()
altura.dif.rand[1] <- altura.dif #O primeiro valor � o valor observado
for (i in 2:5000) { # Simulamos a partir do segundo valor. Ou seja, 4999 permuta��es.
	altura.juntas.rand <- sample(altura.juntas)
	altura.area1.rand <- altura.juntas.rand[1:20]
	altura.area2.rand <- altura.juntas.rand[21:40]
	altura.med.area1.rand <- mean(altura.area1.rand)
	altura.med.area2.rand <- mean(altura.area2.rand)
	altura.dif.rand[i] <- altura.med.area1.rand - altura.med.area2.rand
}
hist(altura.dif.rand)
abline(v=altura.dif, col="red")
### Com que frequ�ncia valores maiores ou iguais ao observado s�o simulados?
teste.uni <- altura.dif.rand >= altura.dif
str(teste.uni)
sum(teste.uni)
signif.uni <- sum(teste.uni) / 5000
signif.uni
teste.bi <- abs(altura.dif.rand) >= abs(altura.dif)
str(teste.bi)
signif.bi <- sum(teste.bi) / 5000
signif.bi
### Signific�ncia de 0.0002, que � a menor poss�vel com 5000 permuta��es

### Exerc�cio 2: fa�am esta an�lise para as outras vari�veis :-)

### E se os dados fossem pareados?
### Eles n�o s�o, mas vamos ent�o adicionar uma estrutura de depend�ncia para eles
length(altura.area1)
altura.par.area1 <- altura.area1 + 1:length(altura.area1)
altura.par.area2 <- altura.area2 + 1:length(altura.area2)
### Adicionamos o mesmo n�mero �s alturas de ambos os grupos
alturas.par.juntas <- c(altura.par.area1, altura.par.area2)
areas.jitter <- jitter(areas)
plot(alturas.par.juntas ~ areas.jitter)
### Mas adicionando linhas...
segments(x0=areas.jitter[1:20], x1=areas.jitter[21:40], y0=altura.par.area1, y1=altura.par.area2)
t.test(altura.par.area1, altura.par.area2) # Sem diferen�a significativa
t.test(altura.par.area1, altura.par.area2, paired=T) # Com diferen�a significativa
### A hip�tese nula: as diferen�as podem ser positivas ou negativas
altura.par.difs <- altura.par.area1 - altura.par.area2
altura.par.difs
altura.par.difs.med <- mean(altura.par.difs)
altura.par.difs.med
### Vamos criar um vetor aleat�rio de diferen�as positivas ou negativas
difs.rand <- sample(c(-1,1), 40, replace=T)
### Assim criamos 40 valores aleat�rios, cada um dos quais pode ser igual a -1 ou +1
### Agora simulamos as diferen�as na hip�tese nula
altura.par.difs.rand <- altura.par.difs * difs.rand
### Cada diferen�a pode permanecer como est� ou mudar de sinal
### Calculamos a m�dia
altura.par.difs.med.rand <- mean(altura.par.difs.rand)
altura.par.difs.med.rand
### Uma diferen�a (provavelmente) bem menor do que esperado!

### Exerc�cio 3: transformem isso em um loop para calcular signific�ncia!


### Aula P3 - An�lise de regress�o

###Vamos abrir outra planilha
setwd("F:/Profissional/Ensino/Disciplinas/MonteCarlo_PPGECB_UESC_2016/Planilhas/")
dados.regr <- read.table("Alometria.txt", header=T, sep="\t")
str(dados.regr)
### Temos plantas que foram queimadas (Fogo==1) e que n�o o foram (Fogo==0)
### H: altura (Height); DAS: di�metro (Di�metro � Altura do Solo)
### Vamos primeiro trabalhar com um �nico grupo
dados.regr.1 <- subset(dados.regr, Fogo==1)
str(dados.regr.1)
### Ser� que h� rela��o entre di�metro e altura?
dados.regr.1.H <- dados.regr.1$H
dados.regr.1.DAS <- dados.regr.1$DAS
### Fa�amos um gr�fico
plot(dados.regr.1.H ~ dados.regr.1.DAS)
### E a regress�o?
mod.lin.1 <- lm(dados.regr.1.H ~ dados.regr.1.DAS)
abline(mod.lin.1)
### No caso, o modelo linear n�o � o melhor mas vamos fingir que �
mod.lin.1
summary(mod.lin.1)
### O comando summary nos d� a signific�ncia da rela��o
### Mas vamos calcul�-la por aleatoriza��es
### Para isso, precisamos da inclina��o da reta
mod.lin.1
### Ela est� no objeto... S� precisa ser extra�da
str(mod.lin.1)
mod.lin.1$coefficients
### Est� aqui!
str(mod.lin.1$coefficients)
### � um vetor com dois n�meros
mod.lin.1$coefficients[2]
### � disso que precisamos!
mod.lin.1.incl <- mod.lin.1$coefficients[2]
mod.lin.1.incl
### Se quisermos manter apenas o valor:
mod.lin.1.incl <- as.numeric(mod.lin.1.incl)
mod.lin.1.incl
### Agora para fazer as aleatoriza��es...
incl.rand <- numeric(5000)
incl.rand[1] <- mod.lin.1.incl
### Hip�tese nula: n�o h� rela��o entre as duas vari�veis
for(i in 2:5000) {
	mod.lin.1.rand <- lm(dados.regr.1.H ~ sample(dados.regr.1.DAS))
	incl.rand[i] <- mod.lin.1.rand$coefficients[2]
	print(i) # para mostrar quantas itera��es j� foram
}
hist(incl.rand, breaks=50)
abline(v=mod.lin.1.incl)
### Altamente significativa...
signif.bi <- sum(abs(incl.rand) >= abs(mod.lin.1.incl)) / 5000
signif.bi

### Exerc�cio 4: Fa�am uma an�lise por permuta��o para testar se a inclina��o � a mesma
#### independentemente do valor da vari�vel Fogo (ou seja, se tem diferen�a quando Fogo==1
#### e quando Fogo==0).