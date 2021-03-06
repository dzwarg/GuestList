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
    <title>Delete Guest</title>
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
    
    <h2>Delete Guest</h2>
    
    <%
     String strId = request.getParameter("id");
     String strReally = request.getParameter("really");
     Database conn = (Database)session.getAttribute("connection");
     boolean really = false;
     boolean deleted = false;
     if ( strId != null ) {
       int id = Integer.parseInt( strId );
       
       if ( strReally != null )
       {
         really = Boolean.valueOf( strReally ).booleanValue();
         
         if ( really )
         {
           deleted = conn.deleteGuest( id );
         }
       }
      if ( really ) { 
        if ( deleted ) {%>
        <div class="message">
            The guest has been deleted.
        </div>
      <% } else { %>
        <div class="error">
            The guest cannot be deleted.
        </div>
      <% } } else {
         Guest theGuest = conn.getGuest( id );
       
         if ( theGuest == null ) { %>
          <div class="error">
            The guest cannot be deleted.
          </div>
       <% } else { %>
      <div>
        <span class="warning">
          Do you really want to delete the guest
          '<b><%= theGuest.getProperName() %></b>'?
        </span>
      </div>
      
      <div class="controls">
        <form action="delete.jsp" method="post">
          <input type="hidden" name="really" value="true"/>
          <input type="hidden" name="id" value="<%= theGuest.getId() %>" />
          <input type="button" value="No" onclick="javascript:window.back();"/>
          <input type="submit" value="Yes"/>
        </form>
      </div>
     
    <% } } } else { %>
      <div class="error">
        Delete what?
      </div>
    <% } %>
    
  </body>
</html>
