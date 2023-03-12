# VERODigitalSolutions-iOSTask
 
VeroTaskList is an iOS application built with MVVM design pattern that utilizes the BauBuddy API for task management. The app enables users to store, fetch, search and display their tasks using GET and POST requests. Additionally, it supports scanning QR codes, refreshing data and persistent data storage using UserDefaults.

The app requests the resources located at https://api.baubuddy.de/dev/index.php/v1/tasks/select and stores them in an appropriate data structure that allows the app to be used offline. The app displays all items in a list showing task, title, description, and colorCode, which is a view colored according to colorCode. The app offers a search bar that allows searching for any of the class properties (even those that are not visible to the user directly). The app also offers a menu item that allows scanning for QR-Codes. Upon successful scan, the search query is set to the scanned text. In order to refresh the data, the app offers a pull-2-refresh functionality.

# Features
* Resource Request
* Data Storage
* Fetching and listing datas using GET request after login to the site using POST request
* Searching datas
* Scanning QR codes
* Refreshing datas

# Technologies
* MVVM Design Pattern
* URLSession
* UserDefaults
* UIKit
* Extensions
* AVFoundation
* UITableView
* UISearchBar
* UITabBarController
