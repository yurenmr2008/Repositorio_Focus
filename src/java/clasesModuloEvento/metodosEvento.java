/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package clasesModuloEvento;

/**
 *
 * @author yuren
 */
public class metodosEvento {
    
    
    public String obtenerFormatoTiempo(int tiempoMilisegundos) {
        int segundos = 0;
        int minutos = 0;
        int horas = 0;
        int tiempoMostrado = 0;

        int digitosMinutos = 0;
        int digitosHoras = 0; 
        int digitosSegundos = 0;
        String espacioMinutos = "";
        String espacioHoras = "";
        String espacioSegundos = "";
        
        
        tiempoMostrado = tiempoMilisegundos/1000; //Elimina los milisegundos para solo mostrar el tiempo en horas, minutos y segundos
        System.out.println("tiempoMostrado:" + tiempoMostrado);
        horas = tiempoMostrado / 360;
        minutos = (tiempoMostrado % 360)/60;
        System.out.println("minutos:"+  minutos);
        segundos = tiempoMostrado % 60;

        digitosSegundos = String.valueOf(segundos).length();
        digitosMinutos = String.valueOf(minutos).length();
        digitosHoras = String.valueOf(horas).length(); 


        if(digitosSegundos  == 1){
            espacioSegundos = "0";
        }
        else{
            espacioSegundos = "";
        }

        if(digitosMinutos  == 1){
            espacioMinutos = "0";
        }
        else{
            espacioMinutos = "";
        }
        if(digitosHoras  == 1){
            espacioHoras = "0";
        }
        else{
            espacioHoras = "";
        }

        String tiempoEnFormato = espacioHoras+horas +":" +espacioMinutos+minutos+":"+espacioSegundos+segundos;
        
        return tiempoEnFormato;
    }
    
    
    
    
    
    
}
