<%@page import="com.zwarg.guestlist.data.*"%>
<%@include file="../WEB-INF/jspf/authorize.jspf"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>Edit Host</title>
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
    
    <h2>Edit Host</h2>
    
    <%
     String strId = request.getParameter("id");
     int id = Integer.parseInt( strId );
     String fullname = request.getParameter("fullname");
     String color = request.getParameter("color");
     String user = request.getParameter("username");
     String password = request.getParameter("password");
     Database conn = (Database)session.getAttribute("connection");
     
    if ( id >= 0 &&
         fullname != null && fullname.length() > 0 &&
         color != null && color.length() > 0 &&
         user != null && user.length() > 0 &&
         password != null && password.length() > 0 ) {
      boolean update = conn.changeHost( id, fullname, color, user, password );
      
      if ( !update ) {
    %>
      <div class="error">
        The host <%= request.getParameter( "fullname" ) %> was not changed.
      </div>
    <% } else { %>
      <div class="message">
        The host <%= request.getParameter( "fullname" ) %> has been changed.
      </div>
    <% } 
    } 
     Host theHost = conn.getHost( id );
     
    if ( theHost == null ) { %>
    
    <div class="error">
        There is no host with an ID of <%= id %>.
    </div>
    
    <% } else {  %>
    
    <form action="edit.jsp" method="post">
      <input type="hidden" name="id" value="<%= theHost.getId() %>" />
      <div class="halfwidth">
        <div class="TeenyBorder">
          <div class="clear">&nbsp;</div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Name:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="fullname" value="<%= theHost.getFullName() %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Color:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="color" value="<%= theHost.getColor() %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Login:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="text" name="username" value="<%= theHost.getUserName() %>"/>
          </div>
          <div class="clear"></div>
          <div class="floatleft halfwidth" style="text-align:right;">
            Password:&nbsp;</div>
          <div class="floatleft halfwidth">
            &nbsp;<input type="password" name="password" value="<%= theHost.getPassword() %>"/>
          </div>
          <div class="clear">&nbsp;</div>
        </div>
        <div class="controls">
            <input type="reset" value="Clear"/>
            <input type="submit" value="Edit"/>
        </div>
      </div>
    </form>
    
    <% } %>
    
  </body>
</html>
