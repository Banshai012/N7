<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Collection, pack.Personne, pack.Adresse" %>

<html>
    <body>
        <form method="get" action="Serv">
            <% Collection<Personne> lp = (Collection<Personne>) request.getAttribute("lp"); %>
            <% Collection<Adresse> la = (Collection<Adresse>) request.getAttribute("la"); %>
            Choisir la personne :
            <% for (Personne p : lp) {
                int id = p.getId();
                String s = p.getNom() + " " + p.getPrenom(); %>
                <input type="radio" name="idp" value="<%=id %>">
                <%=s %> <br>
            <% } %>
            Choisir l'adresse :
            <% for (Adresse a : la) {
                int id = a.getId();
                String s = a.getRue() + " " + a.getVille(); %>
                <input type="radio" name="ida" value="<%=id %>">
                <%=s %> <br>
            <% } %>
            <input type="submit" value="OK">
            <input type="hidden" name="op" value="association">
        </form>
    </body>
</html>