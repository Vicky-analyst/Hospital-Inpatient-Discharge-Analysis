# Hospital Inpatient Discharge Analysis

## 📌 Project OverView

This project analyzes inpatient discharge records to understand how medical conditions, procedures, demographics, insurance patterns, and county characteristics shape real hospital utilization. The dataset captures a wide range of clinical events, allowing the analysis to map which diagnoses dominate specific age groups, and which Procedures carry severe illness levels that drive higher medical resource use. Each finding is connected to biological, clinical, or social explanations.
The investigation focuses on identifying consistent clinical signals within the data and examining why they appear. Age-specific patterns, gender-linked procedures, severity clusters, obstetric-related encounters, chronic disease trends, and behavioral health cases are interpreted through established medical, social, and epidemiological reasoning. Insurance type and county structure are also evaluated to understand how coverage and population distribution influence hospital activity and total charges.

## Data Source

The dataset for this project was sourced from Kaggle, providing a comprehensive collection of inpatient discharge records suitable for clinical and demographic analysis. 
![click Here](https://www.kaggle.com/datasets/bhautikmangukiya12/hospital-inpatient-discharges-dataset)

## Problem Statement

- What diagnosis is most prevalent among patients within the selected age group and what are the most common procedures?
- What is the most common Diagnosis and its association with APR Illness Severity?
- What is the distribution of admission type and how are they associated with Emergency Department Indicator
- What is the distribution of APR (All Patient Refined) Risk of Mortality across different racial groups?
- Which patient race is most associated with Extreme APR Risk of Mortality, what percentage of their admissions are classified as emergency visits, and how does this relate to their average length of stay?
- Which ten counties account for the highest total hospital charges?
- Compare total charges by payment source to identify which payer types generate the most billing volume which is above avg

## Tools

The following tools were utilized to collect, manage, analyze, and visualize hospital data, enabling a comprehensive exploration of clinical and demographic patterns as well as healthcare utilization trends:
- MySQL : Employed for Storaging, cleaning, exploring and manipulation of large scale Hospital Inpatient Discharges Dataset. Enambling accurate indept insight connected to biological, clinical, and social explanations.
- Power BI : Employed to create interactive visualizations and dashboards, allowing clear exploration of hospitalization patterns, trends, and cost distribution across different age groups, prodecures, Diagnonsis and counties.

## Skills Demonstrated

- Exploratory Data Analysis 
- Data Cleaning
- Data Analysis
- Visualization
  - tooltip
  - DAX
  - Quick Measure
  - filters
  - Page Navigation

### Data Cleaning
The dataset used for this project was largely well-structured and complete, requiring minimal preprocessing. The primary data quality issue identified was the presence of duplicate records, which could distort counts, risk assessments, and cost analyses if left unaddressed. To ensure the integrity of the analysis, all duplicate rows were systematically identified and removed. No other modifications were necessary, preserving the integrity of the original hospital discharge data for analysis.

```sql
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
```
### Data Analysis And Insight

- **Liveborn** are The most common diagnosis for age 0-17 for both male and female with differs procedures having an apr severity of over 81%, in males it common procedure is _**circumsition**_ (is a surgical procedure involving removal of the foreskin from the penis) while females is _**no procedure**_ due to the fact that female genital multiation is not a legal medical procedures. In Males **substance RLTD** most prevelant in 18-29 years old with procedure as alcohol / drug rehab /detox. this insight revels its social and public health impliaction reasons:
  **Developmental Psychology + Risk-Taking Behavior:**
  	Ages 18–29 fall into a period called “emerging adulthood. This is a stage where the brain’s prefrontal cortex (impulse control, judgment) is still developing. Risky behavior, identity exploration, peer pressure, and social experimentation are at their peak.
  
  **Party Culture, and Early Independence:**
   College/University life often introduces Alcohol and drug exposure due to Less parental control, also in a way of coping with strees and challenges Many begin using substances socially, which can progress into misuse or addiction.
  
while in females **Obstetric perineal and vulvar trauma** are common at that age with _**current obstetric laceration**_ as the most common procedure this common diagnosis around this specific age group is primarily due to the higher likelihood of first-time vaginal deliveries within this age group. Primiparous women (those experiencing their first childbirth) face an increased risk of perineal lacerations, especially during vaginal deliveries. In males alcohol related disorder are the most common diagnosis in age 30-49 this diagnostic possible factor can be as a result of _**Coping Mechanism**_  Males around that age often associated with ● Career pressure, ● Financial strain, ● Relationship problems/divorce, ● Parenthood stress, ● Mental health issues (depression, anxiety). Many turn to alcohol as a coping mechanism, leading to functional alcoholism or chronic binge patterns. while in females around the same age group and mostly associated with **Other complicated bith** with it common procedeure to be _**Cesarean section**_ two of the major resons foe this disgnostic prevelance aroung this age group is due to:
**Advanced Maternal Age:** Women of advanced maternal age are more likely to experience complications such as labor dystocia, fetal distress, and other obstetric issues, leading to a higher likelihood of C-sections .
**Medical Conditions:** Older maternal age is associated with increased risks of conditions like gestational diabetes and hypertension, which can necessitate C-sections.
**Coronary Atherosclerosis** is most prevalent in males aged 50-69, this is the is the buildup of plaque (cholesterol, fatty substances, etc.) inside the coronary arteries, which supply blood to the heart. As these arteries narrow or become blocked, it leads to reduced blood flow, causing symptoms like chest pain (angina) or even heart attacks. and it most common procedure is _**Percutaneous Transluminal Coronary Angioplasty (PTCA)**_ Males around this age 50–69 group are more likely to Experience higher levels of LDL cholesterol ("bad cholesterol") due to a higher incidence of smoking and alcohol consumption, which accelerate plaque formation. also hormones like Testosterone also plays a role in cholesterol metabolism, and higher levels of testosterone in men are linked to increased plaque buildup in arteries. 
In females around same age group (50-69) are commoonly diagnose with **Osteoarthritis (OA)** is a degenerative joint disease that becomes increasingly prevalent with age with it most common procedure to be arthroplasty (joint replacement surgery). the prevelancy of this diagnosis among women is due to:
**Hormonal Changes:** The onset of menopause leads to a decline in estrogen levels, which has been associated with increased joint degeneration. Studies suggest that women experience a dramatic increase in OA prevalence around the time of menopause. 
PMC
**Anatomical and Biomechanical Differences:** Women generally have wider pelvises and different knee alignments compared to men, which can affect joint mechanics and increase the risk of OA.


