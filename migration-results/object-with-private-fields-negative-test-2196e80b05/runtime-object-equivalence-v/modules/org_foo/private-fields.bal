public class user {
    public int age = 0;
    public string name = "";
    public string address = "";
    public string zipcode = "23468";
}

public function newUser() returns user {
    user u = new;
    u.age = 56;
    u.name = "mal";
    u.zipcode = "23126";
    return u;
}
