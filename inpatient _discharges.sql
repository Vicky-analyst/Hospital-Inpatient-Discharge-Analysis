USE hospital_inpatient;

# EXPLORATORY DATA ANALYSIS
DESCRIBE inpatient_discharges;

-- checking for duplicate
SELECT `index`,
       COUNT(*) AS Duplicates
FROM inpatient_discharges
GROUP BY `index`
HAVING Duplicates > 1;

# DATA CLEANING
-- Cleaning Duplicate
ALTER TABLE inpatient_discharges
ADD COLUMN ID INT auto_increment primary KEY;
WITH duplicates AS (
					SELECT ID,
							row_number() OVER(PARTITION BY `index` ORDER BY ID) AS Dup
                    FROM inpatient_discharges
                    )
DELETE FROM inpatient_discharges
WHERE ID IN (SELECT ID FROM duplicates WHERE Dup > 1);    

ALTER TABLE inpatient_discharges
DROP COLUMN ID;

# DATA ANALYSIS

-- What is the most common diagnosis among age group
WITH diagnosis AS (SELECT `Age Group`,
					       `CCS Diagnosis Description` AS `Most Common Dignosis`,
				   RANK() OVER (partition by `Age Group` ORDER BY COUNT(`CCS Diagnosis Description`) DESC) AS Top_diagnosis
				   FROM inpatient_discharges
				   WHERE Gender = "F"
				   GROUP BY `Age Group`, `CCS Diagnosis Description`
				   )
SELECT  `Age Group`,
        `Most Common Dignosis`
FROM diagnosis
WHERE Top_diagnosis = 1;

 
      
-- What is the most common Diagnosis and its association with APR Illness Severity
WITH Common_procs AS(SELECT `CCS Diagnosis Description` AS `Common Diagnosis`,
							ROW_NUMBER() OVER (ORDER BY COUNT(`CCS Diagnosis Description`) DESC) AS Top_procs,
							CONCAT(ROUND(SUM(CASE 
											   WHEN `APR Severity of Illness Description` = "Minor" THEN 1
											 END) / COUNT(*) * 100,2), "%") AS "Minor",
							CONCAT(ROUND(SUM(CASE 
												  WHEN `APR Severity of Illness Description` = "Moderate" THEN 1
											  END) / COUNT(*) * 100,2), "%") AS "Moderate",
							CONCAT(ROUND(SUM(CASE 
											    WHEN `APR Severity of Illness Description` = "Major" THEN 1
											 END) / COUNT(*) * 100,2), "%") AS "Major",
							CONCAT(ROUND(SUM(CASE 
											    WHEN `APR Severity of Illness Description` = "Extreme" THEN 1
											 END) / COUNT(*) * 100,2), "%") AS "Extreme"
				FROM inpatient_discharges
				WHERE Gender = "F"
				GROUP BY `CCS Diagnosis Description`
				)
SELECT `Common Diagnosis`,
       Minor,
       Moderate,
       Major,
       Extreme
FROM Common_procs
LIMIT 5;

-- What is the distribution of admission type and how are they associated with Emeergency Department Indicator
SELECT `Type of Admission`,
       `Admission Distribution`,
       `EDI-Yes`,
       `EDI-No`
FROM(
		SELECT `Type of Admission`,
			   COUNT(`Type of Admission`) AS `Admission Distribution`,
			   CONCAT(ROUND(SUM(CASE 
									 WHEN `Emergency Department Indicator` = "Y" THEN 1
								END) / COUNT(*) *100, 2), "%") AS `EDI-Yes`,
			   CONCAT(ROUND(SUM(CASE 
									 WHEN `Emergency Department Indicator` = "N" THEN 1
								END) / COUNT(*) *100, 2), "%") AS `EDI-No`
		FROM inpatient_discharges
		WHERE Gender = "F"
		GROUP BY `Type of Admission` 
		ORDER BY `Admission Distribution` DESC) Add_Disto;

