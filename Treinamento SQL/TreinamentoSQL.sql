
SELECT DISTINCT LastName 
FROM Person.Person; /*Remove as duplicadas da coluna*/

SELECT DISTINCT Name
FROM Production.Product 
WHERE Weight >500 and Weight <=700;

SELECT * 
FROM HumanResources.Employee
WHERE MaritalStatus='M' and  SalariedFlag=1; /*Condição WHERE para filtrar resultados*/

SELECT BusinessEntityID 
FROM Person.Person
WHERE FirstName='Peter' and LastName='Krebs' /*Condição WHERE para filtrar resultados*/

SELECT * from person.EmailAddress
WHERE BusinessEntityID = 26 /*Condição WHERE para filtrar resultados*/

SELECT count(DISTINCT ProductID) 
from Production.Product /*conta a quantidade de linhas de uma determinada coluna*/

SELECT count(DISTINCT Size) 
from Production.Product /*conta a quantidade de linhas de uma determinada coluna*/

SELECT TOP 10 * 
from Person.Person /*retorna a quantidade de linhas de determinada coluna*/

SELECT TOP 10 * 
from production.Product
ORDER BY ListPrice desc /*coleta as 10 linhas e ordena de forma decrescente os valores conforme o listprice*/

SELECT TOP 4  Name, ProductNumber, ProductID
from production.Product
ORDER BY ProductID asc /*coleta as 4 linhas e ordena de forma crescente os valores conforme o ProductID*/

SELECT * FROM HumanResources.Employee
WHERE HireDate BETWEEN '2009/01/01' and '2010/01/01' /*Seleciona o intervalo especificado*/
ORDER BY HireDate

SELECT * FROM person.person
WHERE BusinessEntityID IN (2,7,13) /*função in boa para substituir a função or ou and*/

SELECT * FROM person.Person
WHERE FirstName like 'ba%' /* %=não importa o que vem depois ou antes _=não importa o caracter que vem depois*/

/*Exercícios*/

SELECT COUNT (ListPrice)  from production.Product
WHERE ListPrice >=1500;

SELECT COUNT(*) from person.Person
WHERE LastName like 'p%1';

SELECT count(distinct City) from person.Address;

SELECT distinct City  FROM person.address

SELECT * from Production.Product
WHERE ListPrice BETWEEN '500' AND '1000' and  Color IN ('Red')

SELECT count (ProductID) from production.product
WHERE Name like '%road%'

SELECT Sum(linetotal) as "soma" FROM Sales.SalesOrderDetail

/*GROUP BY - Divide o resultado da pesquisa em grupos*/

SELECT specialofferid, SUM(unitPrice) as "Soma"
FROM sales.SalesOrderDetail
GROUP BY SpecialOfferID

SELECT MiddleName, COUNT(MiddleName) as "Contagem"
FROM Person.Person
GROUP BY MiddleName

SELECT * FROM sales.SalesOrderDetail

SELECT ProductID, AVG(OrderQty) AS "Média da contagem"
FROM sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY ProductID asc

SELECT TOP 10 SalesOrderID, SUM(LineTotal) AS "Soma"
FROM sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SUM(LineTotal) desc

SELECT * 
FROM production.WorkOrder

SELECT productID, COUNT(productID) AS  "Contagem", AVG(OrderQty) AS  "Média"
FROM production.WorkOrder
GROUP BY ProductID

/*HAVING - utilizado em junção com o group BY para filtrar resultados  de um agrupamento*/

/*Diferença ente WHERE e group BY: group by é aplicado depois que os dados já foram agrupados
enquanto o WHERE é aplicado antes dos dados serem agrupados*/

SELECT firstname, COUNT(firstname)
FROM person.Person
GROUP BY FirstName
HAVING COUNT(firstname)>10

SELECT firstname, COUNT(firstname)
FROM person.Person
WHERE Title = 'Mr.'
GROUP BY FirstName
HAVING COUNT(firstname)>10

SELECT StateProvinceID, COUNT(StateProvinceID) AS "Contagem"
FROM Person.address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) >1000

SELECT * FROM sales.SalesOrderDetail

SELECT productid, AVG(LineTotal) AS Média
FROM sales.SalesOrderDetail
GROUP BY ProductID
HAVING NOT AVG(LineTotal) >1000000
ORDER BY AVG(LineTotal) desc


/*INNER JOIN*/

SELECT TOP 10 * 
FROM Production.Product

SELECT TOP 10 *
FROM Production.ProductSubcategory

SELECT pr.ListPrice, pr.Name, ps.name as categoria
FROM Production.Product PR
INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = PR.ProductSubcategoryID

SELECT TOP 10 *
FROM person.BusinessEntityAddress BA
INNER JOIN person.Address PA ON pa.AddressID = ba.AddressID

SELECT TOP 10 *
FROM person.PersonPhone

SELECT TOP 10 *
FROM person.PhoneNumberType

