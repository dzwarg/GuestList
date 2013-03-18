<%--
    Copyright (c) 2013 David Zwarg <david.zwarg@gmail.com>
    See LICENSE in the project root for copying permission.
--%>
<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Add Host</title>
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

    <h2>Add Host</h2>
    
    <%
     Database conn = (Database)session.getAttribute("connection");
     Host newHost = Host.validate( request );
     
     if ( newHost != null ) {
       Host theHost = conn.addHost( newHost );
      
       if ( theHost == null ) {
    %>
      <div class="error">
        The host <%= request.getParameter( "fullname" ) %> was not added.
      </div>
    <% } else { %>
      <div class="message">
        The host <%= request.getParameter( "fullname" ) %> has been added.
      </div>
    <% } } %>
    
    <form action="add.jsp" method="post">
      <div class="halfwidth">
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Name:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="fullname"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Color:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="color"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Login:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="username"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Password:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="password" name="password"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="controls">
            <input type="reset" value="Clear"/>
            <input type="submit" value="Add"/>
        </div>
      </div>
    </form>
    
  </body>
</html>
