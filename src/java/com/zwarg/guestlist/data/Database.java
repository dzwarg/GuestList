/*
 * Database.java
 *
 * Created on July 24, 2006, 6:58 PM
 *
 * Copyright (c) 2013 David Zwarg <david.zwarg@gmail.com>
 * See LICENSE in the project root for copying permission.
 */
package com.zwarg.guestlist.data;

import java.util.*;
import java.sql.*;
import javax.servlet.http.*;

/**
 *
 * @author davidz
 */
public class Database {
  
  private static ResourceBundle resources =
    ResourceBundle.getBundle( "com.zwarg.guestlist.data.DataAccess" );
  
  private Connection conn;
  private Statement stmt;
  private ResultSet rset;
  
  public static final int STATE_WITH_PLEASURE = 1;
  public static final int STATE_WITH_REGRET = 2;
  public static final int STATE_NOT_YET_REPLIED = 4;
  
  public static Database newConnection()
  {
    Database db = null;
    try
    {
      Class.forName( "org.postgresql.Driver" );

      String strConnection = "jdbc:postgresql://" +
        resources.getString( "host" ) + ":" +
        resources.getString( "port" ) + "/" +
        resources.getString( "database" );

      String strDBUsername = resources.getString( "username" );
      String strDBPassword = resources.getString( "password" );
      
      db = new Database();
      db.saveConnection( DriverManager.getConnection( strConnection, strDBUsername, strDBPassword ) );
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    
    return db;
  }
  
  private void saveConnection( Connection c )
  {
    this.conn = c;
  }
  
  public void disconnect()
  {
    try{
      conn.close();
    }
    catch ( Exception e ) {}
  }
  
  public Host login( HttpServletRequest request )
  {
    Host theHost = null;
    
    try
    {
      stmt = conn.createStatement();
      String query = "SELECT * FROM hostlist " +
        "WHERE \"Login\"='" + cleanSQL( request.getParameter("user") ) + "' " +
        "AND \"Password\"='" + cleanSQL( request.getParameter("pass") ) + "'";
      
      rset = stmt.executeQuery( query );

      while( rset.next() ) {
        if ( theHost != null )
        {
          theHost = null;
          break;
        }
        
        theHost = new Host();
        theHost.setFullName( rset.getString( "Name" ) );
        theHost.setUserName( rset.getString( "Login" ) );
        theHost.setColor( rset.getString( "Color" ) );
        theHost.setId( rset.getInt( "HostID" ) );
        theHost.setPassword( rset.getString( "Password" ) );
        theHost.setAuthenticated( Boolean.TRUE );
      }

      rset.close();
      stmt.close();
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    
    return theHost;
  }
  
  public Host addHost( Host newHost )
  {
    int id = getLastHostID() + 1;
    newHost.setId( id );
    
    String insert = "INSERT INTO hostlist ( \"HostID\", \"Name\", \"Login\", \"Password\", \"Color\" ) VALUES ( " + 
      cleanSQL( Integer.toString( newHost.getId() ) ) + ",'" +
      cleanSQL( newHost.getFullName() ) + "','" +
      cleanSQL( newHost.getUserName() ) + "','" + 
      cleanSQL( newHost.getPassword() ) + "','" + 
      cleanSQL( newHost.getColor() ) + "' )";
    
    try {
      stmt = conn.createStatement();
    
      stmt.execute( insert );
    }
    catch ( SQLException sqle )
    {
      sqle.printStackTrace();
      return null;
    }
    
    return newHost;
  }
  
  private int getLastHostID()
  {
    String select = "SELECT MAX(\"HostID\") FROM hostlist";
    int id = -1;
    
    try{
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );
      
      while( rset.next() )
      {     
        id = rset.getInt(1);
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return id;
  }
  
  private int getLastGuestID()
  {
    String select = "SELECT MAX(\"GuestID\") FROM guestlist";
    int id = -1;
    
    try{
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );
      
      while( rset.next() )
      {     
        id = rset.getInt(1);
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return id;
  }
  
  public Host getHost( int id )
  {
    String select = "SELECT * FROM hostlist WHERE \"HostID\"=" + id;
    Host aHost = null;
    
    try
    {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );
      
      while ( rset.next() )
      {
        aHost = new Host();
        aHost.setId( rset.getInt( "HostID" ) );
        aHost.setFullName( rset.getString( "Name" ) );
        aHost.setUserName( rset.getString( "Login" ) );
        aHost.setColor( rset.getString( "Color" ) );
        aHost.setPassword( rset.getString( "Password" ) ); 
      }
      
      rset.close();
      stmt.close();
    }
    catch ( SQLException sqle )
    {
      sqle.printStackTrace();
    }
    
    return aHost;
  }
  
  public Vector getAllHosts()
  {
    String select = "SELECT * FROM hostlist";
    Vector hosts = new Vector();
    
    try {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );

      while ( rset.next() )
      {
        Host aHost = new Host();
        aHost.setId( rset.getInt( "Hostid" ) );
        aHost.setFullName( rset.getString( "Name" ) );
        aHost.setUserName( rset.getString( "Login" ) );
        aHost.setColor( rset.getString( "Color" ) );
        aHost.setPassword( rset.getString( "Password" ) );
        
        hosts.add( aHost );
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return hosts;
  }
  
  public Guest getGuest( int guestid )
  {
    String select = "SELECT * FROM guestlist WHERE \"GuestID\"=" + guestid;
    Guest aGuest = null;
    
    try {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );

      while ( rset.next() )
      {
        aGuest = createGuestFromResultSet( rset );
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return aGuest;
  }
  
  public Vector getGuestsByHost( int hostid )
  {
    String select = "SELECT * FROM guestlist WHERE \"HostID\"=" + hostid;
    Vector guests = new Vector();
    
    try {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );

      while ( rset.next() )
      {
        Guest aGuest = createGuestFromResultSet( rset );
        
        guests.add( aGuest );
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return guests;
  }
  
  public Vector getGuestsByState( int state )
  {
    Vector theGuests = new Vector();
    String select;
    
    if ( state == STATE_WITH_PLEASURE ) {
      select = "SELECT * FROM guestlist WHERE \"HasReplied\"=true AND \"Reply\"=true;";
    }
    else if ( state == STATE_WITH_REGRET ) {
      select = "SELECT * FROM guestlist WHERE \"HasReplied\"=true AND \"Reply\"=false;";
    }
    else if ( state == STATE_NOT_YET_REPLIED ) {
      select = "SELECT * FROM guestlist WHERE \"HasReplied\"=false;";
    }
    else
    {
      return theGuests;
    }
    
    try {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );
      
      while ( rset.next() )
      {
        Guest aGuest = createGuestFromResultSet( rset );
        
        theGuests.add( aGuest );
      }
      
      rset.close();
      stmt.close();
    }
    catch( SQLException sqle )
    {
      sqle.printStackTrace();
    }
    
    return theGuests;
  }
  
  public Vector getAllGuests()
  {
    String select = "SELECT * FROM guestlist";
    Vector guests = new Vector();
    
    try {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );

      while ( rset.next() )
      {
        Guest aGuest = createGuestFromResultSet( rset );
        
        guests.add( aGuest );
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return guests;
  }
  
  public boolean changeGuest( Guest newGuest )
  {
    StringBuffer sb = new StringBuffer();
    
    sb.append( "UPDATE guestlist SET ");
    sb.append( "\"Title\"='" + cleanSQL( newGuest.getTitle() ) + "', " );
    sb.append( "\"ProperName\"='" + cleanSQL( newGuest.getProperName() ) + "', " );
    sb.append( "\"InnerEnvelopeName\"='" + cleanSQL( newGuest.getInnerEnvelopeName() ) + "', " );
    
    if ( newGuest.getSigOtherTitle() != null ) {
      sb.append( "\"SigOtherTitle\"='" + cleanSQL( newGuest.getSigOtherTitle() ) + "', " );
    }
    if ( newGuest.getSigOtherProperName() != null ) {
      sb.append( "\"SigOtherProperName\"='" + cleanSQL( newGuest.getSigOtherProperName() ) + "', " );
    }
    if ( newGuest.getSigOtherInnerEnvelopeName() != null ) {
      sb.append( "\"SigOtherEnvelopeName\"='" + cleanSQL( newGuest.getSigOtherInnerEnvelopeName() ) + "', " );
    }
    
    sb.append( "\"Address1\"='" + cleanSQL( newGuest.getAddress1() ) + "', " );
 
    if ( newGuest.getAddress2() != null )
    {
      sb.append( "\"Address2\"='" + cleanSQL( newGuest.getAddress2() ) + "', " );
    }
    
    sb.append( "\"City\"='" + cleanSQL( newGuest.getCity() ) + "', " );
    sb.append( "\"State\"='" + cleanSQL( newGuest.getState() ) + "', " );
    sb.append( "\"Zip\"=" + Integer.toString( newGuest.getZip() ) + ", " );
    
    if ( newGuest.getZipFour() != 0 )
    {
      sb.append( "\"ZipPlusFour\"=" + Integer.toString( newGuest.getZipFour() ) + ", " );
    }
    
    sb.append( "\"SaveDateSent\"=" + Boolean.toString( newGuest.getSaveTheDateSent() ) + ", " );
    
    sb.append( "\"InviteSent\"=" + Boolean.toString( newGuest.getInvitationSent() ) + ", " );
    
    sb.append( "\"HasReplied\"=" + Boolean.toString( newGuest.getHasReplied() ) + ", " );
    
    sb.append( "\"Reply\"=" + Boolean.toString( newGuest.getReply() ) + ", " );
    
    sb.append( "\"ThankYouSent\"=" + Boolean.toString( newGuest.getThankYou() ) + ", " );
    
    if ( newGuest.getUnderEighteen1() != null )
    {
      sb.append( "\"UnderEighteen1\"='" + cleanSQL( newGuest.getUnderEighteen1() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen2() != null )
    {
      sb.append( "\"UnderEighteen2\"='" + cleanSQL( newGuest.getUnderEighteen2() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen3() != null )
    {
      sb.append( "\"UnderEighteen3\"='" + cleanSQL( newGuest.getUnderEighteen3() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen4() != null )
    {
      sb.append( "\"UnderEighteen4\"='" + cleanSQL( newGuest.getUnderEighteen4() ) + "', " );
    }
    
    sb.append( "\"UnderEighteenAttending\"=" + Integer.toString( newGuest.getUnderEighteenAttending() ) + ", " );
    
    if ( newGuest.getLodging() != null )
    {
      sb.append( "\"Lodging\"='" + cleanSQL( newGuest.getLodging() ) + "', " );
    }
    
    if ( newGuest.getTravelType() != null )
    {
      sb.append( "\"TravelType\"='" + cleanSQL( newGuest.getTravelType() ) + "', " );
    }
    
    if ( newGuest.getTravelDestination() != null )
    {
      sb.append( "\"TravelDestination\"='" + cleanSQL( newGuest.getTravelDestination() ) + "', " );
    }
    
    if ( newGuest.getArrivalDate() != null )
    {
      sb.append( "\"ArrivalDate\"='" + newGuest.getArrivalDate() + "', " );
    }
    
    if ( newGuest.getArrivalTime() != null )
    {
      sb.append( "\"ArrivalTime\"='" + newGuest.getArrivalTime() + "', " );
    }
    
    if ( newGuest.getDepartureDate() != null )
    {
      sb.append( "\"DepartureDate\"='" + newGuest.getDepartureDate() + "', " );
    }
    
    if ( newGuest.getDepartureTime() != null )
    {
      sb.append( "\"DepartureTime\"='" + newGuest.getDepartureTime() + "', " ) ;
    }
    
    if ( newGuest.getTelephone() != null )
    {
      sb.append( "\"Telephone\"='" + cleanSQL( newGuest.getTelephone() ) + "', " );
    }
    
    if ( newGuest.getEmail() != null )
    {
      sb.append( "\"Email\"='" + cleanSQL( newGuest.getEmail() ) + "', " );
    }
    
    if ( newGuest.getGiftSource() != null )
    {
      sb.append( "\"GiftSource\"='" + cleanSQL( newGuest.getGiftSource() ) + "', " );
    }
    
    if ( newGuest.getGiftItem() != null )
    {
      sb.append( "\"GiftItem\"='" + cleanSQL( newGuest.getGiftItem() ) + "', " );
    }
    
    sb.append( "\"HostID\"=" + Integer.toString( newGuest.getInvitedBy() ) + " " );
    
    sb.append( "WHERE \"GuestID\"=" + Integer.toString( newGuest.getId() ) + ";" );
    
    try
    {
      stmt = conn.createStatement();
      stmt.execute( sb.toString() );
      
      stmt.close();
    }
    catch ( SQLException sqle ) {
      sqle.printStackTrace();
      return false;
    }
    
    return true;
  }
  
  public boolean changeHost( int id, String full, String color, String user, String pass )
  {
    String update = "UPDATE hostlist SET \"Name\"='" +
      cleanSQL( full ) + "', \"Password\"='" + 
      cleanSQL( pass ) + "', \"Color\"='" + 
      cleanSQL( color ) + "', \"Login\"='" +
      cleanSQL( user ) + "' WHERE \"HostID\"=" + id;
   
    try
    {
      stmt = conn.createStatement();
      stmt.execute( update );
      
      stmt.close();
    }
    catch ( SQLException sqle ) {
      sqle.printStackTrace();
      return false;
    }
    
    return true;
  }
  
  public boolean setLock( String list, boolean state )
  {
    String update = "UPDATE lockedlist SET locked=" + state + " WHERE list='" + cleanSQL( list ) + "'";
    boolean status = false;
    
    try
    {
      stmt = conn.createStatement();
      stmt.execute( update );
      
      stmt.close();
      
      status = true;
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return status;
  }
  
  public boolean getLock( String list )
  {
    String select = "SELECT locked FROM lockedlist WHERE list='" + cleanSQL( list ) + "'";
    boolean locked = false;
    
    try
    {
      stmt = conn.createStatement();
      rset = stmt.executeQuery( select );
      
      while ( rset.next() )
      {
        locked = rset.getBoolean( 1 );
      }
      
      rset.close();
      stmt.close();
    }
    catch (SQLException sqle)
    {
      sqle.printStackTrace();
    }
    
    return locked;
  }
  
  public boolean deleteHost( int id )
  {
    String delete = "DELETE FROM hostlist WHERE \"HostID\"=" + id;
    boolean deleted = false;
    
    try
    {
      stmt = conn.createStatement();
      stmt.execute( delete );
      
      stmt.close();
      
      deleted = true;
    }
    catch ( SQLException sqle )
    {
      sqle.printStackTrace();
    }
    
    return deleted;
  }
  
  public boolean deleteGuest( int id )
  {
    String delete = "DELETE FROM guestlist WHERE \"GuestID\"=" + id;
    boolean deleted = false;
    
    try
    {
      stmt = conn.createStatement();
      stmt.execute( delete );
      
      stmt.close();
      
      deleted = true;
    }
    catch ( SQLException sqle )
    {
      sqle.printStackTrace();
    }
    
    return deleted;
  }
  
  public Guest addGuest( Guest newGuest )
  {
    int id = getLastGuestID() + 1;
    newGuest.setId( id );
    
    StringBuffer sbFields = new StringBuffer();
    StringBuffer sbValues = new StringBuffer();
    
    sbFields.append( "INSERT INTO guestlist (");
    sbFields.append( "\"GuestID\", \"Title\", " );
    sbFields.append( "\"ProperName\",  \"InnerEnvelopeName\"," );
    sbValues.append( Integer.toString( newGuest.getId() ) + "," );
    sbValues.append( "'" + cleanSQL( newGuest.getTitle() ) + "'," );
    sbValues.append( "'" + cleanSQL( newGuest.getProperName() ) + "'," );
    sbValues.append( "'" + cleanSQL( newGuest.getInnerEnvelopeName() ) + "'," );
    
    if ( newGuest.getSigOtherTitle() != null ) {
      sbFields.append( "\"SigOtherTitle\", ");
      sbValues.append( "'" + cleanSQL( newGuest.getSigOtherTitle() ) + "', " );
    }
    if ( newGuest.getSigOtherProperName() != null ) {
      sbFields.append( "\"SigOtherProperName\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getSigOtherProperName() ) + "', " );
    }
    if ( newGuest.getSigOtherInnerEnvelopeName() != null ) {
      sbFields.append( "\"SigOtherEnvelopeName\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getSigOtherInnerEnvelopeName() ) + "', " );
    }
    
    sbFields.append( "\"Address1\", " );
    sbValues.append( "'" + cleanSQL( newGuest.getAddress1() ) + "', " );
 
    if ( newGuest.getAddress2() != null )
    {
      sbFields.append( "\"Address2\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getAddress2() ) + "', " );
    }
    
    sbFields.append( "\"City\", \"State\", \"Zip\", " );
    sbValues.append( "'" + cleanSQL( newGuest.getCity() ) + "', " );
    sbValues.append( "'" + cleanSQL( newGuest.getState() ) + "', " );
    sbValues.append( Integer.toString( newGuest.getZip() ) + ", " );
    
    if ( newGuest.getZipFour() != 0 )
    {
      sbFields.append( "\"ZipPlusFour\", " );
      sbValues.append( Integer.toString( newGuest.getZipFour() ) + ", " );
    }
    
    sbFields.append( "\"SaveDateSent\", " );
    sbValues.append( Boolean.toString( newGuest.getSaveTheDateSent() ) + ", " );
    
    sbFields.append( "\"InviteSent\", " );
    sbValues.append( Boolean.toString( newGuest.getInvitationSent() ) + ", " );
    
    sbFields.append( "\"HasReplied\", " );
    sbValues.append( Boolean.toString( newGuest.getHasReplied() ) + ", " );
    
    sbFields.append( "\"Reply\", " );
    sbValues.append( Boolean.toString( newGuest.getReply() ) + ", " );

    sbFields.append( "\"ThankYouSent\", " );
    sbValues.append( newGuest.getThankYou() + ", " );
        
    if ( newGuest.getGiftSource() != null )
    {
      sbFields.append( "\"GiftSource\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getGiftSource() ) + "', " );
    }
    
    if ( newGuest.getGiftItem() != null )
    {
      sbFields.append( "\"GiftItem\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getGiftItem() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen1() != null )
    {
      sbFields.append( "\"UnderEighteen1\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getUnderEighteen1() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen2() != null )
    {
      sbFields.append( "\"UnderEighteen2\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getUnderEighteen2() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen3() != null )
    {
      sbFields.append( "\"UnderEighteen3\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getUnderEighteen3() ) + "', " );
    }
    
    if ( newGuest.getUnderEighteen4() != null )
    {
      sbFields.append( "\"UnderEighteen4\", " ); 
      sbValues.append( "'" + cleanSQL( newGuest.getUnderEighteen4() ) + "', " );
    }
    
    sbFields.append( "\"UnderEighteenAttending\", " );
    sbValues.append( Integer.toString( newGuest.getUnderEighteenAttending() ) + ", " );
    
    if ( newGuest.getLodging() != null )
    {
      sbFields.append( "\"Lodging\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getLodging() ) + "', " );
    }
    
    if ( newGuest.getTravelType() != null )
    {
      sbFields.append( "\"TravelType\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getTravelType() ) + "', " );
    }
    
    if ( newGuest.getTravelDestination() != null )
    {
      sbFields.append( "\"TravelDestination\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getTravelDestination() ) + "', " );
    }
    
    if ( newGuest.getArrivalDate() != null )
    {
      sbFields.append( "\"ArrivalDate\", " );
      sbValues.append( "'" + newGuest.getArrivalDate() + "', " );
    }
    
    if ( newGuest.getArrivalTime() != null )
    {
      sbFields.append( "\"ArrivalTime\", " );  
      sbValues.append( "'" + newGuest.getArrivalTime() + "', " );
    }
    
    if ( newGuest.getDepartureDate() != null )
    {
      sbFields.append( "\"DepartureDate\", " );
      sbValues.append( "'" + newGuest.getDepartureDate() + "', " );
    }
    
    if ( newGuest.getDepartureTime() != null )
    {
      sbFields.append( "\"DepartureTime\", " ) ;
      sbValues.append( "'" + newGuest.getDepartureTime() + "', " ) ;
    }
    
    if ( newGuest.getTelephone() != null )
    {
      sbFields.append( "\"Telephone\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getTelephone() ) + "', " );
    }
    
    if ( newGuest.getEmail() != null )
    {
      sbFields.append( "\"Email\", " );
      sbValues.append( "'" + cleanSQL( newGuest.getEmail() ) + "', " );
    }
    
    sbFields.append( "\"HostID\" ) VALUES ( ");
    sbValues.append( Integer.toString( newGuest.getInvitedBy() ) + " ) " );
    
    try {
      stmt = conn.createStatement();
    
      stmt.execute( sbFields.toString() + sbValues.toString() );
    }
    catch ( SQLException sqle )
    {
      sqle.printStackTrace();
      return null;
    }
    
    return newGuest;
  }
  
  private String cleanSQL( String input )
  {
    if ( input == null )
      return "";
    
    StringBuffer buffer = new StringBuffer(input);
    
    int index = 0;
    
    index = buffer.indexOf( "'" );
    while ( index >= 0 )
    {
      buffer.insert( index, "\\" );
      index = buffer.indexOf( "'", index + 2 );
    }
    
    return buffer.toString();
  }
  
  private Guest createGuestFromResultSet( ResultSet rset )
    throws SQLException
  {
    String strTmp;
    int intTmp;
    java.sql.Date dateTmp;
    Time timeTmp;
      
    Guest aGuest = new Guest();
    aGuest.setId( rset.getInt( "GuestID" ) );
    aGuest.setTitle( rset.getString( "Title" ) );
    aGuest.setProperName( rset.getString( "ProperName" ) );
    aGuest.setInnerEnvelopeName( rset.getString( "InnerEnvelopeName" ) );

    if ( (strTmp = rset.getString( "SigOtherTitle" )) != null )
    {
      aGuest.setSigOtherTitle( strTmp );
    }
    if ( (strTmp = rset.getString( "SigOtherProperName" )) != null )
    {
      aGuest.setSigOtherProperName( strTmp );
    }
    if ( (strTmp = rset.getString( "SigOtherEnvelopeName" )) != null )
    {
      aGuest.setSigOtherInnerEnvelopeName( strTmp );
    }

    aGuest.setAddress1( rset.getString( "Address1" ) );
    if ( (strTmp = rset.getString( "Address2" )) != null )
    {
      aGuest.setAddress2( strTmp );
    }
    aGuest.setCity( rset.getString( "City" ) );
    aGuest.setState( rset.getString( "State" ) );
    aGuest.setZip( rset.getInt( "Zip" ) );
    if ( (intTmp = rset.getInt( "ZipPlusFour" )) != 0 )
    {
      aGuest.setZipFour( intTmp );
    }
    aGuest.setSaveTheDateSent( rset.getBoolean("SaveDateSent") );
    aGuest.setInvitationSent( rset.getBoolean("InviteSent") );
    aGuest.setHasReplied( rset.getBoolean("HasReplied" ) );
    aGuest.setReply( rset.getBoolean( "Reply" ) );
    aGuest.setThankYou( rset.getBoolean( "ThankYouSent" ) );
    if ( (strTmp = rset.getString( "UnderEighteen1" )) != null )
    {
      aGuest.setUnderEighteen1( strTmp );
    }
    if ( (strTmp = rset.getString( "UnderEighteen2" )) != null )
    {
      aGuest.setUnderEighteen2( strTmp );
    }
    if ( (strTmp = rset.getString( "UnderEighteen3" )) != null )
    {
      aGuest.setUnderEighteen3( strTmp );
    }
    if ( (strTmp = rset.getString( "UnderEighteen4" )) != null )
    {
      aGuest.setUnderEighteen4( strTmp );
    }
    if ( (intTmp = rset.getInt( "UnderEighteenAttending" )) != 0 )
    {
      aGuest.setUnderEighteenAttending( intTmp );
    }
    if ( (strTmp = rset.getString( "Lodging" )) != null )
    {
      aGuest.setLodging( strTmp );
    }
    if ( (strTmp = rset.getString( "TravelType" )) != null )
    {
      aGuest.setTravelType( strTmp );
    }
    if ( (strTmp = rset.getString( "TravelDestination" )) != null )
    {
      aGuest.setTravelDestination( strTmp );
    }
    if ( (dateTmp = rset.getDate( "ArrivalDate" )) != null )
    {
      aGuest.setArrivalDate( dateTmp );
    }
    if ( (timeTmp = rset.getTime( "ArrivalTime" )) != null )
    {
      aGuest.setArrivalTime( timeTmp );
    }
    if ( (dateTmp = rset.getDate( "DepartureDate" )) != null )
    {
      aGuest.setDepartureDate( dateTmp );
    }
    if ( (timeTmp = rset.getTime( "DepartureTime" )) != null )
    {
      aGuest.setDepartureTime( timeTmp );
    }
    if ( (strTmp = rset.getString( "Telephone" )) != null )
    {
      aGuest.setTelephone( strTmp );
    }
    if ( (strTmp = rset.getString( "Email" )) != null )
    {
      aGuest.setEmail( strTmp );
    }
    if ( (strTmp = rset.getString( "GiftSource" )) != null )
    {
      aGuest.setGiftSource( strTmp );
    }
    if ( (strTmp = rset.getString( "GiftItem" )) != null )
    {
      aGuest.setGiftItem( strTmp );
    }
    aGuest.setInvitedBy( rset.getInt( "HostID" ) );
    
    return aGuest;
  }
}

