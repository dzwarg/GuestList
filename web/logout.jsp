<%--
    Copyright (c) 2013 David Zwarg <david.zwarg@gmail.com>
    See LICENSE in the project root for copying permission.
--%>
<%@page import="com.zwarg.guestlist.data.*"%>

<% 
  Database conn = (Database)session.getAttribute("connection");
  if ( conn != null )
    conn.disconnect();
  
  session.invalidate();
  response.sendRedirect( "index.jsp" );
%>