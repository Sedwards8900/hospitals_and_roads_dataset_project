# Spatial Databases Final Research Project

The final project presented in this open source repository is meant to provide individuals with a way to easily download a dataset that can be used to perform spatial queries to perform route analysis from any point within the State of Georgia and its closest hospital or emergency healthcare facility.

The project is also available on github at https://github.com/Sedwards8900/hospitals_and_roads_dataset_project


## Github Cloning/Download of project

If you wish to download this project to your computer via git, you may do by following the next steps:

1. Create folder in your vscode or software that has connection to github setup for your account

3. Git clone the contents of the repository:

    # git clone git@github.com:Sedwards8900/hospitals_and_roads_dataset_project.git

All files within the repository will be transfered to your machine for further steps below to be executed. Otherwise, insert given files directly to desired folder after download from iCollege site.


## Libraries

To run this assignment successfully you will need the following libraries/modules:
- notebook
- shapely
- pandas
- geopandas
- sqlalchemy
- dotenv
- numpy


## Steps to run project's python code

### Install requirements

Before executing the main file on your terminal, you must install the requirement libraries listed above as follow:

In your terminal, run one of the following commands:

## pip install -r requirements.txt

or 

## pip3 install -r requirements.txt

The command you will be able to execute depends on the pip version installed in your machine.

### Run code within jupyter file 'data_loader.ipynb'

To execute the code within the data_loader.ipynb file, you must click on the arrow button on the left side of each code block from the top all the way to the bottom.

Please note, if you do not have jupyter notebook, please follow the tutorial on how to install it on your IDE from the following website if the requirements.txt file does not install it for you:

https://jupyter.org/install


If for any reason the code is not running or errors are issued due to connectivity to the database of your choice, please make sure to restart the kernel within your IDE.

## Steps to run SQL code

The files "graph_and_integration.sql" and "shortest_path.sql" are meant to be used to integrate and provide brief examples of how the data can be accessed and used for emergency preparedness. You will need to copy and paste all code into a software to handle Postgres databases such as pgadmin or run it from your IDE if you have access to the server of your preference already set up for it. The contents in each sql files are:


### "graph_and_integration.sql"
It contains code for altering the needed data tables as well as creating tables for establishing integration between hospitals and roads and creating the graph network for roads.

### "shortest_path.sql"
It contains code for performing spatial queries to locate hospitals closest to a given geocoded location, then outputing the route created through a package called pg routing. Instructions on how to install each package.