<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Collection, pack.Personne, pack.Adresse" %>

<html>
    <body>
            <% Collection<Personne> lp = (Collection<Personne>) request.getAttribute("lp"); %>
            <% Collection<Adresse> la; %>
            <% String s; %>
            <% for (Personne p : lp) {
                s = p.getNom() + " " + p.getPrenom(); %>
            <p style="padding-left: 15px;"><%= s %></p>
                <% la = p.getAdresses();
                for (Adresse a : la) {
                    s = a.getRue() + " " + a.getVille();
                    out.println(s); %>
                    <br>
                <% } %>
            <% } %>
    </body>
</html>