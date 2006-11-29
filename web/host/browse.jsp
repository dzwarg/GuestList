<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Browse Hosts</title>
    <link rel="stylesheet" type="text/css" href="../styles/default.css"/>
  </head>
  <body>
    <%
     Database conn = (Database)session.getAttribute("connection");
     boolean hostLock = conn.getLock( "hostlist" );
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
        <% if ( !hostLock ) { %>
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
    
    <h2>Browse Hosts</h2>
    
    <div class="MainSectionBorder">
      <%
        java.util.Vector hosts = conn.getAllHosts();
        java.util.Collections.sort( hosts );
        for ( int index = 0; index < hosts.size(); index++ ) {
          Host h = (Host)hosts.get( index );
      %>
      <div class="hostname" style="background-color:<%= h.getColor() %>">
        <div class="clear">&nbsp;</div>
        <% 
          if ( !hostLock ) { %>
          <a href="edit.jsp?id=<%= h.getId() %>">
        <% } %>
          <%= h.getFullName() %>
        <% if ( !hostLock ) { %></a><% } %>
        <div class="thirdwidth">
          <div class="floatleft thirdwidth" style="text-align: right;">
            Login:&nbsp;
          </div>
          <div class="floatleft halfwidth">
            &nbsp;<%= h.getUserName() %>
          </div>
        </div>
        <% if ( !hostLock ) { %>
        <div class="floatright thirdwidth" style="background-color:<%= h.getColor() %> height: 100%;">
          <a href="delete.jsp?id=<%= h.getId() %>">
            <img src="../images/delete.png" alt="Delete" class="linkbutton" />
          </a>
        </div>
        <% } %>
        <div class="clear">&nbsp;</div>
      </div>
      <% } %>
    </div>
    
  </body>
</html>
