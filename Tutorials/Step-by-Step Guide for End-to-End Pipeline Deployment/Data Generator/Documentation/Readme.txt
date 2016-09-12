Personalized Offers For Online Retail Solution Template Read Me

The contents of this directory contain important components concerning the Personalized Offers For 
Online Retail Solution Template that you have replicated in your subscription.  

Synthetic Data Source

The directory DataGenerator contains the applicaiton that is used to populate the Azure Event Hub that is 
the entry point for data ingestion for the solution template. 

The application can be found at \DataGenerator\generator.exe

The application has been pre-configured with the Azure Event Hub and Azure Storage Account details from the 
deployment of the solution template to your subscription. 

To move data to the Azure Event Hub, launch the application and follow the menu selections to start
the process.

To stop data flowing to Event Hub use the menu option to stop the process or simply close the application.

NOTE: The generator will submit data to the Azure Event Hub, and hydrate the data pipeline, only when it 
is actively running. If the computer the application is running shuts down or loses network connectivity the 
generator.exe application will need to be restarted.

Power BI Desktop Template File

The directory Power BI Template contains the Power BI Designer file which will help you recreate 
the Power BI dashboard to visualize data from this solution template.      

The designer file can be found at \Power BI Template\XXXXXX.pbix

Please read the instructions on this page [Provide link "Cortana Analytics Solution Template Playbook for predictive maintenance"] 
recreate the Power BI dashboard.