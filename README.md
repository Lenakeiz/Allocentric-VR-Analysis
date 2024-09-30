Continuous update of the egocentric view via self-motion is beneficial to allocentric representations in ageing
======

![Figure 1](https://github.com/Lenakeiz/GenerativeLinearAngularModelPathIntegration/blob/main/Images/Fig1a.png)

## Description 
This repository contains the full dataset and the scripts for generating the analysis and the figures from _"Continuous update of the egocentric view via self-motion is beneficial to allocentric representations in ageing
"_[^1]  

## Installation
Clone the repository anywhere in your machine using `git clone`. 
Open the folder in Matlab by making sure to add folders and subfolders to the path.

## Package dependency
Developed using Matlab R2024a.

Requires the following MATLAB toolboxes:

- [Statistics and machine learning](https://uk.mathworks.com/products/statistics.html)

## Usage
Start by running `QSVR_LoadData.m` to load, preprocess, and extract key metrics from the data.
To generate figures from the paper, run the scripts in the **Analysis** folder. 
Script names relate to the analyses they perform rather than to the specific figuer numbers. 
preprocess and extract the metrcis of interest.
Plots will be displayed in MATLAB but will also be saved in the **Output** folder.
SPSS results can be found in the **SPSS_Output** folder.

For details on preprocessing and analysis, refer to the Methods section of the paper.

---
[^1]: Andrea Castegnaro, Alex Dior, Neil Burgess, John King