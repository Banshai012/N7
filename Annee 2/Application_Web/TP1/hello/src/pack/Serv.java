package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String s1 = request.getParameter("nb1");
        String s2 = request.getParameter("nb2");
        Integer nb1 = Integer.parseInt(s1);
        Integer nb2 = Integer.parseInt(s2);
        Integer sum = nb1 + nb2;
        response.getWriter().println("<html><body>La somme de " + nb1 + " et " + nb2 + " = " + sum + "</body></html>");
        response.getWriter().println("<html><body>Hello World !</body></html>");
        request.setAttribute("sum", sum);
        request.getRequestDispatcher("Calc.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}