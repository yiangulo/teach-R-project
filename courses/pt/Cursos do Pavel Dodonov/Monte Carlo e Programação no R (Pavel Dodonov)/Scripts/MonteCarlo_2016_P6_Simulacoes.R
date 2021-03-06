### Fundamentos de estat�stica Monte Carlo e de programa��o em R para ecologia
### Pavel Dodonov - pdodonov@gmail.com
### PPGECB - UESC - Ilh�us-BA

### Aula pr�tica P6
### Simulando dados

### Esta aula ser� diferente [vem com a gente]
###### [Algu�m entendeu a refer�ncia?]
### N�o iremos trabalhar com dados reais, e sim simular nossos dados
### Isso pode ser usado e.g. para testar se sua an�lise funciona.
### Existem algumas distribui��es facilmente simuladas pelo R
sim.unif <- runif(50)
sim.unif
hist(sim.unif)
### Esta � a distribui��o uniforme 0-1.
#### Cada valor tem a mesma probabilidade de ser gerado.
sim.unif <- runif(50, 0, 100)
hist(sim.unif)
### Mesma coisa, mas agora varia de 0 a 100
### Argumentos: n�mero de elementos, valor m�nimo e m�ximo
sim.norm <- rnorm(50)
sim.norm
hist(sim.norm)
### Isto � uma distribui��o normal
sim.norm <- rnorm(50, mean=5, sd=2)
hist(sim.norm)
### Podemos definir a m�dia e o desvio padr�o
sim.pois <- rpois (50)
### Distribui��o de Poisson, mas precisamos definir o par�metro lambda
sim.pois <- rpois(50, lambda=5)
hist(sim.pois)
mean(sim.pois)
var(sim.pois)
### O lambda � como se fosse a m�dia e a vari�ncia da distribui��o
sim.binom <- rbinom(50)
### Distribui��o binomial; faltam argumentos
?rbinom
sim.binom <- rbinom(50, size=10, prob=0.2)
hist(sim.binom)
### N�mero de sucessos em 10 tentativas, sendo que a
#### probabilidade de sucesso em cada � de 20%
### Tamb�m h� distribui��o exponencial, gamma etc...
#### Perguntem ao Google se haver necessidade!
### Podemos fazer isso para testar an�lises
### Ent�o vamos ver qu�o bem funciona nosso teste de regress�o
### E vamos definir uma semente (seed) para repetir o procedimento
set.seed(42)
### Vamos gerar uma vari�vel explanat�ria aleat�ria:
x.sim <- runif(40, 0, 100)
### Varia de 0 a 100 - poderia ser cobertura florestal.
### Vamos arredondar ela para uma casa decimal (mais realista)
x.sim <- round(x.sim, 1)
x.sim
### E vamos simular uma esp�cie cuja abund�ncia depende da cobertura
slope <- 0.1 # para cada 10% de floresta abund�ncia aumenta em 1
y.sim <- x.sim * slope
plot(y.sim ~ x.sim)
### Mas vamos tamb�m adicionar um ru�do (erro)
### Abund�ncia - erro pode seguir distribui��o de Poisson
y.sim <- x.sim * slope + rpois(40, 1)
plot(y.sim~x.sim)
y.sim <- x.sim * slope + rpois(40, 3)
plot(y.sim~x.sim)
### Parece realista, n�?
y.sim
### Temos valores decimais; vamos arredondar.
y.sim <- round(y.sim)
y.sim
plot(y.sim~x.sim)
### Vamos ver se o teste funciona...
lm.sim <- lm(y.sim~x.sim)
lm.sim
### Estou deliberadamente usando um modelo linear sendo que um GLM � apropriado
incl.sim <- lm.sim$coefficients[2]
Nrand <- 1000
### Vamos fazer o teste...
incl.sim.rand <- numeric(Nrand)
incl.sim.rand[1] <- incl.sim
for (i in 2:Nrand) {
	y.sim.rand <- sample(y.sim)
	lm.sim.rand <-lm(y.sim.rand~x.sim)
	incl.sim.rand[i] <- lm.sim.rand$coefficients[2]
	print(i)
}
hist(incl.sim.rand)
abline(v=incl.sim)
signif <- sum(abs(incl.sim.rand) >= abs(incl.sim))/Nrand
signif
### Mas e fiz�ssemos outras simula��es?...
### Vamos fazer um loop dentro do loop!
Nsim <- 100
Nrand <- 100 #para demorar menos
set.seed(42)
signif <- numeric(Nsim) #o que nos interessa � a signific�ncia
for (m in 1:Nsim) {
	x.sim <- round(runif(40,0,100),1)
	y.sim <- x.sim * slope + rpois(40, 3)
	y.sim <- round(y.sim)
	lm.sim <- lm(y.sim~x.sim)
	incl.sim <- lm.sim$coefficients[2]
	incl.sim.rand <- numeric(Nrand)
	incl.sim.rand[1] <- incl.sim
	for(i in 2:Nrand) {
		y.sim.rand <- sample(y.sim)
		lm.sim.rand <- lm(y.sim.rand~x.sim)
		incl.sim.rand[i] <- lm.sim.rand$coefficients[2]
		print(c(m,i))
	}
	signif[m] <- sum(abs(incl.sim.rand) >= abs(incl.sim))/Nrand
}
hist(signif)
### Todos os valores foram muito baixos - alto poder, mas talvez alto demais
### Mas ser� que este teste detectaria uma diferen�a nula que n�o existe?
### Exerc�cio: Repitam este procedimento, mas criando uma fun��o para a
#### an�lise de regress�o por aleatoriza��es 
#### e usando ela no lugar do segundo loop
### Exerc�cio 2: verifiquem se esta an�lise por regress�o detectaria uma
#### diferen�a significativa se a hip�tese nula for verdadeira
#### (ou seja, simulem dados n�o correlacionados e repitam o procedimento
##### Fazendo isso, estimamos a probabilidade de erro do tipo 1
##### (rejeitar uma hip�tese nula verdadeira).