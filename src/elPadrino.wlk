// A - Saber si un mafioso esta muerto
//      mafioso.duermeConLosPeces()
// B - familia.integranteMasPeligroso()
// 
// C - mafioso.atacarFamilia(familia)
//
// D - familia.realizarLuto()
//


class Arma {

 var property estaEnCondicion = true
 
 method agredir(enemigo)

 method peligrosidad(){
     if(not self.estaEnCondicion())
        {
            return 1
        }
     else
        {
            self.peligrosidadIndicada()
        }
}

class Revolver inherits Arma{

    const capacidad = 6
    var cantidadDeBalas = 0

    override method estaEnCondicion() = cantidadDeBalas > 0

    override method agredir(enemigo){
        enemigo.morir()
        self.descontarBalas()   
    }

    method recargar() { 
        cantidadDeBalas = 6
        }
    
    method descontarBalas(){
        cantidadDeBalas = cantidadDeBalas - 1
    }

    override method peligrosidadIndicada() = 2 * cantidadDeBalas


}

class Daga inherits Arma{

    var peligrosidadIndicada = 0

    override method agredir(mafioso) = mafioso.lastimar() 

    override method peligrosidadIndicada() = peligrosidadIndicada

}

class CuerdaDePiano inherits Arma{

    var property estaBienTensa = false
    override method estaEnCondicion() = self.estaBienTensa()

    override method agredir(enemigo){

        if(self.estaEnCondicion()){
            mafioso.morir()
        }
        else{
            mafioso.lastimar()
        }
    }

    override method peligrosidadIndicada() = 5



}

//FAMILIA

class Familia{

    var integrantes = #{} 

    method integranteMasPeligroso() =
         self.integrantesVivos().max({unIntegrante => unIntegrante.nivelDeIntimidacion()})
    
    method integrantesVivos() = integrantes.filter({unIntegrante => ! unIntegrante.duermeConLosPeces()})

    method realizarLuto()
    {
        if(not self.elDonEstaVivo()){
            throw new DomainException(message = "No se puede realizar luto, el don esta vivo")
        }
      
         integrantes.recategorizarIntegrantes()
         integrantes.acondicionarArmas()
         integrantes.nombrarNuevoDon()
    }







}   

//MAFIOSO
class Mafioso {

    var rango
    var cantidadDeHeridas = 0
    var armas = []
    var muerto = false

    //Punto A

    method morir(){
        muerto = true
    }

    method lastimar(){
         cantidadDeHeridas = cantidadDeHeridas + 1
    }

    method estaMuerto() = cantidadDeHeridas > 3

    method duermeConLosPeces() = self.estaMuerto() || muerto

    //Punto B
    
    method nivelDeIntimidacion() = 
        rango.bonusDeIntimidacion(self. peligrosidadTotalDeArmas())
        
    method peligrosidadTotalDeArmas() = armas.sum({unArma => unArma.peligrosidad()})
    
    //Punto C

    method hacerSuTrabajo(familia) = rango.atacar(familia.integranteMasPeligroso() , self)

    method desarmar(){
            armas = [] 
    }

    method unArmaEnCondicion() = armas.anyOne({unArma => unArma.estaEnCondicion()})

    method usarArmaEnCondicion(enemigo) = armas.find({unArma => unArma.estaEnCondicion()}).agredir(enemigo)    

    method usarCualquierArma(enemigo) = self.armasNoEnCondicion().agredir(enemigo)

    method armasNoEnCondicion() = armas.find(unArma =>! unArma.estaEnCondicion())

    method usarPrimerArma(enemigo) = armas.first().agredir(enemigo)

    //Punto D



}

object don {

    method bonusDeIntimidacion(peligrosidad) = peligrosidad + 20

    method atacar(enemigo , mafioso) = enemigo.desarmar()

}

class Subjefe {

    method bonusDeIntimidacion(peligrosidad) = 2 * peligrosidad 

    method atacar(enemigo,mafioso){
        
        if(mafioso.unArmaEnCondicion()){
            mafioso.usarArmaEnCondicion(enemigo)
        }
        else{
            mafioso.usarCualquierArma(enemigo)
        }
        

}

class Soldado {

    method bonusDeIntimidacion(peligrosidad) = peligrosidad

    method atacar(enemigo , mafioso) = mafioso.usarPrimerArma(enemigo)

}