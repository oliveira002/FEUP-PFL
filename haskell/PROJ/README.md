PFL 1st TP PROJ

A nossa representação interna passou por criar um novo data type chamado Term, que basicamente representa um monómio. Considerando então que um polinómio é um conjunto de monómios.

**data Term = Term Integer [String] [Integer] deriving(Show)**  

**Um "Term" é constituido por 3 parâmetros:**

* Exemplo : [Term 2 ["x"] [2],Term 2 ["x"] [1],Term 2 [] []] corresponde a **"2x^2 + 2x + 2"**

* O primeiro parâmetro é um Inteiro, que representa o coeficiente do monómio.

* O segundo parâmetro é uma Lista de String, uma vez que um monómio pode ter vàrias variaveis, decidimos representá-las atraves de uma Lista que está ordenada alfabeticamente. ex: ["x","y"]

* O terceiro parâmetro é uma Lista de Inteiros, como um monómio pode ter vàrias variaveis, cada variavel pode ter o seu próprio grau. O elemento do indice X desta lista corresponde ao grau da váriavel de indice X da lista de variaveis.


**Parse String para Polinómio:**

* Inicialmente retiramos todos os espaços da string.

* Damos split sempre que existe um sinal + ou -

* Percorrer a lista resultante do split, e associar o sinal ao elemento que está a seguir. (Vamos obter cada monómio numa Lista)

* Chamar as funções para transformar a string do monómio num Termo.

* Adicionar todos os termos a uma Lista (Polinómio)

**Inputs Aceites:**

* Qualquer tipo de input, com ou sem espaços entre os monómios, mas sem *. ex: "2x^2 + 2x-3y + 2yx^2"

**Funcionalidades:**

**Normalização:** A ideia que nós tivemos consiste em: percorrer cada termo do polinómio, encontrar os restantes termos com as mesmas vàriaveis e graus e somá-los todos.Com isso, retiramos todos esses termos do polínomio e continuamos a percorrer o polonimio recursivamente mas sem esses termos. No final de tudo, vamos obter um polinómio normalizado.

**Soma Polinómios:** A ideia é bastante semelhante à da normalização, a unica variante é que concatenamos ambos os polinómios num só e depois normalizamos esse novo polinómio.

**Derivação:** A ideia que nós tivemos consiste em percorrer o polinómio e derivar cada termo, e no final normalizar o polinómio obtido.
A derivação de um termo é feita da seguinte forma:  
* caso não tenha variáveis então a derivada é 0 
* se a variável que se quer derivar não estiver contida naquele polinómio então a derivada é 0
* se o grau da variável que se quer derivar for 1, então é preciso retirar a variável da lista
* caso contrário multiplica-se o coefieciente do monómio pelo grau da variável e reduz-se o expoente em uma unidade


**Multiplicação:** A ideia consiste em percorrer um polinómio e multiplicar cada monómio do mesmo pelo outro polinómio, e fazer o mesmo para os restantes monómios. No final de tudo, apenas normalizamos o resultado desta multiplicação.


**Parse Polinómio para String:**

* Percorrer o polinómio recursivamente, e dar output do coeficiente junto com as variaveis e os expoentes por ordem.


**Para executar as funções:**

* **Soma:** addInput "POLINOMIO1" "POLINOMIO2" 

* **Normalizar:** normalizeInput "POLINOMIO1"

* **Multiplicar:** multiInput "POLINOMIO1" "POLINOMIO2"

* **Derivar:** deriveInput "POLINOMIO" "VARIAVEL"
