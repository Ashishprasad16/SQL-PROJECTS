-- no of owners in each zipcode--
select count(*) as number_of_owners, zipcode from [owners] group by ZipCode order by number_of_owners desc

-- information about owners who lived either in grand rapids or in south fields--
select * from [owners] where  city in ('Grand Rapids','Southfield')

--information about owners whose first name contains n and surname has atleast 3 characters--
select * from [owners] where Name like '%n%' and Surname like '___%'

--information about pets and description of procedures performed on them--
select [pets].PetID,[pets].Name,[pets].Kind,[pets].Gender,[pets].Age,[ProceduresDetails].Description from [pets]
join [ProceduresHistory]  on [pets].PetID=[ProceduresHistory].PetID
join [ProceduresDetails] on [ProceduresHistory].ProcedureSubCode=[ProceduresDetails].ProcedureSubCode

--owners with more than 1 pet--
with number_of_pets as
(select count(*) no_of_pets,OwnerID from [pets] group by OwnerID)
select [owners].Name,[owners].Surname,[number_of_pets].no_of_pets from [number_of_pets]
join [pets] on [pets].OwnerID=[number_of_pets].OwnerID
join [owners] on [owners].OwnerID=[pets].OwnerID
where [number_of_pets].no_of_pets >1

--count of procedures performed on each pet who are dogs--
with number_of_procedures as 
(select count(*) as no_of_procedures,ProcedureType from [ProceduresDetails] group by ProcedureType)
select [pets].PetID,[pets].Name,[number_of_procedures].no_of_procedures from [number_of_procedures]
join [ProceduresHistory] on [ProceduresHistory].ProcedureType=[number_of_procedures].ProcedureType
join [pets] on [pets].PetID=[ProceduresHistory].PetID
where [pets].Kind='dog'

--sum of the price incurred on each pets procedure but only considering pet whose name starts with c--
with Total_price_table as 
(select sum(price) as total_price,proceduretype from [ProceduresDetails] group by ProcedureType)
select [pets].Name,[pets].Kind,[Total_price_table].total_price,[Total_price_table].ProcedureType  from [Total_price_table]
join [ProceduresDetails] on [ProceduresDetails].ProcedureType=[Total_price_table].ProcedureType
join [ProceduresHistory] on [ProceduresHistory].ProcedureType=[ProceduresDetails].ProcedureType
join [pets] on [pets].PetID=[ProceduresHistory].PetID
where not [pets].Name like 'c%' 
--group by [pets].Name,[pets].Kind,[Total_price_table].total_price,[Total_price_table].ProcedureType

-- average price incurred by each owner for their pets procedure--
with Average_price as 
(select avg(price) as avg_price,proceduretype from [ProceduresDetails] group by ProcedureType)
select [owners].Name as owners_name,[pets].Name as pets_name,[pets].Kind,[Average_price].avg_price from [Average_price]
join [ProceduresDetails] on [ProceduresDetails].ProcedureType=[Average_price].ProcedureType
join [ProceduresHistory] on [ProceduresHistory].ProcedureType=[ProceduresDetails].ProcedureType
join [pets] on [pets].PetID=[ProceduresHistory].PetID
join [owners] on [owners].OwnerID=[pets].OwnerID
group by [owners].Name,[pets].Name,[pets].Kind,[Average_price].avg_price

/*Pets whi have undergone procedure type = vaccination with subcode 3,4and 5 or procedure type = general surgeries with subcode
8,10,13,15,16*/
select [ProceduresHistory].PetID,[ProceduresHistory].ProcedureType,[ProceduresHistory].ProcedureSubCode from [pets]
join [ProceduresHistory] on [ProceduresHistory].PetID=[pets].PetID
where (([ProceduresHistory].ProcedureType='VACCINATIONS' and [ProceduresHistory].ProcedureSubCode in (3,4,5))
or ([ProceduresHistory].ProcedureType='GENERAL SURGERIES' and [ProceduresHistory].ProcedureSubCode in (8,10,13,15,16)))

--Top pets in terms of the fees paid for the procedures performed--
with Total_price_table as 
(select sum(price) as total_price,proceduretype from [ProceduresDetails] group by ProcedureType)
select top 10 [pets].Name,[pets].Kind,[Total_price_table].total_price,[Total_price_table].ProcedureType  from [Total_price_table]
join [ProceduresDetails] on [ProceduresDetails].ProcedureType=[Total_price_table].ProcedureType
join [ProceduresHistory] on [ProceduresHistory].ProcedureType=[ProceduresDetails].ProcedureType
join [pets] on [pets].PetID=[ProceduresHistory].PetID
-- group by [pets].Name,[pets].Kind,[Total_price_table].total_price,[Total_price_table].ProcedureType

 -- first and last date of procedure performed on each pet--
 with Date_table as
(select MIN(date) as first_date, MAX(date) as last_date,petid from [ProceduresHistory] group by PetID)
select [pets].Name,[Date_table].first_date,[Date_table].last_date  from [ProceduresHistory]
join [Date_table] on [Date_table].PetID=[ProceduresHistory].PetID
join [pets] on [pets].PetID=[Date_table].PetID

-- owners name whose petname doesnot begin with d to s--
select owners.Name,owners.Surname,pets.Name as pet_name,pets.PetID from owners
join pets on pets.OwnerID=owners.OwnerID
where not pets.Name like '[d-s]%'

--Cummulative sum of total procedures performed for each pet at a monthly basis--
with monthly_table as (
select petid,MONTH(date) as month_ from ProceduresHistory)
select [pets].Name,ProceduresHistory.PetID,sum([ProceduresDetails].Price) as total_price,[monthly_table].month_ from [monthly_table]
join [ProceduresHistory] on [ProceduresHistory].PetID=[monthly_table].PetID
join [ProceduresDetails] on [ProceduresDetails].ProcedureSubCode=[ProceduresHistory].ProcedureSubCode
join [pets] on [pets].PetID=[ProceduresHistory].PetID
group by [monthly_table].month_,[ProceduresHistory].PetID,[pets].Name
order by total_price desc








 
