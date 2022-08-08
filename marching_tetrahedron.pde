String veldix = "- Vélocité de 10"; //texte boutons
String velvingt = "- Vélocité de 20";
String veltrentecinq = "- Vélocité de 35";
String velcinquante = "- Vélocité de 50";

String radcinquante = "- Radiant de 50";
String radsoixantequinze = "- Radiant de 75";
String radcent = "- Radiant de 100";
String radcentcinquante = "- Radiant de 150";

//initialisation des marqueurs
int velY = 60;
float vel = 20; //velocite

int radY = 100;
float radius = 150; //sphere

final int rez = 30; //resolution
final int N = 10; //nombres particules
final int REC_INTERP = 5; //nombre d'appels recurcif 

float[][][] field;
int cols, rows, layers;
ImplicitParticles particles;

boolean DEBUG = false; //creation de spheres

float f(float d) {
  return (d < 1) ? 8.0*pow(1 - d*d,2)/9 : 0;
}

void setup() {
  size(700, 700, P3D);
  particles = new ImplicitParticles();
  cols = 1 + width / rez;
  rows = 1 + height / rez;
  layers = 1 + width / rez;
  field = new float[cols][rows][layers];
}

//triangle de rendu (si un unique point d'une couleur differente du reste)
void triangl(PVector v1, PVector v2, PVector v3) {
  beginShape();
  vertex(v1.x, v1.y, v1.z);
  vertex(v2.x, v2.y, v2.z);
  vertex(v3.x, v3.y, v3.z);
  endShape();
}

//polygone de rendu (si deux points d'une couleur differente du reste)
void poly(PVector v1, PVector v2, PVector v3, PVector v4) {
  beginShape();
  vertex(v1.x, v1.y, v1.z);
  vertex(v2.x, v2.y, v2.z);
  vertex(v3.x, v3.y, v3.z);
  endShape();
  beginShape();
  vertex(v1.x, v1.y, v1.z);
  vertex(v4.x, v4.y, v4.z);
  vertex(v3.x, v3.y, v3.z);
  endShape();
}

