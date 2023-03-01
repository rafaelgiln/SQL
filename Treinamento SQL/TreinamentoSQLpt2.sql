-- Self Join
-- TODOS OS CLIENTES QUE MORAM NA MESMA REGIAO
SELECT TOP 10 *
FROM Customers

SELECT A.ContactName, A.Region, A.CustomerID, B.ContactName, B.Region, B.CustomerID
FROM Customers A, Customers B
WHERE A.Region = B.Region
ORDER BY A.ContactName DESC

-- ENCONTRAR (NOME E DATA DE CONTRATAÇÃO DE TODOS OS FUNCIONARIOS QUE FORAM CONTRATADOS NO MESMO ANO.

SELECT A.FirstName, a.HireDate, b.FirstName, b.HireDate
FROM Employees A, Employees B
WHERE DATEPART(year, a.HireDate) = DATEPART(year, b.HireDate)
ORDER BY A.FirstName ASC

-- NA TABELA DETALHE DO PEDIDO [ORDER DETAILS] QUAIS PRODUTOS TEM O MESMO % DE DESCONTO

SELECT A.ProductID, A.Discount,B.ProductID, B.Discount
FROM [Order Details] A, [Order Details] B
WHERE A.Discount = B.Discount



