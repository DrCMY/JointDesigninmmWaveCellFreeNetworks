# Joint Analog Beam Selection and Digital Beamforming in Millimeter Wave Cell-Free Massive MIMO Systems
Submitted paperwork.
This repository contains Matlab and Python codes for the submitted paper on joint design of analog beam selection and digital beamforming in millimeter-wave (mm-wave) cell-free (CF) massive MIMO (mMIMO) systems.
# Abstract
In this work, we propose beam searching algorithms with reduced complexities. However, as the network size grows, even low complexity beam selection algorithms can be too costly. As the next step, we propose supervised machine learning (SML) algorithms which can be trained by the proposed beam selection algorithms.
# Contents of the Repository
This repository contains three folders. In the Generator folder, random variables are created and logged in Matlab language. In the BeamSelection folder, joint design of analog beam selection and digital beamforming solutions are provided in Matlab language. In AI folder, SML algorithms are provided in Python language. The SML algorithms are trained by the outputs obtained from the joint design proposals provided in the BeamSelection folder. In AI folder, the sum-rate results based on the output decisions of SML algorithms are evaluated in Matlab language. Hence, comparisons between the sum-rate results of SML and conventional algorithms can be made. For further details, please see the ReadMe_v01.docx file.
# Introduction
The numerical results can be obtained in 3 steps. First, joint design proposals in the BeamSelection folder are executed on Matlab. To obtain the SML results, as the next step, SML algorithms in AI folder are executed on Python. As the final step, codes for sum-rate evaluations are executed on Matlab. For practical purposes, multiple videos that provide detailed usages of the codes are provided at a Dropbox address (click for the [short](https://tinyurl.com/beamselection)/[long](https://www.dropbox.com/sh/07dk4iatc1ahjps/AAAeSaKjjvgOxZ0W6tPh8RMFa?dl=0) URL).
# Simulation Environment
For the simulations, 
HW: Windows 10 desktop PC is used. 
SW: Matlab R2019a + Anaconda Navigator with TensorFlow environment (needs to be installed separately) and Spyder (comes with Anaconda) are used. For the input and outputs of the algorithms Microsoft Excel is recommended.
# Notes
Some files cannot be uploaded since their sizes are larger than 25 MB. These files can be downloaded from the same Dropbox address.
