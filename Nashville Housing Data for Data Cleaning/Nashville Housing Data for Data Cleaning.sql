select * from dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------
-- Padronizando o campo 'sale date' em data

Select saleDateConverted, CONVERT(Date,SaleDate)
From dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- Se não funcionar

ALTER TABLE NashvilleHousing -- adicionar a coluna vazia
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------------------------------------------------

 /*Preencher o campo 'PropertyAddress' realizando o join com a mesma tabela
quando os 'parcelid' forem iguais e os 'uniqueID' forem distintos e 
não houver endereço em a.propertyAddess, uma coluna foi criada para receber o mesmo endereço que b.propertyaddress*/

SELECT a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ],b.ParcelID, b.PropertyAddress, ISNULL (a.propertyaddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.parcelid = b.parcelid
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

 /* Agora é realizado a atualização da tabela*/

UPDATE a
SET a.PropertyAddress = ISNULL (a.propertyaddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.parcelid = b.parcelid
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-----------------------------------------------------------------------------------------------------------------
 
 /*
Separando o endereço em colunas individuais (endereço, cidade, estado)
1° Substring: posição 1 até o indice vírgula
2° Substring: indice virgula até o final
 */

SELECT
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM
dbo.NashvilleHousing

 /*
Add a coluna PropertyAddressSplit na tabela
 */

ALTER TABLE NashvilleHousing 
Add PropertyAddressSplit Nvarchar(255);


Update NashvilleHousing
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1)

 /*
Add a coluna PropertyAddressCity na tabela
 */


ALTER TABLE NashvilleHousing 
Add PropertyAddressCity Nvarchar(255);


Update NashvilleHousing
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


---------------------------------------------------------------------------------------------------------------

 /*
Separando o endereço em colunas individuais (endereço, cidade, estado)
Utilizando a função PARSENAME: Quebra a coluna por ponto
 */

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) as OwnerAddressState,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2) as OwnerAddressCity,
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) as OwnerAddressSplit
FROM dbo.NashvilleHousing

 /*
Add a coluna OwnerAddressState na tabela
 */

ALTER TABLE NashvilleHousing 
Add OwnerAddressState Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

 /*
Add a coluna OwnerAddressCity na tabela
 */

ALTER TABLE NashvilleHousing 
Add OwnerAddressCity Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

 /*
Add a coluna OwnerAddressSplit na tabela
 */

ALTER TABLE NashvilleHousing 
Add OwnerAddressSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

select * from dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------

-- Padronizando a coluna 'SoldAsVacant' (yes, no)

-- Verificando o problema
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as contagem
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY contagem


-- Substituindo Valores

SELECT SoldAsVacant,
(CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END) as modificado	
FROM dbo.NashvilleHousing

-- Atualizando na planilha

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

---------------------------------------------------------------------------------------------------------------

-- Removendo Duplicatas
 /*
A função "ROW_NUMBER()" atribui um número sequencial para cada linha dentro de uma partição definida, baseada nas colunas especificadas no "PARTITION BY". As partições são grupos de linhas com valores iguais nas colunas selecionadas.

No código fornecido, a partição é definida pelas colunas ParcelID, PropertyAddress, SalePrice, SaleDate e LegalReference. A ordem dos valores dentro da partição é definida pela coluna UniqueID, especificada no "ORDER BY".

Dessa forma, a nova coluna "row_num" irá conter um número sequencial para cada linha dentro de cada partição, começando em 1 e aumentando em 1 para cada linha subsequente. Isso permite identificar facilmente linhas duplicadas na tabela, ou determinar a ordem em que as linhas foram inseridas ou atualizadas.
 */

With RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from dbo.NashvilleHousing
)
SELECT * 
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress

-- Deletando as linhas

With RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from dbo.NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE row_num >1


---------------------------------------------------------------------------------------------------------------

--Deletando colunas que não estão sendo utilizadas

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate