<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Edit Guest</title>
    <link rel="stylesheet" type="text/css" href="../styles/default.css"/>
  </head>
  <body>
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
        <div style="width:24%; text-align: center;" class="floatleft">
          <a href="browse.jsp">
            <img src="../images/browse.png" alt="Browse"/>
          </a>
          <div class="clear"></div>
          <a href="browse.jsp">
            Browse
          </a>
        </div>
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
    
    <h2>Edit Guest</h2>
    
    <%
     String name = request.getParameter("propername");
     int id = Integer.parseInt( request.getParameter( "id" ) );
     Database conn = (Database)session.getAttribute("connection");
     Guest newGuest = Guest.validate( request );
     
    if ( newGuest != null ) {
      boolean update = conn.changeGuest( newGuest );
      
      if ( !update ) {
    %>
      <div class="error">
        The guest <%= name %> was not changed.
      </div>
    <% } else { %>
      <div class="message">
        The guest <%= name %> has been changed.
      </div>
    <% } 
    }
    else if ( name != null )
    { %>
      <div class="message">
        The guest <%= name %> has not been changed.
      </div>
      <div class="message">
        Please make sure the following fields are filled before adding:
        <ul>
          <li><a href="#proper">Proper Name</a> - the full,formal name of the guest.</li>
          <!--<li><a href="#innername">Inner Envelope Name</a> - the guest's name, as it appears on an inside envelope.</li>-->
          <li><a href="#address1">Address/Full Address (Line 1)</a> - the first line of the guest's address.</li>
          <li><a href="#city">Address/City</a> - the guest's resident city.</li>
          <li><a href="#state">Address/State</a> - the guest's resident state.</li>
          <li><a href="#zip">Address/Zip Code</a> - the guest's resident zip code.</li>
          <li><a href="#minorattend">Under 18 Attending</a> - the number of minors that will attend with the invitee.</li>
        </ul>
      </div>
    <% }
     Guest theGuest = conn.getGuest( id );
     
    if ( theGuest == null ) { %>
    
    <div class="error">
        There is no guest with an ID of <%= id %>.
    </div>
    
    <% } else {
       String strTmp;
       int intTmp;
       java.sql.Date dateTmp;
       java.sql.Time timeTmp;
       
       java.text.NumberFormat zipFormat = java.text.NumberFormat.getInstance();
       zipFormat.setMaximumIntegerDigits( 5 );
       zipFormat.setMinimumIntegerDigits( 5 );
       zipFormat.setMaximumFractionDigits( 0 );
       zipFormat.setMinimumFractionDigits( 0 );
       zipFormat.setGroupingUsed(false);
       java.text.NumberFormat zip4Format = java.text.NumberFormat.getInstance();
       zip4Format.setMaximumIntegerDigits( 4 );
       zip4Format.setMinimumIntegerDigits( 4 );
       zip4Format.setMaximumFractionDigits( 0 );
       zip4Format.setMinimumFractionDigits( 0 );
       zip4Format.setGroupingUsed(false);
       java.text.SimpleDateFormat dateOutput = new java.text.SimpleDateFormat( "MM/dd/yyyy" );
       java.text.SimpleDateFormat timeOutput = new java.text.SimpleDateFormat( "h:mm a" );
    %>
    
    <form action="edit.jsp" method="post">
      <div class="controls">
          <input type="reset" value="Clear"/>
          <input type="submit" value="Save"/>
      </div>
      <input type="hidden" name="id" value="<%= theGuest.getId() %>"/>
      <div class="halfwidth">
        <div class="TeenyBorder">
          <div>
            <b>Guest</b>
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Invited By:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<select name="hostid">
              <%
               java.util.Vector allHosts = conn.getAllHosts();
               for ( int hIndex = 0; hIndex < allHosts.size(); hIndex++ )
               {
                 Host theHost = (Host)allHosts.get( hIndex );
                 %>
                <option value="<%= theHost.getId() %>" <%= ( (theGuest.getInvitedBy() == theHost.getId()) ? "selected" : "" ) %>>
                  <%= theHost.getFullName() %>
                </option>
              <% } %>
            </select>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="proper">Proper Name:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getTitle(); %>
            &nbsp;<select name="title">
              <option value="Dr." label="Dr." <%= ( strTmp.equals(("Dr.")) ? "selected" : "" ) %>>Dr.</option>
              <option value="Mrs." label="Mrs." <%= ( strTmp.equals(("Mrs.")) ? "selected" : "" ) %>>Mrs.</option>
              <option value="Ms." label="Ms." <%= ( strTmp.equals(("Ms.")) ? "selected" : "" ) %>>Ms.</option>
              <option value="Mr." label="Mr." <%= ( strTmp.equals(("Mr.")) ? "selected" : "" ) %>>Mr.</option>
            </select>
            <% strTmp = theGuest.getProperName(); %>
            <input type="text" name="propername" value="<%= strTmp %>" class="required"/>
          </div>
          <!--
          <div class="floatleft halfwidth" style="text-align:right;">
            Inner Name:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getInnerEnvelopeName(); %>
            &nbsp;<input type="text" name="innername" value="<%= strTmp %>"/>
          </div>
          -->
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Significant Other:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getSigOtherTitle(); %>
            &nbsp;<select name="sigothertitle">
              <option value="Dr." label="Dr." <%= ( strTmp.equals(("Dr.")) ? "selected" : "" ) %>>Dr.</option>
              <option value="Mrs." label="Mrs." <%= ( strTmp.equals(("Mrs.")) ? "selected" : "" ) %>>Mrs.</option>
              <option value="Ms." label="Ms." <%= ( strTmp.equals(("Ms.")) ? "selected" : "" ) %>>Ms.</option>
              <option value="Mr." label="Mr." <%= ( strTmp.equals(("Mr.")) ? "selected" : "" ) %>>Mr.</option>
            </select>
            <% strTmp = theGuest.getSigOtherProperName(); %>
            <input type="text" name="sigotherpropername" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <!--
          <div class="floatleft halfwidth" style="text-align:right;">
            Inner Name:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getSigOtherInnerEnvelopeName(); %>
            &nbsp;<input type="text" name="sigotherinnername" value="<%= strTmp %>"/>
          </div>
          -->
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div>
            <b>Address</b>
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="address1">Full Address (Line 1):</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getAddress1(); %>
            &nbsp;<input type="text" name="address1" value="<%= strTmp %>" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Full Address (Line 2):&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getAddress2(); %>
            &nbsp;<input type="text" name="address2" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="outercity">City:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getCity(); %>
            &nbsp;<input type="text" name="city" value="<%= strTmp %>" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="outerstate">State:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getState(); %>
            &nbsp;<input type="text" name="state" value="<%= strTmp %>" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="outerzip">Zipcode:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% intTmp = theGuest.getZip(); %>
            &nbsp;<input type="text" name="zip" value="<%= zipFormat.format( intTmp ) %>" class="required shortinput"/>
            -
            <% intTmp = theGuest.getZipFour(); %>
            <input type="text" name="zip4" value="<%= ( (intTmp == 0)? "" : zip4Format.format( intTmp ) ) %>" class="shortinput"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="controls">
           <input type="reset" value="Clear"/>
          <input type="submit" value="Save"/>
        </div>
        <div class="TeenyBorder">
          <div>
            <b>Under 18 Invitees</b>
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 1:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getUnderEighteen1(); %>
            &nbsp;<input type="text" name="minor1" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 2:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getUnderEighteen2(); %>
            &nbsp;<input type="text" name="minor2" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 3:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getUnderEighteen3(); %>
            &nbsp;<input type="text" name="minor3" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 4:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getUnderEighteen4(); %>
            &nbsp;<input type="text" name="minor4" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="minorattend">Number of Under 18 Attending</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% intTmp = theGuest.getUnderEighteenAttending(); %>
            &nbsp;<input type="text" name="minorAttend" value="<%= intTmp %>" class="required"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Telephone:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getTelephone(); %>
            &nbsp;<input type="text" name="phone" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Email:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getEmail(); %>
            &nbsp;<input type="text" name="email" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Save The Date Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="saveTheDate" value="true" <%= ( theGuest.getSaveTheDateSent() ? "checked=\"true\"" : "" ) %>/>&nbsp;Yes
            &nbsp;<input type="radio" name="saveTheDate" value="false"<%= ( theGuest.getSaveTheDateSent() ? "" : "checked=\"true\"" ) %>/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Invitation Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="inviteSent" value="true" <%= ( theGuest.getInvitationSent() ? "checked=\"true\"" : "" ) %>/>&nbsp;Yes
            &nbsp;<input type="radio" name="inviteSent" value="false" <%= ( theGuest.getInvitationSent() ? "" : "checked=\"true\"" ) %>/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Replied To Invitation:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="hasreplied" value="true" <%= ( theGuest.getHasReplied() ? "checked=\"true\"" : "" ) %>/>&nbsp;Yes
            &nbsp;<input type="radio" name="hasreplied" value="false" <%= ( theGuest.getHasReplied() ? "" : "checked=\"true\"" ) %>/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Reply&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="reply" value="true" <%= ( theGuest.getReply() ? "checked=\"true\"" : "" ) %>/>&nbsp;With Pleasure
            &nbsp;<input type="radio" name="reply" value="false" <%= ( theGuest.getReply() ? "" : "checked=\"true\"" ) %>/>&nbsp;With Regret
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Date Arriving:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% dateTmp = theGuest.getArrivalDate(); %>
            &nbsp;<input type="text" name="arrivalDate" value="<%= ( (dateTmp == null) ? "" : dateOutput.format( dateTmp ) ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Time Arriving:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% timeTmp = theGuest.getArrivalTime(); %>
            &nbsp;<input type="text" name="arrivalTime" value="<%= ( (timeTmp == null) ? "" : timeOutput.format( timeTmp ) ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Date Departing:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% dateTmp = theGuest.getDepartureDate(); %>
            &nbsp;<input type="text" name="departureDate" value="<%= ( (dateTmp == null) ? "" : dateOutput.format( dateTmp ) ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Time Departing:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% timeTmp = theGuest.getDepartureTime(); %>
            &nbsp;<input type="text" name="departureTime" value="<%= ( (timeTmp == null) ? "" : timeOutput.format( timeTmp ) ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Lodging:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getLodging(); %>
            &nbsp;<input type="text" name="lodging" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Transportation:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getTravelType(); %>
            &nbsp;<input type="text" name="transport" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Destination:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getTravelDestination(); %>
            &nbsp;<input type="text" name="desination" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Gift Source:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getGiftSource(); %>
            &nbsp;<input type="text" name="giftSource" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Gift Description:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            <% strTmp = theGuest.getGiftItem(); %>
            &nbsp;<input type="text" name="giftDescription" value="<%= ( (strTmp == null) ? "" : strTmp ) %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Thank You Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="thankYou" value="true" <%= ( theGuest.getThankYou() ? "checked=\"true\"" : "" ) %>/>&nbsp;Yes
            &nbsp;<input type="radio" name="thankYou" value="false" <%= ( theGuest.getThankYou() ? "" : "checked=\"true\"" ) %>/>&nbsp;No
          </div>
          <div class="clear">&nbsp;</div>
        </div>
      </div>
      <div class="controls">
          <input type="reset" value="Clear"/>
          <input type="submit" value="Save"/>
      </div>
    </form>
    
    <% } %>
    
  </body>
</html>