void draw() {
  background(0); 
  
  //affichage des textes boutons
  textSize(20);
  text("Valeur de la vélocité :", 5, 20); 
  text(veldix, 5, 40);
  text(velvingt, 5, 60);
  text(veltrentecinq, 5, 80);
  text(velcinquante, 5, 100);
  
  text("Valeur du radiant :", 540, 20); 
  text(radcinquante, 550, 40);
  text(radsoixantequinze, 550, 60);
  text(radcent, 550, 80);
  text(radcentcinquante, 550, 100);
  
  //marqueurs
  fill(255, 0, 0);
  text("< ", 140, velY);
  fill(255, 0, 0);
  text("> ", 535, radY);
  
  //bouton labels
  if (mouseY >= 20 && mouseY <= 40){
    // velocite de 10
    if (mouseX >= 0 && mouseX <= 130){
      fill(255,0,0);
      text(veldix, 5, 40);
      if (mousePressed) {
        velY = 40;
        vel = 10;
      }
    }
    // radiant de 50
    if (mouseX >= 550 && mouseX <= 700){
      fill(255,0,0);
      text(radcinquante, 550, 40);
      if (mousePressed) {
        radY = 40;
        radius = 50;
      }
    }
  }
  

  if (mouseY >= 40 && mouseY <= 60){
    // velocite de 20
    if (mouseX >= 0 && mouseX <= 130){
      fill(255,0,0);
      text(velvingt, 5, 60);
      if (mousePressed) {
        velY = 60;
        vel = 20;
      }
    }
    // radiant de 50
    if (mouseX >= 550 && mouseX <= 700){
      fill(255,0,0);
      text(radsoixantequinze, 550, 60);
      if (mousePressed) {
        radY = 60;
        radius = 75;
      }
    }
  }
  

  if (mouseY >= 60 && mouseY <= 80){
    // velocite de 35
    if (mouseX >= 0 && mouseX <= 130){
      fill(255,0,0);
      text(veltrentecinq, 5, 80);
      if (mousePressed) {
        velY = 80;
        vel = 35;
      }
    } 
    // radiant de 100
    if (mouseX >= 550 && mouseX <= 700){
      fill(255,0,0);
      text(radcent, 550, 80);
      if (mousePressed) {
        radY = 80;
        radius = 100;
      }
    }
  }
  

  if (mouseY >= 80 && mouseY <= 100){
    // velocite de 50
    if (mouseX >= 0 && mouseX <= 130){
      fill(255,0,0);
      text(velcinquante, 5, 100);
      if (mousePressed) {
        velY = 100;
        vel = 50;
      }
    }
    // radiant de 150
    if (mouseX >= 550 && mouseX <= 700){
      fill(255,0,0);
      text(radcentcinquante, 550, 100);
      if (mousePressed) {
        radY = 100;
        radius = 150;
      }
    }
  }
  
  translate(0, 0, -width );
  lights();
  
  //parcours de l'affichage
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      for (int k = 0; k < layers-1; k++){
        float x = i * rez;
        float y = j * rez;
        float z = k * rez;
        
        //creation des PVector d'arrete des tetraedres
        PVector de = particles.interp(x, y, z+rez, x, y+rez, z); //de
        PVector dh = particles.interp(x, y, z+rez, x, y+rez, z+rez); //dh
        PVector dc = particles.interp(x, y, z+rez, x+rez, y, z+rez); //dc
        PVector ec = particles.interp(x, y+rez, z, x+rez, y, z+rez); //ec
        PVector he = particles.interp(x, y+rez, z+rez, x, y+rez, z); //he
        PVector hc = particles.interp(x, y+rez, z+rez, x+rez, y, z+rez); //hc
        
        PVector ab = particles.interp(x, y, z, x+rez, y, z); //ab
        PVector bc = particles.interp(x+rez, y, z, x+rez, y, z+rez); //bc
        PVector ac = particles.interp(x, y, z, x+rez, y, z+rez); //ac
        PVector ae = particles.interp(x, y, z, x, y+rez, z); //ae
        PVector eb = particles.interp(x, y+rez, z, x+rez, y, z); //eb
        
        PVector da = particles.interp(x, y, z+rez, x, y, z); //da
        
        PVector hg = particles.interp(x, y+rez, z+rez, x+rez, y+rez, z+rez); //hg
        PVector cg = particles.interp(x+rez, y, z+rez, x+rez, y+rez, z+rez); //cg
        PVector ge = particles.interp(x+rez, y+rez, z+rez, x, y+rez, z); //ge
        
        PVector bf = particles.interp(x+rez, y, z, x+rez, y+rez, z); //bf
        PVector ef = particles.interp(x, y+rez, z, x+rez, y+rez, z); //ef
        PVector fc = particles.interp(x+rez, y+rez, z, x+rez, y, z+rez); //fc
        
        PVector fg = particles.interp(x+rez, y+rez, z, x+rez, y+rez, z+rez); //fg
        
        //evaluation des tetraedres
        int state1 = getState(  particles.evalInt(x, y+rez, z+rez), //cdeh
                               particles.evalInt(x, y+rez, z),
                               particles.evalInt(x, y, z+rez),
                               particles.evalInt(x+rez, y, z+rez));
                               
        int state2 = getState(  particles.evalInt(x, y+rez, z), //abce
                               particles.evalInt(x+rez, y, z+rez),
                               particles.evalInt(x+rez, y, z),
                               particles.evalInt(x, y, z));
                               
        int state3 = getState(  particles.evalInt(x, y+rez, z), //acde
                               particles.evalInt(x, y, z+rez),
                               particles.evalInt(x+rez, y, z+rez),
                               particles.evalInt(x, y, z));
        
        int state4 = getState(  particles.evalInt(x, y+rez, z+rez), //cegh
                               particles.evalInt(x+rez, y+rez, z+rez),
                               particles.evalInt(x, y+rez, z),
                               particles.evalInt(x+rez, y, z+rez));
                               
        int state5 = getState(  particles.evalInt(x+rez, y+rez, z), //bcef
                               particles.evalInt(x, y+rez, z),
                               particles.evalInt(x+rez, y, z+rez),
                               particles.evalInt(x+rez, y, z));
                               
        int state6 = getState(  particles.evalInt(x+rez, y+rez, z+rez), //cefg
                               particles.evalInt(x+rez, y+rez, z),
                               particles.evalInt(x, y+rez, z),
                               particles.evalInt(x+rez, y, z+rez));
                               
        fill(255);
        noStroke();
        
        //trace des triangles et polygones en fonction de l'etat du tetraedre
        switch (state1) { //cdeh
        case 1: //c different
        case 14:
          triangl(dc, ec, hc);
          break;
        case 2: //d different
        case 13:
          triangl(de, dh, dc);
          break;
        case 3: //cd different
        case 12:
          poly(dh, de, ec, hc);
          break;
        case 4: //e different
        case 11:
          triangl(de, ec, he);
          break;
        case 5: //ce different
        case 10:
          poly(dc, hc, he, de);
          break;
        case 6: //de different
        case 9:
          poly(he, dh, dc, ec);
          break;
        case 7:  //h different
        case 8:
          triangl(dh, he, hc);
          break;
        }
        
        switch (state2) { //abce
        case 1: //a different
        case 14:
          triangl(ab, ac, ae);
          break;
        case 2: //b different
        case 13:
          triangl(ab, bc, eb);
          break;
        case 3: //ab different
        case 12:
          poly(ae, ac, bc, eb);
          break;
        case 4: //c different
        case 11:
          triangl(bc, ac, ec);
          break;
        case 5: //ac different
        case 10:
          poly(ae, ab, bc, ec);
          break;
        case 6: //bc different
        case 9:
          poly(eb, ab, ac, ec);
          break;
        case 7:  //e different
        case 8:
          triangl(ae, eb, ec);
          break;
        }
        
        switch (state3) { //acde
        case 1: //a different
        case 14:
          triangl(da, ac, ae);
          break;
        case 2: //c different
        case 13:
          triangl(ac, ec, dc);
          break;
        case 3: //ac different
        case 12:
          poly(da, ae, ec, dc);
          break;
        case 4: //d different
        case 11:
          triangl(da, dc, de);
          break;
        case 5: //ad different
        case 10:
          poly(de, dc, ac, ae);
          break;
        case 6: //cd different
        case 9:
          poly(da, de, ec, ac);
          break;
        case 7:  //e different
        case 8:
          triangl(ec, ae, de);
          break;
        }
        
        switch (state4) { //cegh
        case 1: //c different
        case 14:
          triangl(cg, ec, hc);
          break;
        case 2: //e different
        case 13:
          triangl(he, ge, ec);
          break;
        case 3: //ce different
        case 12:
          poly(he, ge, cg, hc);
          break;
        case 4: //g different
        case 11:
          triangl(hg, cg, ge);
          break;
        case 5: //cg different
        case 10:
          poly(hg, ge, ec, hc);
          break;
        case 6: //eg different
        case 9:
          poly(hg, cg, ec, he);
          break;
        case 7:  //h different
        case 8:
          triangl(hg, he, hc);
          break;
        }
        
        switch (state5) { //bcef
        case 1: //b different
        case 14:
          triangl(bc, eb, bf);
          break;
        case 2: //c different
        case 13:
          triangl(bc, fc, ec);
          break;
        case 3: //bc different
        case 12:
          poly(bf, eb, ec, fc);
          break;
        case 4: //e different
        case 11:
          triangl(ef, eb, ec);
          break;
        case 5: //be different
        case 10:
          poly(ec, ef, bf, bc);
          break;
        case 6: //ce different
        case 9:
          poly(ef, eb, bc, fc);
          break;
        case 7:  //f different
        case 8:
          triangl(fc, ef, bf);
          break;
        }
        
        switch (state6) { //cefg
        case 1: //c different
        case 14:
          triangl(ec, fc, cg);
          break;
        case 2: //e different
        case 13:
          triangl(ge, ef, ec);
          break;
        case 3: //ce different
        case 12:
          poly(ge, ef, fc, cg);
          break;
        case 4: //f different
        case 11:
          triangl(fg, ef, fc);
          break;
        case 5: //cf different
        case 10:
          poly(fg, ef, ec, cg);
          break;
        case 6: //ef different
        case 9:
          poly(ge, ec, fc, fg);
          break;
        case 7:  //g different
        case 8:
          triangl(fg, ge, cg);
          break;
        }
      }
    }
  }
  if (DEBUG){
    particles.drawSphere();
  }
  
  particles.nextStep();
}

//a,b,c et d egal a 0 ou 1 selon la couleur (on trouve l'etat/ la configuration du voxel) pour dessiner la configuration de notre voxel
int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}
