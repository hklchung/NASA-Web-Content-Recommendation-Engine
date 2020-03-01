<br />
<p align="center">
  <a href="https://github.com/hklchung/Short-Project-NASA-Web-Logs">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/NASA_logo.svg/1200px-NASA_logo.svg.png" height="30">
  </a>

  <h3 align="center">NASA Web Logs</h3>

  </p>
</p>

## About the Project

In this project, I would like to analyse the <a href="http://opensource.indeedeng.io/imhotep/docs/sample-data/"><strong>NASA Web Logs Dataset</strong></a> and find interesting insights and build a solution for a made-up scenario. 

## Scenario

The Head of Digital at NASA has a goal to increase visitors to the NASA website in the next year. To achieve this, she wants to improve the overall customer experience by tailoring the content and layout on the website based on visitor usage information and behaviour patterns.

## Solution Overview

Here is my end-to-end solution for the Digital team at NASA to implement into their website to tailor fit content for their visitors. The solution consists of two key components.
* Web insight dashboard
  * Suitable for both ad-hoc analysis of visitor behaviour and monthly reporting of web performance
  * A suite of functions developed in R that automates analytics of web traffic, content popularity, top visitors and server response
  * The output from these functions are readily available to integrate with any downstream reporting and visualisation tools
  * An additional R function to collate web logs and pre-process data for content propensity modelling purposes
* Content Recommendation Engine
  * A streamlined process built in Python to leverage data produced via the R functions to build propensity models for content on NASA web
  * Builds one propensity model per content type available on NASA web (3 can be found in the Jupyter notebook)
  * Solution design for content recommendation engine - how all the propensity models fit together such that NASA web can provide content most relevant and contextual to the visitor at any point in time
