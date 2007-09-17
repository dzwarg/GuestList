<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Browse Guests</title>
    <link rel="stylesheet" type="text/css" href="../styles/default.css"/>
  </head>
  <body>
    <%
     Database conn = (Database)session.getAttribute("connection");
     boolean guestLock = conn.getLock("guestlist");
    %>
    <div class="centeredIE">
      <div class="controlpanel centeredFF">
        <div style="width:24%; text-align: center;" class="floatleft">
          <a href="../manager.jsp">
            <img src="../images/manager.png" alt="Manager"/>
          </a>
          <div class="clear"></div>
          <a href="../manager.jsp">
            Manager
          </a>
        </div>
        <% if ( !guestLock ) { %>
        <div style="width:24%; text-align: center;" class="floatleft">
          <a href="add.jsp">
            <img src="../images/add.png" alt="Add"/>
          </a>
          <div class="clear"></div>
          <a href="add.jsp">
            Add
          </a>
        </div>
        <% } %>
        <div style="width:24%; text-align: center;" class="floatleft">
          <a href="lock.jsp">
            <img src="../images/locked.png" alt="Lock"/>
          </a>
          <div class="clear"></div>
          <a href="lock.jsp">
            Lock
          </a>
        </div>
        <div style="width:24%; text-align: center;" class="floatleft">
          <a href="../logout.jsp">
            <img src="../images/logout.png" alt="Logout"/>
          </a>
          <div class="clear"></div>
          <a href="../logout.jsp">
            Logout
          </a>
        </div>
      </div>
    </div>
    <div class="clear">&nbsp;</div>
    
    <h2>Browse Guests</h2>
    
    <%
      boolean bolStatus = false;

      if ( request.getParameter("grouping") == null ||
      !request.getParameter("grouping").equalsIgnoreCase("host") ) {
        
        
       String desc = ( request.getParameter("descriptions") == null ) ? "" :
         "&amp;descriptions=" + request.getParameter( "descriptions" );
       bolStatus = true; %>
       
       
      <div class="floatleft">
          Group By <a href="browse.jsp?grouping=host<%= desc %>">Host</a>
      </div>
      
    <% 
      }
      else
      {
       String desc = ( request.getParameter("descriptions") == null ) ? "" :
         "&amp;descriptions=" + request.getParameter( "descriptions" ); 
    %>
      <div class="floatleft">
          Group By <a href="browse.jsp?grouping=status<%= desc %>">Status</a>
      </div>
    <% } %>
    
    <%
     boolean bolVerbose = false;
     java.text.NumberFormat zipFormat = java.text.NumberFormat.getIntegerInstance();
     zipFormat.setMaximumIntegerDigits( 5 );
     zipFormat.setMinimumIntegerDigits( 5 );
     zipFormat.setGroupingUsed( false );
     java.text.NumberFormat zip4Format = java.text.NumberFormat.getIntegerInstance();
     zip4Format.setMaximumIntegerDigits( 4 );
     zip4Format.setMinimumIntegerDigits( 4 );
     zip4Format.setGroupingUsed( false );
     
     if ( request.getParameter("descriptions") == null ||
       !request.getParameter("descriptions").equalsIgnoreCase("comprehensive") ) {
       String grp = ( request.getParameter("grouping") == null ) ? "" :
         "&amp;grouping=" + request.getParameter("grouping"); %>
      <div class="floatright">
          <a href="browse.jsp?descriptions=comprehensive<%= grp %>">Comprehensive Details</a>
      </div>
      <div class="clear"></div>
    <% } else {
       bolVerbose = true;
       String grp = ( request.getParameter("grouping") == null ) ? "" :
         "&amp;grouping=" + request.getParameter("grouping"); %>
      <div class="floatright">
          <a href="browse.jsp?descriptions=brief<%= grp %>">Brief Details</a>
      </div>
      <div class="clear"></div>    
    <% } %>
    
    <%
    // Before processing, modify any guests that have been modified on this page.
    int guestChanged = 0;
    if ( bolVerbose ) {
      if ( request.getParameter("guestId") != null )
      {
        try
        {
          guestChanged = Integer.parseInt(request.getParameter("guestId"));
          
          Guest gMod = conn.getGuest( guestChanged );
          if ( gMod != null ) 
          {
            // update the guest some
            String saveTheDate = request.getParameter( "stdSent" );
            String inviteSent = request.getParameter( "inviteSent" );
            String thankYouSent = request.getParameter( "thankYouSent" );
            String reply = request.getParameter( "replied" );

            // set save the date
            if ( saveTheDate == null )
              gMod.setSaveTheDateSent( false );
            else if ( saveTheDate.equals( "on" ) )
              gMod.setSaveTheDateSent( true );
            else
              gMod.setSaveTheDateSent( false );

            // set invitation sent
            if ( inviteSent == null )
              gMod.setInvitationSent( false );
            else if ( inviteSent.equals( "on" ) )
              gMod.setInvitationSent( true );
            else
              gMod.setInvitationSent( false );
              
            if ( thankYouSent == null )
              gMod.setThankYou( false );
            else if ( thankYouSent.equals( "on" ) )
              gMod.setThankYou( true );
            else
              gMod.setThankYou( false );

            // set the reply
            if ( reply != null )
            {
              if ( reply.equals( "" ) )
              {
                gMod.setReply( false );
                gMod.setHasReplied( false );
              }
              else 
              {
                gMod.setHasReplied( true );

                if ( reply.equals( "yes" ) )
                  gMod.setReply( true );
                else
                  gMod.setReply( false );
              }
            }

            conn.changeGuest( gMod );
          }
        }
        catch ( NumberFormatException nfe ) {}
      }
    }
    %>
    
    <div class="MainSectionBorder">
      <% if ( bolStatus ) { %>
      
      <%
       java.util.Vector guestVec = new java.util.Vector();
       guestVec.add( conn.getGuestsByState( conn.STATE_WITH_PLEASURE ) );
       guestVec.add( conn.getGuestsByState( conn.STATE_WITH_REGRET ) );
       guestVec.add( conn.getGuestsByState( conn.STATE_NOT_YET_REPLIED ) );
       
       for ( int gv = 0; gv < guestVec.size(); gv++ )
       {
         java.util.Vector guests = (java.util.Vector)guestVec.get( gv );
         java.util.Collections.sort( guests );
         int count = Guest.summarizeGuests( guests );
      %>
      
      <div class="marginleft">
        <div>
          <div class="floatleft">
            <h2>
              <%= ( ( gv == 0 ) ? "With Pleasure" : "" ) %>
              <%= ( ( gv == 1 ) ? "With Regrets" : "" ) %>
              <%= ( ( gv == 2 ) ? "Not Yet Replied" : "" ) %>
            </h2>
          </div>
          <div class="floatleft">
            <h3>&nbsp;( <%= count %> )</h3>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
      <%   
         for ( int gindex = 0; gindex < guests.size(); gindex++ ) {
           Guest g = (Guest)guests.get( gindex );
           Host h = conn.getHost( g.getInvitedBy() );
      %>
      
      <form name="guest<%= g.getId() %>" action="browse.jsp#guest<%= g.getId() %>" method="get">
          <a name="guest<%= g.getId() %>"/>
          <input type="hidden" name="descriptions" value="comprehensive" />
          <input type="hidden" name="grouping" value="status" />
          <input type="hidden" name="guestId" value="<%= g.getId() %>" />
          
          <div class="guestname" style="background-color:<%= h.getColor() %>;">
              <div style="margin: 5px 5px 5px 5px;">
                  <div class="clear">&nbsp;</div>
                  
                  <div class="floatleft" style="width: 25px; text-align: right">
                      <%= (gindex + 1) %>.&nbsp;
                  </div>
                  
                  <div class="floatleft" style="width: 15%;">
                      <% if ( !guestLock ) { %>
                      <a href="edit.jsp?id=<%= g.getId() %>">
                          <% } %>
                          
                          <%= g.getFormattedName() %>
                      <% if ( !guestLock ) { %></a>
                  </div>
                  
                  <div class="floatleft smalltext" style="width: 5%">
                      <i><%= ( g.getHasReplied() && g.getReply() ) ? "Attending" : "Invited " %></i>:
                      <%= g.countIndividuals() %>
                  </div>
                  
                  <% if ( bolVerbose ) { %>
                  
                  <div class="floatleft marginleft smalltext nooverflow" style="width: 20%;">
                      <div>
                          <b>Address</b>
                      </div>
                      <div>
                          <%= g.getAddress1() %>
                          <br/>
                          <% if ( g.getAddress2() != null && !g.getAddress2().equals( "" ) ) {
                          out.write( g.getAddress2() ); %>
                          <br/>
                          <% } %>
                          <%= g.getCity() %>
                          <br/>
                          <%= g.getState() %>, <%= zipFormat.format( g.getZip() ) %>
                          <% if ( g.getZipFour() != 0 ) { %>
                          - <%= zip4Format.format( g.getZipFour() ) %>
                          <% } %>
                      </div>
                  </div>
                  
                  <div class="floatleft marginleft centeredIE smalltext nooverflow" style="width: 15%">
                      <div style="text-align:left;">
                          <input type="checkbox" name="stdSent" <%= ( g.getSaveTheDateSent() ? "checked" : "" ) %>/>
                          <b>Save The Date?</b>
                      </div>
                      <div style="text-align:left;">
                          <input type="checkbox" name="inviteSent" <%= ( g.getInvitationSent() ? "checked" : "" ) %>/>
                          <b>Invitation?</b>
                      </div>
                      <div style="text-align:left;">
                          <input type="checkbox" name="thankYouSent" <%= ( g.getThankYou() ? "checked" : "" ) %>/>
                          <b>Thank You Sent?</b>
                      </div>
                  </div>
                  
                  <div class="floatleft marginleft centeredIE smalltext nooverflow" style="width: 10%;">
                      <div>
                          <b>Reply?</b>
                      </div>
                      <div>
                        <%
                            boolean bolAffirmativeReply = false;
                            boolean bolNegativeReply = false;
                            boolean bolNoReply = false;
                          
                            bolAffirmativeReply = g.getHasReplied() && g.getReply();
                            bolNegativeReply = g.getHasReplied() && !g.getReply();
                            bolNoReply = !g.getHasReplied();
                        %>
                          <input type="radio" name="replied" value="yes"
                            <%= (bolAffirmativeReply) ? "checked=\"checked\"" : "" %> id="gPosReply<%= g.getId() %>" />
                            <label for="gPosReply<%= g.getId() %>" class="message">Pleasure</label><br/>
                          <input type="radio" name="replied" value="no"
                            <%= (bolNegativeReply) ? "checked=\"checked\"" : "" %> id="gNegReply<%= g.getId() %>" />
                            <label for="gNegReply<%= g.getId() %>" class="error">Regrets</label><br/>
                          <input type="radio" name="replied" value=""
                            <%= (bolNoReply) ? "checked=\"checked\"" : "" %> id="gNoReply<%= g.getId() %>" />
                            <label for="gNoReply<%= g.getId() %>" class="warningFG">Not Yet</label>
                      </div>
                  </div>
                  
                  <div class="floatleft marginleft smalltext nooverflow" style="width: 20%;">
                      <div>
                          <b>Gift Information</b>
                      </div>
                      <div>
                          <% if ( g.getGiftSource() != null && g.getGiftSource().length() > 0 ) { %>
                          Source: <%= g.getGiftSource() %>
                          <div class="clear"></div>
                          <% } if ( g.getGiftItem() != null && g.getGiftItem().length() > 0 ) { %>
                          Description: <%= g.getGiftItem() %>
                          <% } %>
                      </div>
                  </div>
                  <% } %>
                  
                  <div class="floatright" style="margin: 5px 5px 5px 5px; text-align:center;">
                      <% if ( bolVerbose ) { %>
                      <input type="image" src="../images/save.png" value="Save" class="linkbutton" alt="Save" />
                      <% } %>
                      <a class="deletelink" href="delete.jsp?id=<%= g.getId() %>">
                          <img src="../images/delete.png" alt="Delete" class="linkbutton"/>
                      </a>
                  </div>
                  
                  <div class="clear">&nbsp;</div>
                  <% } %>
                  
              </div>
              
              <% if ( guestChanged == g.getId() ) { %>
                <span class="message">Updated guest.</span>
              <% } %>
          </div>
      </form>
      
      <% } %>
      
      </div>
      
      <% } %>
      
      <% } else { %>
      
      <%
        java.util.Vector hosts = conn.getAllHosts();
        for ( int hindex = 0; hindex < hosts.size(); hindex++ ) {
          Host h = (Host)hosts.get( hindex );
      %>
      <div class="hostname" style="background-color:<%= h.getColor() %>">
        <%= h.getFullName() %>'s Guests

        <%
          java.util.Vector guests = conn.getGuestsByHost( h.getId() );
          java.util.Collections.sort( guests );
          int count = Guest.summarizeGuests( guests );
          
          out.write( "( " + count + " ) ");
          
          for ( int gindex = 0; gindex < guests.size(); gindex++ ) {
            Guest g = (Guest)guests.get( gindex );
        %>
        
        <form name="guest<%= g.getId() %>" action="browse.jsp#guest<%= g.getId() %>" method="get">
            <a name="guest<%= g.getId() %>"/>
            <input type="hidden" name="descriptions" value="comprehensive" />
            <input type="hidden" name="grouping" value="host" />
            <input type="hidden" name="guestId" value="<%= g.getId() %>" />     
            
            <div class="guestname">
                <div class="clear">&nbsp;</div>
                
                <div class="floatleft" style="width: 25px; text-align: right;">
                    <%= (gindex + 1) %>.&nbsp;
                </div>
                <div class="floatleft" style="width: 15%">
                    <% if ( !guestLock ) { %>
                    <a href="edit.jsp?id=<%= g.getId() %>">
                        <% } %>
                        <%= g.getFormattedName() %>
                    <% if ( !guestLock ) { %></a>
                </div>
                
                <div class="floatleft smalltext" style="width: 5%">
                    <i><%= ( g.getHasReplied() && g.getReply() ) ? "Attending" : "Invited " %></i>:
                    <%= g.countIndividuals() %>
                </div>
                
                <% if ( bolVerbose ) { %>
                <div class="floatleft marginleft smalltext nooverflow" style="width: 20%">
                    <div>
                        <b>Address</b>
                    </div>
                    <div>
                        <%= g.getAddress1() %>
                        <br/>
                        <% if ( g.getAddress2() != null && !g.getAddress2().equals( "" ) ) {
                        out.write( g.getAddress2() ); %>
                        <br/>
                        <% } %>
                        <%= g.getCity() %>
                        <br/>
                        <%= g.getState() %>, <%= zipFormat.format( g.getZip() ) %>
                        <% if ( g.getZipFour() != 0 ) { %>
                        - <%= zip4Format.format( g.getZipFour() ) %>
                        <% } %>
                    </div>
                </div>
                
                <div class="floatleft marginleft centeredIE smalltext nooverflow" style="width: 15%">
                    <div style="text-align:left;">
                        <input type="checkbox" name="stdSent" <%= ( g.getSaveTheDateSent() ? "checked" : "" ) %>/>
                        <b>Save The Date?</b>
                    </div>
                    <div style="text-align:left;">
                        <input type="checkbox" name="inviteSent" <%= ( g.getInvitationSent() ? "checked" : "" ) %>/>
                        <b>Invitation?</b>
                    </div>
                    <div style="text-align:left;">
                        <input type="checkbox" name="thankYouSent" <%= ( g.getThankYou() ? "checked" : "" ) %>/>
                        <b>Thank You Sent?</b>
                    </div>
                </div>
                
                <div class="floatleft marginleft centeredIE smalltext nooverflow" style="width: 10%">
                    <div>
                        <b>Reply?</b>
                    </div>
                    <div>
                        <%
                        boolean bolAffirmativeReply = false;
                        boolean bolNegativeReply = false;
                        boolean bolNoReply = false;
                        
                        bolAffirmativeReply = g.getHasReplied() && g.getReply();
                        bolNegativeReply = g.getHasReplied() && !g.getReply();
                        bolNoReply = !g.getHasReplied();
                        %>
                        <input type="radio" name="replied" value="yes"
                               <%= (bolAffirmativeReply) ? "checked=\"checked\"" : "" %> id="gPosReply<%= g.getId() %>" />
                        <label for="gPosReply<%= g.getId() %>" class="message">Pleasure</label><br/>
                        <input type="radio" name="replied" value="no"
                               <%= (bolNegativeReply) ? "checked=\"checked\"" : "" %> id="gNegReply<%= g.getId() %>" />
                        <label for="gNegReply<%= g.getId() %>" class="error">Regrets</label><br/>
                        <input type="radio" name="replied" value=""
                               <%= (bolNoReply) ? "checked=\"checked\"" : "" %> id="gNoReply<%= g.getId() %>" />
                        <label for="gNoReply<%= g.getId() %>" class="warningFG">Not Yet</label>
                    </div>
                </div>
                
                <div class="floatleft marginleft smalltext nooverflow" style="width: 20%">
                    <div>
                        <b>Gift Information</b>
                    </div>
                    <div>
                        <% if ( g.getGiftSource() != null && g.getGiftSource().length() > 0 ) { %>
                        Source: <%= g.getGiftSource() %>
                        <div class="clear"></div>
                        <% } if ( g.getGiftItem() != null && g.getGiftItem().length() > 0 ) { %>
                        Description: <%= g.getGiftItem() %>
                        <% } %>
                    </div>
                </div>
                
                <% } %>
                <div class="floatright">
                    <% if ( bolVerbose ) { %>
                    <input type="image" src="../images/save.png" value="Save" class="linkbutton" alt="Save" />
                    <% } %>
                    <a class="deletelink" href="delete.jsp?id=<%= g.getId() %>">
                        <img src="../images/delete.png" alt="Delete" class="linkbutton"/>
                    </a>
                </div>
                <% } %>
            </div>
        </form>
        
        <div class="clear">&nbsp;</div>
        
        <% if ( guestChanged == g.getId() ) { %>
        <span class="message">Updated guest.</span>
        <% } %>
        
        <% } %>
        
      </div>
      <% } %>
      
      <% } %>
    </div>
    
  </body>
</html>
