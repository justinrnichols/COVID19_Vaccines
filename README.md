## Preface

The ultimate goal of this database application is to gather the current vaccination allocation, case count, and population of each U.S. state/territory to develop observations and make conclusions about the COVID-19 vaccine distribution around the country. Note, we have included both U.S. states as well as territories, but we will refer to both as just ‘states’. The database gathers the number of allocated vaccines from the approved companies (Pfizer, Moderna, and Janssen) given to each state and compares it to the state’s population and total COVID-19 case count. The database shows trends surrounding how the number of cases as well as the population of the state influences the state-based vaccine allocation, distribution, and vaccinate rate. This dependence can be viewed within the database design. 

Due to the COVID-19 vaccine campaign being the largest of its kind in world history, the data, regulations, information, and logistics are fast changing. With this, we would like to bring attention to a few key changes that occurred in the last few weeks. From the start of the development of this database application in early April 2021, many things have changed. The primary one being that the Johnson and Johnson Janssen vaccine has been indefinitely suspended due to health concerns and abnormal side effects. Although these new developments are significant, information is currently still scarce surrounding how this will change the overall vaccine distribution. Therefore, we have made the decision to use data obtained from the start of April (when we started on this project), which does not include these recent developments.

The data used within this database application comes from as recent as the first week of April 2021. The vaccine data acquired comes from https://www.data.gov/, the population statistics come from https://www.census.gov/, and the case count numbers come from https://www.cdc.gov/. We are using the relational database application MySQL on the MariaDB server to make our schemas.

Our group wanted to pick a topic that was not only relevant but also had a multitude of data to gather and obtain results from. COVID-19 was an obvious choice for us, considering how much it has impacted the country in the last year. This database gathers COVID-19 data unbiasedly and makes connections within the data in a factual manner.


# Documentation

Review the final report to understand the objective of this database application, view the database entities and corresponding attributes, constraints, and assumptions. Also, in the report is the database design including the ER diagram and relational model. The report subsequently details what information is returned for each query.


## How to Use the Database Application

1. Download the COVID19_Vaccines.zip file locally to your computer.
2. Run the queries on the MariaDB relational database.
3. If you do not have MariaDB on your computer, you can download it here for free (open-source, GNU General Public License): https://mariadb.com/downloads/
4. Follow the MariaDb instructions to successfully access the database.
5. Execute the create_tables_and_queries.sql file in MariaDB.
