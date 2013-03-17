# GuestList

GuestList is a Java Struts web application that was written during my engagement
to support my family's need to have a single repository of wedding guest
information.

GuestList is a web interface to a list of contacts (guests) and administrators
(hosts).  Each guest invited by a host is displayed in a separate color,
allowing the hosts to see who is invited by whom.

GuestList is not enterprise ready or secure software; it was written for ease of
use and simplicity. Passwords are not hashed or encrypted, so please do not use
this application for storing national secrets.

## Installation

GuestList was built with NetBeans 5.5 originally, but has been upgraded to build
with NetBeans 7.3. The web application archive can be dropped into any java 
webapp/servlet container. The application has successfully been deployed in:

 * Apache Tomcat 4, 5.5, 6
 * GlassFish 3.1.2
 
To deploy in tomcat, simply drop the application into the "webapps" directory, 
or upload the web archive into the bundled "manager" web application.

### Database Setup

The database must be created prior to accessing GuestList. This database is not
created automatically. Currently it only supports PostgreSQL via the Java JDBC
drivers.

To create your database, copy the guestlist.sql file to your filesystem and:

    > psql -U postgres postgres
    psql> create role guestlist with password 'guestlist';
    psql> create database guestlist with owner guestlist;
    psql> \c guestlist
    psql> \i guestlist.sql
    psql> insert into hosts (hostid, name, password, color, login) values 
        (1, 'admin', 'admin', '#FFF', 'admin');
        
These steps performs these steps:

 1. Creates the guestlist role, or login for the application.
 2. Creates the guestlist database that the guestlist application will log in to.
    Please choose your own login and password.
 3. Connects to the guestlist database.
 4. Creates the tables and relationships for the application.
 5. Creates an administrative user with a login of 'admin', and password of 
    'admin'. Please choose your own login and password.    

Once these items are in place, you can access the GuestList application.

## Issues

Feel free to open any issues at (github.com)[https://github.com/dzwarg/GuestList]