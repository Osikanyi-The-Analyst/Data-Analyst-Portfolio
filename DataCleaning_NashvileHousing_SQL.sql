/*

Cleaning Data in SQL Queries

*/
--Selecting the data to take a glance at it
Select *
From [ProjectPortfolio].[dbo].[NashvilleHousing];

------------------------------------------------------------------------------------------------------------------------------------------------------
--Standardizing the sale Date Format

Select SaleDate
From [ProjectPortfolio].[dbo].[NashvilleHousing];

---Creating new column for converted SaleDate
Alter Table NashvilleHousing
Add SaleDateConverted Date;

--Updating the data with values of converted SaleDate
Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

--Glancing at the updated column
Select SaleDateConverted
From [ProjectPortfolio].[dbo].[NashvilleHousing];

-----------------------------------------------------------------------------------------------------------------------------------------------
---Property Adress data correction

Select *
From [ProjectPortfolio].[dbo].[NashvilleHousing]
where PropertyAddress is Null

---about 30 Null values in property id column

Select *
From [ProjectPortfolio].[dbo].[NashvilleHousing]
where PropertyAddress is Null
Order by ParcelID;

---Property Id for unique ParcelID seems to be the same hence we will populate from there 

Select Nash.ParcelID, Nash.PropertyAddress, Vile.ParcelID, Vile.PropertyAddress, ISNULL(Nash.PropertyAddress, Vile.PropertyAddress)
From [ProjectPortfolio].[dbo].[NashvilleHousing] Nash
JOIN [ProjectPortfolio].[dbo].[NashvilleHousing] Vile
	ON Nash.ParcelID = Vile.ParcelID
	AND Nash.[UniqueID ] <> Vile.[UniqueID ]
Where Nash.PropertyAddress is null;

---Update Statement

UPDATE Nash
Set PropertyAddress = ISNULL(Nash.PropertyAddress, Vile.PropertyAddress)
From [ProjectPortfolio].[dbo].[NashvilleHousing] Nash
JOIN [ProjectPortfolio].[dbo].[NashvilleHousing] Vile
	ON Nash.ParcelID = Vile.ParcelID
	AND Nash.[UniqueID ] <> Vile.[UniqueID ]
Where Nash.PropertyAddress is null;

-----------------------------------------------------------------------------------------------------------------------------------------------------

---Breaking out Property Adress into three separate columns (Address, city, State)
Select PropertyAddress
From [ProjectPortfolio].[dbo].[NashvilleHousing]

--Slecting the data to check code before updating
--Used indexing to split the data before and after the comma's 
Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From [ProjectPortfolio].[dbo].[NashvilleHousing]

--creating the new column for the PropertySplitAdress
Alter Table NashvilleHousing
Add PropertySplitAdress nvarchar(255);

--Update Statement for PropertySplitAdress i.e. values before comma
Update NashvilleHousing
SET PropertySplitAdress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

--creating the new column for the PropertySplitCity
Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

---Update Statement for PropertySplitCity i.e. values after comma
Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress));


-------------------------------------------------------------------------------------------------------------------
----- Cleaning the Owner Address Column which Seems to have 3 data in there i.e. Adress, City and State

---- Selecting data to check code before updating
-----Use parsename which separate charaters in different columns based on the delimeter "."
----Hence I replaced ',' with a '.' abd paced it to parsename.

Select 
PARSENAME (Replace(OwnerAddress, ',', '.'), 3), 
PARSENAME (Replace(OwnerAddress, ',', '.'), 2),
PARSENAME (Replace(OwnerAddress, ',', '.'), 1)
From [ProjectPortfolio].[dbo].[NashvilleHousing]

--creating the new column for the OwnerSplitAdress
Alter Table NashvilleHousing
Add OwnerSplitAdress nvarchar(255);

--Update Statement for OwnerSplitAdress
Update NashvilleHousing
SET OwnerSplitAdress = PARSENAME (Replace(OwnerAddress, ',', '.'), 3);

--creating the new column for the OwnerSplitCity
Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

--Update Statement for OwnerSplitCity
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',', '.'), 2);


--creating the new column for the OwnerSplitState
Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

--Update Statement for OwnerSplitState
Update NashvilleHousing
SET OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',', '.'), 1);


Select *
From [ProjectPortfolio].[dbo].[NashvilleHousing];


--------------------------------------------------------------------------------------------------------------------------
-- Changing the Sold as Vacnat Field  
----Chnaging Y and N to Yes and No

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant) 
From [ProjectPortfolio].[dbo].[NashvilleHousing]
Group by SoldAsVacant;

---Selecting data to check Code before updating
Select SoldAsVacant,
Case
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From [ProjectPortfolio].[dbo].[NashvilleHousing];

---Updating the SoldASVacant column

Update NashvilleHousing
Set SoldAsVacant =
Case
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;

----Can Verify that Sold as Vacant Column has only two distinct values now
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant) 
From [ProjectPortfolio].[dbo].[NashvilleHousing]
Group by SoldAsVacant;


-------------------------------------------------------------------------------------------------------------------------------------
-----Dealing with Duplicates in our dataset
-----Deleting Duplicate data just for a showcase
-----Instandard practice I won't advise you to delete data.

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
					) row_num

From [ProjectPortfolio].[dbo].[NashvilleHousing]
)
Delete  --(use Select * while --to verify if rows are deleted )
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress  --(uncomment the order by when checking to see if rows were deleted)

----------------------------------------------------------------------------------------------------------------------------------------

-- Deleting the columns we have modified and now won't be useful to us  

Select *
From [ProjectPortfolio].[dbo].[NashvilleHousing];


ALTER TABLE [ProjectPortfolio].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
