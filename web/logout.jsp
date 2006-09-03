<%@page import="com.zwarg.guestlist.data.*"%>

<% 
  Database conn = (Database)session.getAttribute("connection");
  if ( conn != null )
    conn.disconnect();
  
  session.invalidate();
  response.sendRedirect( "index.jsp" );
%>