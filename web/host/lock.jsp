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
    <title>Lock Host List</title>
    <link type="text/css" rel="stylesheet" href="../styles/default.css"/>
  </head>
  <body>
    <%
     Object lockParam = request.getParameter("lock");
     Database conn = (Database)session.getAttribute("connection");
     boolean update = false;
     boolean lockState = false;
     if ( lockParam != null )
     {
       lockState = Boolean.valueOf( lockParam.toString() ).booleanValue();
       update = conn.setLock( "hostlist", lockState );
     }
     
     boolean locked = conn.getLock( "hostlist" );
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
        <% if ( !locked ) { %>
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
          <a href="browse.jsp">
            <img src="../images/browse.png" alt="Browse"/>
          </a>
          <div class="clear"></div>
          <a href="browse.jsp">
            Browse
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
    
    <h2>Lock Host List</h2>    

    <% if ( lockParam != null && !update ) { %>
        <div id="error">
           The Host table cannot be <% if ( !lockState ) out.print( "un" ); %>locked.
        </div>
    <% } else if ( lockParam != null ) { %>
        <div id="message">
            The Host table has been <% if ( !lockState ) out.print( "un" ); %>locked.
        </div>
    <% } %>
    
    <form action="lock.jsp" method="post">
      <div class="thirdwidth">
        <div class="TeenyBorder centeredIE">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth">
            <img src="../images/locked.png" alt="Lock"/>
            <div class="clear"></div>
            <input type="radio" name="lock" value="true" <% if ( locked ) out.print( "checked" ); %> /> Lock
          </div>
          <div class="floatleft halfwidth">
            <img src="../images/unlock.png" alt="Unlock"/>
            <div class="clear"></div>
            <input type="radio" name="lock" value="false" <% if ( !locked ) out.print( "checked" ); %>/> Unlock
          </div>
          <div class="clear">&nbsp;</div>
        </div>
      </div>
      <div class="thirdwidth centeredIE">
          <input type="submit" value="Toggle Lock"/>
      </div>
    </form>
    
  </body>
</html>
