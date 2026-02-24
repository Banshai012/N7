import javax.ws.rs.core.UriBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;

public class Test {
    public static void main(String[] args) {
        final String path = "http://localhost:8080/";
        ResteasyClient client = new ResteasyClientBuilder().build();
        ResteasyWebTarget target = client.target(UriBuilder.fromPath(path));
        ServiceInterface proxy = target.proxy(ServiceInterface.class);
        int resp;
        resp = proxy.getMark("Alain", "Tchana", "mathematics");
        System.out.println(resp);
        System.out.println();
    }
}