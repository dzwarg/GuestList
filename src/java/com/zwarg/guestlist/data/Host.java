/*
 * Host.java
 *
 * Created on July 24, 2006, 6:41 PM
 */

package com.zwarg.guestlist.data;

import java.beans.*;
import java.io.Serializable;
import java.util.Map;

/**
 * @author davidz
 */
public class Host extends Object implements Serializable, Comparable {
  
  public static final String PROP_FULL_NAME = "fullName";
  public static final String PROP_USER_NAME = "userName";
  public static final String PROP_COLOR = "color";
  public static final String PROP_PASSWORD = "password";
  public static final String PROP_AUTHENTICATED = "authenticated";
  public static final String PROP_ID = "id";
  
  private String fullName;
  private String userName;
  private String color;
  private String password;
  private Boolean authenticated;
  private int id;
  
  private PropertyChangeSupport propertySupport;
  
  public Host() {
    propertySupport = new PropertyChangeSupport(this);
  }
  
  public String getFullName() {
    return fullName;
  }
  
  public void setFullName(String value) {
    String oldValue = fullName;
    fullName = value;
    propertySupport.firePropertyChange( PROP_FULL_NAME, oldValue, fullName );
  }
  
  public String getUserName() {
    return userName;
  }
  
  public void setUserName(String value) {
    String oldValue = userName;
    userName = value;
    propertySupport.firePropertyChange( PROP_USER_NAME, oldValue, userName );
  }
  
  public Boolean getAuthenticated() {
    return authenticated;
  }
  
  public void setAuthenticated( Boolean value ) {
    Boolean oldValue = authenticated;
    authenticated = value;
    propertySupport.firePropertyChange( PROP_AUTHENTICATED, oldValue, authenticated );
  }
  
  public String getColor() {
    return color;
  }
  
  public void setColor( String value ) {
    String oldValue = color;
    color = value;
    propertySupport.firePropertyChange( PROP_COLOR, oldValue, color );
  }
  
  public String getPassword() {
    return password;
  }
  
  public void setPassword( String value ) {
    String oldValue = password;
    password = value;
    propertySupport.firePropertyChange( PROP_PASSWORD, oldValue, password );
  }
  
  public int getId()
  {
    return id;
  }
  
  public void setId( int value )
  {
    int oldValue = id;
    id = value;
    propertySupport.firePropertyChange( PROP_ID, oldValue, id );
  }
  
  public void addPropertyChangeListener(PropertyChangeListener listener) {
    propertySupport.addPropertyChangeListener(listener);
  }
  
  public void removePropertyChangeListener(PropertyChangeListener listener) {
    propertySupport.removePropertyChangeListener(listener);
  }
  
  public static Host validate( javax.servlet.http.HttpServletRequest request )
  {
    String strParam = request.getParameter( "fullname" );
    if ( strParam == null )
      return null;
    if ( strParam.length() == 0 )
      return null;
    
    Host myHost = new Host();
    myHost.setFullName( strParam );
        
    strParam = request.getParameter( "color" );
    if ( strParam == null )
      return null;
    if ( strParam.length() == 0 )
      return null;

    myHost.setColor( strParam );
    
    strParam = request.getParameter("username");
    if ( strParam == null )
      return null;
    if ( strParam.length() == 0 )
      return null;
    
    myHost.setUserName( strParam );
    
    strParam = request.getParameter("password");
    if ( strParam == null )
      return null;
    if ( strParam.length() == 0 )
      return null;
    
    myHost.setPassword( strParam );
    
    return myHost;
  }

  public int compareTo(Object o) 
  {
    if ( o instanceof Host )
    {
      Host h = (Host)o;
      
      return getFullName().compareTo( h.getFullName() );
    }
    
    throw new ClassCastException( "The object to compare is not a Host object." );
  }
}
