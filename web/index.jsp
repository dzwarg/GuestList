<%--
    Copyright (c) 2013 David Zwarg <david.zwarg@gmail.com>
    See LICENSE in the project root for copying permission.
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <link rel="stylesheet" type="text/css" href="styles/default.css"/>
    </head>
    <body onload="document.forms[0].elements[0].focus();">

    <h1>Login</h1>
   
    <% if ( request.getParameter( "user" ) != null ) { %>

    <%@include file="WEB-INF/jspf/login.jspf" %>
    
    <% if ( session.getAttribute( "host" ) != null ) {
        response.sendRedirect( "manager.jsp" );
    } else { %>
    
    <div id="message">
      <h3>Sorry.</h3>
      <p>
        The combination:
        "<b><%= request.getParameter( "user" ) %></b>",
        "<b><%= request.getParameter( "pass" ) %></b>"
        was not recognized as a valid login.  Please try again.
    </div>

    <% } } %>
    
    <form action="." method="post">
        <div class="halfwidth">
            <img src="images/login.png" alt="Login" class="floatright">
            Username:
            <input type="text" name="user" value=""/>
            <br/>
            Password:
            <input type="password" name="pass" value=""/>
            <div class="clear">&nbsp;</div>
            <input type="reset" value="Cancel"/>
            <input type="submit" value="Login"/>
        </div>
    </form>
    
    </body>
</html>
