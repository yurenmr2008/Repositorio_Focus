package panelProgreso;


public class Progreso {
    private String difCue;
    private String nomMat;
    private int idCal;
    private int cal;

    public Progreso(String difCue, String nomMat, int idCal, int cal) {
        this.difCue = difCue;
        this.nomMat = nomMat;
        this.idCal = idCal;
        this.cal = cal;
    }

    public String getDifCue() { return difCue; }
    public String getNomMat() { return nomMat; }
    public int getIdCal() { return idCal; }
    public int getCal() { return cal; }
}

