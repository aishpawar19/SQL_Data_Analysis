# Painting Data Project

This repository contains two essential components: `load_painting_data.py` and `sql_queries.sql`, designed for managing and interacting with a PostgreSQL database related to painting data. The purpose of this project is to streamline the process of loading, querying, and analyzing painting-related data, ensuring high efficiency and accuracy.

## Data source: https://data.world/atlas-query/paintings

## Project Overview

This project leverages Python and PostgreSQL to create a robust ETL (Extract, Transform, Load) process that facilitates the efficient management of painting data.

### Files in this Repository

- **load_painting_data.py**: A Python script that handles the connection to a PostgreSQL database using SQLAlchemy's `create_engine`. The script is responsible for loading painting data into the database, ensuring that the data is clean and well-structured for further analysis.

- **sql_queries.sql**: This file contains SQL queries designed to interact with the painting data stored in the PostgreSQL database. These queries can be used for data retrieval, manipulation, and analysis, making it easier to derive meaningful insights from the painting dataset.

### Prerequisites

Before running the scripts, ensure you have the following installed:

- Python 3.x
- PostgreSQL
- SQLAlchemy
- Pandas
- psycopg2-binary
