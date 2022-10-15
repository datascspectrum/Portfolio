/*
Cleaning Data in SQL Query
*/


Select *
from [Portfolio Project].dbo.NashvilleHousing



------------------------------------------------------------------------------------------------------------------------------------------

/*
Standardize Date Format
*/


Select SaleDate, CONVERT(Date, SaleDate)
from [Portfolio Project].dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SalesDate Date;

Update NashvilleHousing
SET SalesDate = CONVERT(Date, SaleDate)

Select SalesDate
from [Portfolio Project].dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data


Select *
from [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into individual columns (Address, City, State)


Select PropertyAddress
from [Portfolio Project]..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from [Portfolio Project]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
from [Portfolio Project]..NashvilleHousing


--Lets work with the ownerAddress

Select OwnerAddress
from [Portfolio Project]..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2), 
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
from [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Field

Select distinct(SoldAsVacant), COUNT(SoldasVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2 desc



Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	END
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	END


------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
from [Portfolio Project]..NashvilleHousing
)
Select *
from RowNumCTE
where row_num >1

--DELETE 
--from RowNumCTE
--where row_num>1



------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused columns

Select *
from [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN SaleDate