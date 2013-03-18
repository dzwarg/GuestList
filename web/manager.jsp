<%--
    Copyright (c) 2013 David Zwarg <david.zwarg@gmail.com>
    See LICENSE in the project root for copying permission.
--%>
<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Guest List Manager</title>
    <link rel="stylesheet" type="text/css" href="styles/default.css"/>
  </head>
<body>

<h2>Welcome to the Guest List Manager</h2>

<div class="floatright centeredIE">
  <a href="logout.jsp"><img src="images/logout.png" alt="Logout" class="linkbutton"></a>
  <br/>
  <a href="logout.jsp">
    Logout
  </a>
</div>

<%
  Database conn = (Database)session.getAttribute("connection");
%>
<div>
    <h3>Guests</h3>
    <div class="MainSectionBorder" style="height: 40px; width: 40%;">
      <% if ( !conn.getLock( "guestlist" ) ) { %>
      <div class="floatleft centeredIE thirdwidth">
        <a href="guest/add.jsp"><img src="images/add.png" alt="Add" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="guest/add.jsp">
          Add
        </a>
      </div>
      <% } %>
      <div class="floatleft centeredIE thirdwidth">
        <a href="guest/browse.jsp"><img src="images/browse.png" alt="Browse" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="guest/browse.jsp">
          Browse
        </a>
      </div>
      <div class="floatleft centeredIE thirdwidth">
        <a href="guest/lock.jsp"><img src="images/locked.png" alt="Lock" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="guest/lock.jsp">
          Lock
        </a>
      </div>
    </div>
</div>

<div id="hostdiv">
    <h3>Hosts</h3>
    <div class="MainSectionBorder" style="height: 40px; width: 40%;">
      <% if ( !conn.getLock( "hostlist" ) ) { %>
      <div class="floatleft centeredIE thirdwidth">
        <a href="host/add.jsp"><img src="images/add.png" alt="Add" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="host/add.jsp">
          Add
        </a>
      </div>

      <% } %>
      <div class="floatleft centeredIE thirdwidth">
        <a href="host/browse.jsp"><img src="images/browse.png" alt="Browse" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="host/browse.jsp">
          Browse
        </a>
      </div>
      <div class="floatleft centeredIE thirdwidth">
        <a href="host/lock.jsp"><img src="images/locked.png" alt="Lock" class="linkbutton"/></a>
        <div class="clear"></div>
        <a href="host/lock.jsp">
          Lock
        </a>
      </div>
    </div>
</div>

</body>
</html>
