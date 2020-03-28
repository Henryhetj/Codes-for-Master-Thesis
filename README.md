total_network.xlsm: cover all the data involving in the simulation

 connection_matrix_full: the geographical distances between any two nodes in
the network via longitude and latitude. I made VBA module to generate the
distance automatically.

 failure_rate_full: probabilities of different risks. Some types of risks (e.g.,
natural disasters) are calculated based on the record from the Internet. For
the other types of risk whose record is limited or confidential, their failure
probabilities are based on our best estimation. For example, the failure
probabilities under management risks are estimated based on our experience
(it is assumed to be less than 0.4) and the size of the company (it is assumed
that that a larger organization has a lower risk).

 f_inf_matrix: The influence factor in the connection matrix reflects the degree
of influence between two nodes. Basic data were collected from experts who
have worked over 6 years at Global Supply Chain Department of Lenovo. I
made VBA module to extend the basic table for all the nodes in the network.

 process300: states transformation in 300 time steps

 process1000: states transformation in 1000 time steps

 result: The total risk degree of every node in the network, scaling from 0 to 10
as ‘Magnitude’

 rador: rador map for small network simulation to show the risk degree.


Thesis project for NJ--Clustering&amp;Heatmaps-updated.ipynb: Python program for
clustering and analysis
There are some points that need your attention:
1. This file is written with Python Jupyter Notebook. So you have to install
anaconda first to open this file.
2. Total_network.xlsm is a VBA excel file and Jupyter notebook can not open it
directly. So it has to be saved as .csv file first before being read by Python
IDE.
3. Libraries to be installed first before import:
folium—to generate the distribution map on leaflet for K means clustering
seaborn—to generate pretty graphs for correlation matrix
gmaps—to generate heatmaps on Google map to show the risk degrees for
each node in the network after simulation. Note that an API_Key is needed to
use this service (everyone can apply for the key with his own account).
f_nw.m: main program for simulation with Matlab
