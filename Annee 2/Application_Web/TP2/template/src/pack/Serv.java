package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {

    private Facade facade = new Facade();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String op = request.getParameter("op");
        switch (op) {
            case "ajoutpersonne":
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                facade.ajoutPersonne(nom, prenom);
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "ajoutadresse":
                String rue = request.getParameter("rue");
                String ville = request.getParameter("ville");
                facade.ajoutAdresse(rue, ville);
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "associer":
                request.setAttribute("lp", facade.listePersonnes());
                request.setAttribute("la", facade.listeAdresses());
                request.getRequestDispatcher("associer.jsp").forward(request, response);
                break;

            case "association":
                Integer idp = Integer.parseInt(request.getParameter("idp"));
                Integer ida = Integer.parseInt(request.getParameter("ida"));
                facade.associer(idp, ida);
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "lister":
                request.setAttribute("lp", facade.listePersonnes());
                request.getRequestDispatcher("lister.jsp").forward(request, response);

            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}