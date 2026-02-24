import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

@Path("/")
public interface ServiceInterface {

    @GET
    @Path("/getstudent")
    @Produces({ "application/json" })
    public Student getStudent( @QueryParam("firstname") String firstname, @QueryParam("lastname")    String lastname)   ;

    @GET
    @Path("/getrecord")
    @Produces({ "application/json" })
    public Record getRecord(@QueryParam("ine") String ine);

    @GET
    @Path("/getmark")
    @Produces({ "application/json" })
    public int getMark(@QueryParam("firstname") String firstname, @QueryParam("lastname") String lastname, @QueryParam("lecture") String lecture);
}