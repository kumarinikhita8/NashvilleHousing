Select *
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
order by ParcelID

--Converting Sale Date

 Select SaleDateConverted, CONVERT(date,SaleDate)
 FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

UPDATE NashvilleHousing
SET SaleDate=CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Replacing null with Property Address

Select PropertyAddress
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] a
 JOIN [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] a
 JOIN [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Seperating City in Property Address

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
order by ParcelID

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

Update [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

Update [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
order by ParcelID

--Seperating City and State in Owner address 

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

Update [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

Update [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

Update [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Changing Y and N to Yes and No respectively

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END
From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END


 --Removing Duplicates

 WITH RowNumCTE AS(
 Select *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
              SaleDate,
			  SalePrice,
			  LegalReference
			  ORDER BY
			    UniqueID
			    ) row_num

 From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
 )
 Select *
 From RowNumCTE
 Where row_num > 1
 Order by PropertyAddress

 --Removing unused Columns

 Select *
 From [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

 ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
 DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate
