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
  
	while in females **Obstetric perineal and vulvar trauma** are common at that age with _**current obstetric laceration**_ as the most common procedure this common diagnosis around this specific age group is primarily due to the higher likelihood of first-time vaginal deliveries within this age group. Primiparous women (those experiencing their first childbirth) face an increased risk of perineal lacerations, especially during vaginal deliveries. In males **Alcohol related disorder** are the most common diagnosis in age 30-49 this diagnostic possible factor can be as a result of _**Coping Mechanism**_  Males around that age often associated with ● Career pressure, ● Financial strain, ● Relationship problems/divorce, ● Parenthood stress, ● Mental health issues (depression, anxiety). Many turn to alcohol as a coping mechanism, leading to functional alcoholism or chronic binge patterns. 
	while in females around the same age group and mostly associated with **Other complicated birth** with it common procedeure to be _**Cesarean section**_ two of the major resons foe this disgnostic prevelance aroung this age group is due to:
	**Advanced Maternal Age:** Women of advanced maternal age are more likely to experience complications such as labor dystocia, fetal distress, and other obstetric issues, leading to a higher likelihood of C-sections.
	
	**Medical Conditions:** Older maternal age is associated with increased risks of conditions like gestational diabetes and hypertension, which can necessitate C-sections.
	
	**Coronary Atherosclerosis** is most prevalent in males aged 50-69, this is the is the buildup of plaque (cholesterol, fatty substances, etc.) inside the coronary arteries, which supply blood to the heart. As these arteries narrow or become blocked, it leads to reduced blood flow, causing symptoms like chest pain (angina) or even heart attacks. and it most common procedure is _**Percutaneous Transluminal Coronary Angioplasty (PTCA)**_ Males around this age 50–69 group are more likely to Experience higher levels of LDL cholesterol ("bad cholesterol") due to a higher incidence of smoking and alcohol consumption, which accelerate plaque formation. also hormones like Testosterone also plays a role in cholesterol metabolism, and higher levels of testosterone in men are linked to increased plaque buildup in arteries. 
	In females around same age group (50-69) are commoonly diagnose with **Osteoarthritis (OA)** is a degenerative joint disease that becomes increasingly prevalent with age with it most common procedure to be arthroplasty (joint replacement surgery). the prevelancy of this diagnosis among women is due to:
	
	**Hormonal Changes:** The onset of menopause leads to a decline in estrogen levels, which has been associated with increased joint degeneration. Studies suggest that women experience a dramatic increase in OA prevalence around the time of menopause. 

	**Anatomical and Biomechanical Differences:** Women generally have wider pelvises and different knee alignments compared to men, which can affect joint mechanics and increase the risk of OA.

- **The most common diagnosis in Female are**:
	- **Liveborn** : this diagnosis that commonly affect both male and female is the top most common diagnosis in female, with it procedure as no procedure is has an APR Severity of 81% minor this is due to the fact its a non surgrical operation and very likely associated with extreme case of about 0.70%
   - **Mood Disorder**: This is the second most common diagnosis in females it has the highest moderate APR Severity case of 59.42% and minor cases of 34.61%
   -  **Other complicated birth**: showing prevelancy in age 30-49 Other complicated birth is the 3rd most common diagnosis in females despite it complicated surgrical 		  procedures it has an APR Minor cases of 59.10% and moderate case of 33.72% with a very extreme cases of 0.57%
   -  **Septicemia** : The forth most common diagnosis in females and the only diagnosis with a relatively high extreme APR Severity of 45.36% and also major cases of 36.63% 	  this disease is a serious and potentially life-threatening condition that occurs when the body's response to an infection causes widespread inflammation. This can lead 	  to organ failure, tissue damage, and even death if not treated promptly. it is mostly common among women due to:
      	**Higher Rates of Urinary Tract Infections in Females** -> Women are more prone to UTIs due to anatomical reasons. UTIs can progress to urosepsis, a serious form of 		sepsis, especially in elderly or immunocompromised patients.
      
        **Post-Surgical Infections** -> Females undergoing procedures like C-sections, hysterectomies, or other gynecological surgeries are at risk of developing 					postoperative infections that can lead to sepsis
   - **Osteoarthritis (OA)**: Common among women within the age 50-69 is the fifth most common diagnosis among female despite its prevelancy within 50-69 age group is has a moderate APR Severity risk of 54.81% and the lowest extreme cases of 0.43%.
     
- **The most common diagnosis in Male are**:
	- **Liveborn** : this is the top most common diagnosis in male, with it procedure as Circumcision is has an APR Severity of 79.08% minor this is due to it less several 	  surgrical operation it has the lowest extreme risk case of about 0.89%
   - **Mood Disorder**: This is the second most common diagnosis in males just like females it has the highest moderate APR Severity case of 58.31% and and a relatively low 	 extreme risk cases of 1.06%
   - **Coronary Atherosclerosis**: This is the most prevelant disgnosis for males around age 50-69 is the thrid most common diagnosis among males despite rthe severity of 		 the disease it a very Moderate APR Severity risk of 40.45% and a very low extreme case of 2.78%
   - **Congestive Heart Failure.**: Closly related to Coronary Atherosclerosis It is a chronic condition where the heart is unable to pump blood effectively, leading to a 		 buildup of fluid in the body it is the forth most common disgnosis in males it has the highest Major APR Severity risk case of 47.78% and the hihest extreme cases in 		 males of 10.74% this is due to it seveal health complication
   - **Alcohol related disorder**: The most prevelant diagnosis among age 30-49 is the fifth most common diagnosis in males is has a very moderate APR Severity risk case of 	 53.06% this severity is no brainer because it is mainly a social issue than clinical and due to its common procedure is detox this common  diagnosis as a relatively 		 lowextreme case of 1.28%


- **Emergency** type of Admission is the Highest admission type of over **48K (56%)** medical cases as expected, it has the highest Emergency Department Indicator of **91.0%**  followed by **Trauma** which is the lowest type of admision but second highest EDI of over **82.0%** in both gender. **Newborn** admission type is the third most common **(24.9%)** and the most lowest EDI of about **0.05%** this distribution is followed by **Elective** admission type of about **1.95%** which is the second most common admission type **(7.29%)**
- **The White Race** has the most extreme APR Motality risk due to its risk, they make up about 72% emergency cases and an average length of stay of 6. **The Black Race on the other hand has a relatively high APR Motality Risk of about 62.0% which makes up over 13% of emergency case which the **Other Race** Makes up the highest APR Minor Motality risk of about 68.0% which makes up the lowest emergency cases of about 12% in both genders.
- Nassau, Suffolk, Westchester and Bronx are the top 4 above average among top 10 hospital county by total charge. thery generate the highest total charges due to these reasons
  	- **Population Size & Urbanization**
  	  The top 10 county are located at the urban and sub urban areas of the united state this account for more hospiatal visit. More people = more hospital visits = more 		  total charges. eg.Bronx has a high population density, leading to more ER visits, inpatient admissions, and chronic disease management.
  	  
    - **Type and Size of Hospitals**
      These counties host large teaching hospitals and specialty centers, such as:
      - Montefiore Medical Center (Bronx)
      - Northwell Health hospitals (Nassau/Suffolk)
      - Westchester Medical Center
      Teaching hospitals tend to charge more due to complex care and high-level specialists.

    - **Prevalence of Chronic Illness**
      Counties like the Bronx have higher rates of diabetes, hypertension, asthma, and heart disease, increasing hospital admissions and costs.