SELECT pp.BusinessEntityID, pn.Name, pp.PhoneNumberTypeID, pp.PhoneNumber
FROM person.PersonPhone PP
INNER JOIN person.PhoneNumberType PN ON PP.PhoneNumberTypeID = PN.PhoneNumberTypeID

SELECT TOP 10 *
FROM Person.StateProvince

SELECT TOP 10 *
FROM person.Address

SELECT pa.AddressID, pa.City, ps.StateProvinceID, ps.Name
FROM Person.StateProvince PS
INNER JOIN person.Address PA ON PS.StateProvinceID = pa.StateProvinceID

/*LEFT JOIN*/

-- Quero descobrir	quais pessoas possuem cartao de credito

SELECT *
FROM Person.Person PP
LEFT JOIN Sales.PersonCreditCard PC
ON PP.BusinessEntityID = PC.BusinessEntityID
-- INNER JOIN = 19118 linhas
-- LEFT JOIN = 19972 Linhas

SELECT *
FROM Person.Person PP
LEFT JOIN Sales.PersonCreditCard PC
ON PP.BusinessEntityID = PC.BusinessEntityID
WHERE PC.BusinessEntityID IS NULL

-- LEFT JOIN (ONLY TAB A) = 854 linhas

-- UNION: Combina 2 ou mais resultados de um select em um resultado apenas

SELECT FirstName, MiddleName, Title
from person.Person
WHERE Title ='Mr.'
UNION
SELECT FirstName, MiddleName,Title
from person.Person
WHERE MiddleName ='A.'

-- SUBQUERY
-- RELATORIO DE TODOS OS PRODUTOS CADASTRADOS QUETEM UM PREÇO DE VENDA MAIOR QUE A MEDIA

SELECT *
FROM Production.Product
WHERE ListPrice > (SELECT AVG(LISTPRICE) FROM Production.Product)

-- SABER O NOME DOS FUNCIONARIOS QUE TEM O CARGO DE  'DESIGN ENGINEER'

SELECT *
FROM Person.Person

SELECT *
FROM HumanResources.Employee

SELECT *
FROM person.Person
where BusinessEntityID IN
(SELECT BusinessEntityID FROM HumanResources.Employee
WHERE JobTitle ='Design Engineer')

SELECT *
FROM Person.PERSON PP
INNER JOIN HumanResources.Employee HE ON PP.BusinessEntityID = HE.BusinessEntityID
WHERE HE.JobTitle='Design Engineer'

SELECT *
FROM Person.PERSON PP
INNER JOIN HumanResources.Employee HE ON PP.BusinessEntityID = HE.BusinessEntityID
AND HE.JobTitle='Design Engineer'

-- encontre todos os endereços que estão no estado de alberta

SELECT TOP 10 *
FROM person.Address

SELECT TOP 10*
FROM person.StateProvince

SELECT *
FROM PERSON.Address
WHERE StateProvinceID IN (
SELECT StateProvinceID 
FROM PERSON.StateProvince
WHERE NAME ='ALBERTA')

SELECT *
FROM Person.Address PA
INNER JOIN person.StateProvince SP ON pa.StateProvinceID = sp.StateProvinceID AND SP.NAME='ALBERTA'

-- DATEPART

SELECT SalesOrderID, DATEPART(month, OrderDate) as Mes
FROM Sales.SalesOrderHeader

SELECT AVG(TotalDue) as Media, DATEPART(month, OrderDate) as Mes
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(month, OrderDate)
ORDER BY Mes

SELECT TOP 10 ProductID, DATEPART(mm, TransactionDate) as Mes, DATEPART(yy, TransactionDate) as Ano
FROM Production.TransactionHistory

-- OPERAÇÕES COM STRINGS
SELECT CONCAT(FirstName, ' ', LastName) -- CONCAT: Função concatenar 
FROM Person.Person

SELECT UPPER(FirstName), LOWER(LastName) -- UPPER: Deixar tudo Maiúsculo, LOWER: Deixar tudo minúsculo
FROM Person.Person

SELECT FirstName, LEN(FirstName) -- LEN: Tamanho da string
FROM Person.Person

SELECT FirstName, SUBSTRING(FirstName, 1, 3) -- SUBSTRING: Forcere os caracteres a partir de um indice
FROM Person.Person

SELECT ProductNumber, REPLACE(ProductNumber, '-', '#') as Modificdo -- REPLACE: substitui um caracter
FROM Production.Product

SELECT ProductNumber, value  -- STRING_SPLIT - Separa a string criando mais linhas
FROM Production.Product
CROSS APPLY STRING_SPLIT(ProductNumber, '-')

SELECT ModifiedDate, TRANSLATE(ModifiedDate, '-:.', '   ') Modificado -- TRANSLATE: Modificar mais de um caracter dentro da string
FROM Production.Location

-- FUNÇÕES MATEMATICAS

SELECT ROUND(Linetotal,2), LineTotal -- Round: Arredondamento
FROM Sales.SalesOrderDetail

SELECT SQRT(Linetotal) -- Raiz Quadrada: Arredondamento
FROM Sales.SalesOrderDetail

-- 