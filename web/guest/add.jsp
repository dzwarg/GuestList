<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Add Guest</title>
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

    <h2>Add Guest</h2>
        
    <%
     String name = request.getParameter("propername");
     Database conn = (Database)session.getAttribute("connection");
     Guest newGuest = Guest.validate( request );
     
    if ( newGuest != null ) {
      Guest theGuest = conn.addGuest( newGuest );
      
      if ( theGuest == null ) {
    %>
      <div class="error">
        The guest <%= name %> was not added.
      </div>
    <% } else { %>
      <div class="message">
        The guest <%= name %> has been added.
      </div>
    <% } } else { %>
      <div class="message">
        Please make sure the following fields are filled before adding:
        <ul>
          <li><a href="#propername">Proper Name</a> - the full, formal name of the guest.</li>
          <!--<li><a href="#innername">Inner Envelope Name</a> - the guest's name, as it appears on an inside envelope.</li>-->
          <li><a href="#address1">Address/Full Address (Line 1)</a> - the first line of the guest's address.</li>
          <li><a href="#city">Address/City</a> - the guest's resident city.</li>
          <li><a href="#state">Address/State</a> - the guest's resident state.</li>
          <li><a href="#zip">Address/Zip Code</a> - the guest's resident zip code.</li>
          <li><a href="#minorattend">Under 18 Attending</a> - the number of minors that will attend with the invitee.</li>
        </ul>
      </div>
    <% } %>

    <form action="add.jsp" method="post">
      <input type="hidden" name="hostid" value="<%= authHost.getId() %>"/>
      <div class="controls">
          <input type="reset" value="Clear"/>
          <input type="submit" value="Save"/>
      </div>
      <div class="halfwidth">
        <div class="TeenyBorder">
          <div>
            <b>Guest</b>
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="propername">Guest Name:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<select name="title">
              <option value="Dr." label="Dr.">Dr.</option>
              <option value="Mrs." label="Mrs.">Mrs.</option>
              <option value="Ms." label="Ms.">Ms.</option>
              <option value="Mr." label="Mr.">Mr.</option>
            </select>
            <input type="text" name="propername" class="required"/>
          </div>
          <!--
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="innername">Inner Name:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="innername" class="required"/>
          </div>
          -->
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Significant Other:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<select name="sigothertitle">
              <option value="Dr." label="Dr.">Dr.</option>
              <option value="Mrs." label="Mrs.">Mrs.</option>
              <option value="Ms." label="Ms.">Ms.</option>
              <option value="Mr." label="Mr.">Mr.</option>
            </select>
            <input type="text" name="sigotherpropername"/>
          </div>
          <!--
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Inner Name:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="sigotherinnername"/>
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
            &nbsp;<input type="text" name="address1" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Full Address (Line 2):&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="address2"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="city">City:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="city" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="state">State:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="state" class="required"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="zip">Zipcode:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="zip" class="required shortinput"/>
            -
            <input type="text" name="zip4" class="shortinput"/>
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
            &nbsp;<input type="text" name="minor1"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 2:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="minor2"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 3:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="minor3"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Minor 4:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="minor4"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            <a name="minorattend">Number of Under 18 Attending:</a>&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="minorAttend" class="required" value="0"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Telephone:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="phone"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Email:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="email"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Save The Date Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="saveTheDate" value="true"/>&nbsp;Yes
            &nbsp;<input type="radio" name="saveTheDate" value="false"/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Invitation Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="inviteSent" value="true"/>&nbsp;Yes
            &nbsp;<input type="radio" name="inviteSent" value="false"/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Replied To Invitation:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="hasreplied" value="true"/>&nbsp;Yes
            &nbsp;<input type="radio" name="hasreplied" value="false"/>&nbsp;No
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Reply&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="reply" value="true"/>&nbsp;With Pleasure
            &nbsp;<input type="radio" name="reply" value="false"/>&nbsp;With Regret
          </div>
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Date Arriving:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="arriveDate"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Time Arriving:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="arriveTime"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Date Departing:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="departDate"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Time Departing:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="departTime"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Lodging:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="lodging"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Transportation:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="transport"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Destination:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="desination"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Gift Source:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="giftSource"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Gift Description:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="giftDescription"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Thank You Sent:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="radio" name="thankYou" value="true"/>&nbsp;Yes
            &nbsp;<input type="radio" name="thankYou" value="false"/>&nbsp;No
          </div>
          <div class="clear">&nbsp;</div>
        </div>
      </div>
      <div class="controls">
          <input type="reset" value="Clear"/>
          <input type="submit" value="Save"/>
      </div>
    </form>
    
  </body>
</html>
