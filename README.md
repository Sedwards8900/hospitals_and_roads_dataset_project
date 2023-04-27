# Spatial Databases Final Research Project

The final project presented in this open source repository is meant to provide individuals with a way to easily download a dataset that can be used to perform spatial queries to perform route analysis from any point within the State of Georgia and its closest hospital or emergency healthcare facility.

The project is also available on github at https://github.com/Sedwards8900/hospitals_and_roads_dataset_project


## Github Cloning/Download of project

If you wish to download this project to your computer via git, you may do by following the next steps:

1. Create folder in your vscode or software that has connection to github setup for your account

2. Initiate a git repository by entering the following on terminal:

    # git init

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


## Steps to run project code

### Install requirements

Before executing the main file on your terminal, you must install the requirement libraries listed above as follow:

In your terminal, run one of the following commands:

# pip install -r requirements.txt

or 

# pip3 install -r requirements.txt

The command you will be able to execute depends on the pip version installed in your machine.

### Run code within jupyter file 'osm.ipynb'

To execute the code within the osm.ipynb file, you must click on the arrow button on the left side of each code block in the order it was provided.

If for any reason the code is not running or errors are issued due to connectivity to the database of your choice, please make sure to restart the kernel within your code environment.