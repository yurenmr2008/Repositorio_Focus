package panelProgreso;

public class Meta {
    private int idMet;
    private String nomMet;
    private String desMet;

    public Meta(int idMet, String nomMet, String desMet) {
        this.idMet = idMet;
        this.nomMet = nomMet;
        this.desMet = desMet;
    }

    public int getIdMet() { return idMet; }
    public String getNomMet() { return nomMet; }
    public String getDesMet() { return desMet; }
}