-- What is the distribution of APR Risk of Motality Among races
SELECT Race,
	   CONCAT(ROUND(SUM(CASE 
							WHEN `APR Risk of Mortality` = "Minor" THEN 1
					   END) / COUNT(*) *100,2), "%") AS `APR Motality Minor`,
		CONCAT(ROUND(SUM(CASE 
							WHEN `APR Risk of Mortality` = "Moderate" THEN 1
					   END) / COUNT(*) *100,2), "%") AS `APR Motality Moderate`,
		CONCAT(ROUND(SUM(CASE 
							WHEN `APR Risk of Mortality` = "Major" THEN 1
					   END) / COUNT(*) *100,2), "%") AS `APR Motality Major`,
		CONCAT(ROUND(SUM(CASE 
							WHEN `APR Risk of Mortality` = "Extreme" THEN 1
					   END) / COUNT(*) *100,2), "%") AS `APR Motality Extreme`
		
FROM inpatient_discharges
WHERE Gender = "F"
GROUP BY Race;

-- What patient race are mostly linked to Extreme APR Motality risk and what is the percentage of emergency admission type to the race and how does  it affect lenght of stay on average
WITH Total_Emerg_Cases AS( SELECT SUM(CASE WHEN `Type of Admission` =  'Emergency' THEN 1
									   END)AS Total_Emerg
							FROM inpatient_discharges
                            WHERE Gender = "F"),
	 Total_Extreme_TOA AS( SELECT SUM(CASE
										WHEN `APR Risk of Mortality` = "Extreme" THEN 1
										END) AS Total_extreme
							FROM inpatient_discharges
                            WHERE Gender = "F"),
	 Queries AS( SELECT RACE,
						CONCAT(ROUND(SUM(CASE
											WHEN `Type of Admission` = 'Emergency' THEN 1
											END)/ (SELECT Total_Emerg FROM Total_Emerg_Cases) * 100,2), "%") AS `% OF Emergency Case`,
						CONCAT(ROUND(SUM(CASE
											WHEN `APR Risk of Mortality` = "Extreme" THEN 1
											END) / (SELECT Total_extreme FROM Total_Extreme_TOA)* 100,2), "%") AS `% Of Extreme Motality Rate`,
						ROUND(AVG(`Length of Stay`)) `AVG Length of Stay`
						FROM inpatient_discharges
                        WHERE Gender = "F"
                        GROUP BY Race)        
SELECT *
FROM Queries;

-- What is the top 10 county by total charges
SELECT `Hospital County`,
		CASE
			WHEN Total_Charges > 1000000000 THEN CONCAT(ROUND(Total_Charges/1000000000,2), "B") 
            ELSE CONCAT(ROUND(Total_Charges/1000000,2), "M")
		END AS Total_Charges
FROM(
		SELECT `Hospital County`,
			   SUM(`Total Charges`) AS Total_Charges
		FROM inpatient_discharges
		WHERE Gender = "F"
		GROUP BY `Hospital County`
		ORDER BY Total_Charges DESC) Top_County
LIMIT 10;

-- Identify the top 10 procedures contributing the most to total hospital charges .
SELECT `Top Procedures`,
		CASE
			WHEN Total_Charges > 1000000000 THEN CONCAT(ROUND(Total_Charges/1000000000,2), "B") 
            ELSE CONCAT(ROUND(Total_Charges/1000000,2), "M")
		END AS Total_Charges
FROM(
		SELECT `CCS Procedure Description` AS `Top Procedures`,
			   SUM(`Total Charges`) AS Total_Charges
		FROM inpatient_discharges
		WHERE Gender = "F"
		GROUP BY `CCS Procedure Description`
		ORDER BY Total_Charges DESC) Top_Procedure
LIMIT 10;

-- Compare total charges by payment source to identify which payer types generate the most billing volume which is above avg
WITH charge AS(SELECT `Source of Payment 1` AS `Source of Payment`,
					   SUM(`Total Charges`) AS `Total Charges`
				FROM inpatient_discharges
				WHERE Gender = "F"
				GROUP BY `Source of Payment 1`
				ORDER BY `Total Charges` DESC) 
SELECT `Source of Payment`,
		CASE
			WHEN `Total Charges` >= 1000000000 THEN CONCAT(ROUND(`Total Charges`/1000000000,2), "B") 
            ELSE CONCAT(ROUND(`Total Charges`/1000000,2), "M")
		END AS `Total Charges`,
	    `Avg Charge`,
        CASE 
			WHEN `Total Charges` >= `Avg Charge` THEN "Above Avg"
            ELSE "Below Avg"
		END AS `Avg Metric`
FROM(
		SELECT  `Source of Payment`,
			    `Total Charges`,
               ROUND(AVG(`Total Charges`) OVER(),2) AS `Avg Charge`
		FROM charge) AS charges_disto
		

