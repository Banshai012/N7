<%@ page language="java" import="pack.*, java.util.*"
  contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>

<html>
    <body>
        <form action="http://localhost:8080/hello/Serv" method="get">
            <input type="text" name="nb1">
            <br>
            <input type="text" name="nb2">
            <br>
            <input type="submit" value="Calculer la somme">
        </form>
    <% if (request.getParameter("nb1") != null && request.getParameter("nb2") != null) { %>
            <% Integer nb1 = Integer.parseInt(request.getParameter("nb1")); %>
            <% Integer nb2 = Integer.parseInt(request.getParameter("nb2")); %>
            <% Integer sum = (Integer) request.getAttribute("sum"); %>
            <p>La somme de <%= nb1 %> et <%= nb2 %> = <%= sum %></p>
        <% } %>
    </body>
</html>