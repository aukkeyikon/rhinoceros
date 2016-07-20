int[][]masu=new int[6][14];//配列を準備
float iX, iY, total, dx, wind, bill, distance;
float A=0;
int hantei;
PImage building, gear,mohou;
void setup() {
  size(1100, 600);  
  strokeCap(PROJECT);
  textAlign(CENTER);
  textSize(20);
  syokika();
}
void syokika() {//初期化する関数
  for (int j=0; j<14; j++)//ここで繰り返し
    for (int i=0; i<6; i++) {//配列初期化
      iX=400;
      iY=height/2;
      total=0;
      dx=0;
      wind=0;
      bill=0;
      distance=0;
      hantei=0;
      masu[i][j]=0;
      masu[3][12]=3;
      masu[(int)random(1, 3)][(int)random(1, 11)]=1;
      masu[(int)random(4, 6)][(int)random(1, 11)]=1;
      masu[(int)random(1, 3)][(int)random(1, 11)]=0;
      masu[(int)random(4, 6)][(int)random(1, 11)]=0;
    }
}
void keyPressed() {
  if (keyCode==RIGHT)  wind+=0.05;//向かい風増加(ここで条件分岐)
  if (keyCode==LEFT)   wind-=0.05;//追い風増加
  if (keyCode==ENTER) syokika();//ENTERキーで初期化
}
void draw() {
  background(0);
  subscreen();//サブスクリーン描写
  dx=wind/3;
  drawpair(radians(A/37*17+240), iX, iY);//足を3セット用意
  drawpair(radians(A/37*17+120), iX, iY);
  drawpair(radians(A/37*17-5), iX, iY);
  husya(iX-60, iY-215, 100, -radians(A/7*47)*47);//風車を描写
  gear(iX-60, iY-215, 15, 2, 7, -radians(A/7*47));//歯車を描写
  gear(iX-8, iY-173, 60, 35, 47, radians(A));
  gear(iX+14, iY-99, 60, 35, 47, -radians(A/47*17));
  gear(iX-8, iY-173, 25, 7, 17, radians(A));
  gear(iX, iY, 47, 24, 37, radians(A/37*17));
  hukinagashi();
  textWhite("wind : "+nf(wind+bill, 0, 2)+"m/s", 750, 55);//小数点以下を四捨五入した風速
  A-=sqrt(dx*dx);//風の向きに関わらず風車の回転は一定方向
  if (wind+bill>=13||wind+bill<=-13) {//強風で機構が吹っ飛ぶ
    iY-=10;
    if (wind+bill>=13)iX+=30;
    else iX-=30;
    if (iX+150>400||iX+150<0)lost();
  }
}
void lost() {//LOST表示
  fill(20);
  rect(223, 200, 400, 200);
  textWhite("Lost the machine.", 423, 300);
  textWhite(" << ENTER >> ", 423, 350);
}
void hukinagashi() {
  //クリック中は吹き流しを表示して風の方向を確認
  if (mousePressed==true) {
    stroke(100);
    strokeWeight(3);
    line(mouseX, mouseY+10, mouseX, mouseY-50);
    strokeWeight(1);
    if (wind+bill>0) {
      for (int i=0; i<20; i++)
        bezier(mouseX+7, mouseY-46+random(3)+i, mouseX+15, mouseY-58+random(3)+i, 
        mouseX+24, mouseY-36+random(3)+i, mouseX+43, mouseY-47+random(3)+i);
    } else if (wind+bill<0) {
      for (int i=0; i<20; i++)
        bezier(mouseX-7, mouseY-46+random(3)+i, mouseX-15, mouseY-58+random(3)+i, 
        mouseX-24, mouseY-36+random(3)+i, mouseX-43, mouseY-47+random(3)+i);
    }
  }
}
void subscreen() {//サブスクリーンを描写する
  total+=sqrt(dx*dx)/60*15/200;
  stroke(0);
  strokeWeight(1);
  fill(120);
  rect(852, 0, width-852, height);//backgroundのかわり
  fill(255);
  rect(852, 10, width-852, 20);//goalテープ
  for (int j=1; j<13; j++) {
    for (int i=0; i<6; i++) {
      line(850, 50*j, width, 50*j);
      if (masu[i][j]==1) {//ビルの位置
        building=loadImage("building.png");
        image(building, 805+i*50, j*50, 38, 48);
      }
      if (masu[3][1]==3) {//機構が一番上まで行ったらゴール
        fill(0);
        rect(657, 72, 190, 30);
        fill(255);
        text("distance : "+22+"m", 750, 95);//小数点以下を四捨五入した移動距離  
        fill(255, 0, 0);
        text("GOAL", 976, height/2);
        gear=loadImage("gear.png");
        image(gear, 955, 5, 40, 40);
      } else if (sqrt(dx*dx)*3<13&&masu[i][j]>=3) {//自分の位置
        gear=loadImage("gear.png");
        image(gear, 955, 5+(j-1)*50, 40, 40);
        fill(0);
        rect(657, 72, 190, 30);
        textWhite("distance : "+nf((12-j)*2+total, 0, 2)+"m", 750, 95);//小数点以下を四捨五入した移動距離  
        //機構のビル風による影響
        if (hantei==0) {
          if (masu[i+1][j-1]==1&&masu[i-1][j-1]==1) bill=wind/4;//(ここで配列を使用)
          else if ((masu[i+1][j-1]==1&&masu[i-2][j-1]==1)||
            (masu[i+2][j-1]==1&&masu[i-1][j-1]==1)) bill=wind/6;
          else if (masu[i+1][j-1]==1||masu[i-1][j-1]==1) bill=wind/8;
          else if (masu[i+2][j-1]==1&&masu[i-2][j-1]==1) bill=wind/16;
          else if (masu[i+2][j-1]==1||masu[i-2][j-1]==1) bill=wind/32;
          hantei=1;
        }
      }
    }
    if (total>=2&&masu[3][1]!=3) { 
      targetUP();
      total-=2;
    }
  }
}
void targetUP() {
  //サブスクリーンでの機構が進む動き
  hantei=0;
  for (int j=1; j<14; j++)
    masu[3][j-1]=masu[3][j];
}
void husya(float cx, float cy, float r, float roll) {
  //風車を描画する関数
  //中心座標,長さ,回転角度
  strokeWeight(5);
  stroke(255);
  for (int i=0; i<6; i++) {
    line(cx+r*cos(radians(roll+(360/6)*i)), cy+r*sin(radians(roll+(360/6)*i)), 
    cx+r/2*cos(radians(roll+90+(360/6)*i)), cy+r/2*sin(radians(roll+90+(360/6)*i))-PI/2);
  }
}
void drawpair(float theata, float OX, float OY) {
  //右足と左足を対で描画する
  //足の着く角度,中心座標
  float AX=OX+45.0*cos(theata);
  float AY=OY+45.0*sin(theata);
  calcTeo(OX, OY, AX, AY, theata, 1);
  float ax=OX+45.0*cos(2*PI-theata);
  float ay=OY+45.0*sin(2*PI-theata);
  calcTeo(OX, OY, ax, ay, theata, -1);
  stroke(255, 0, 0);
  point(AX, AY);//aは赤
}
void calcTeo(float oX, float oY, float AX, float AY, float theata, float lr) {
  //テオ・ヤンセン機構の計算
  //点O,点A,開始角,左右
  //参考(http://roomba.hatenablog.com/entry/2015/02/26/024903)
  float a = 38.0*3;
  float b = 41.5*3;
  float c = 39.3*3;
  float d = 40.1*3;
  float e = 55.8*3;
  float f = 39.4*3;
  float g = 36.7*3;
  float h = 65.7*3;
  float i = 49.0*3;
  float j = 50.0*3;
  float k = 61.9*3;
  float l = 7.8*3;
  float BX=oX-a*lr;
  float BY=oY+l*lr;
  //Cの座標を求める
  float AB=dist(AX, AY, BX, BY);
  float theata_ab=atan2((AY-BY), (AX-BX));
  float xa=(AB*AB+b*b-j*j)/(2*AB);
  float ya=sqrt(b*b-xa*xa);
  float CX=BX+xa*cos(theata_ab)-ya*cos(theata_ab+PI/2);
  float CY=BY+xa*sin(theata_ab)-ya*sin(theata_ab+PI/2); 
  //Eの座標を求める
  float xb=(b*b+d*d-e*e)/(2*b);
  float yb=sqrt(d*d-xb*xb);
  float theata_bc=atan2((CY-BY), (CX-BX));
  float EX=BX+xb*cos(theata_bc)-yb*cos(theata_bc+PI/2);
  float EY=BY+xb*sin(theata_bc)-yb*sin(theata_bc+PI/2);
  //Dの座標を求める
  float xc=(AB*AB+c*c-k*k)/(2*AB);
  float yc=sqrt(c*c-xc*xc);
  float DX=BX+xc*cos(theata_ab)-yc*cos(theata_ab-PI/2);
  float DY=BY+xc*sin(theata_ab)-yc*sin(theata_ab-PI/2);
  //Fの座標を求める
  float DE=dist(DX, DY, EX, EY);
  float xd=(DE*DE+g*g-f*f)/(2*DE);
  float yd=sqrt(g*g-xd*xd);
  float theata_de=atan2((EY-DY), (EX-DX));
  float FX=DX+xd*cos(theata_de)-yd*cos(theata_de+PI/2);
  float FY=DY+xd*sin(theata_de)-yd*sin(theata_de+PI/2);
  //Gの座標を求める
  float xe=(g*g+i*i-h*h)/(2*g);
  float ye=sqrt(i*i-xe*xe);
  float theata_df=atan2((FY-DY), (FX-DX));
  float GX=DX+xe*cos(theata_df)-ye*cos(theata_df+PI/2);
  float GY=DY+xe*sin(theata_df)-ye*sin(theata_df+PI/2);
  stroke(100);
  strokeWeight(1);
  if (lr==1) {
    line(AX, AY, CX, CY);
    line(CX, CY, BX, BY);
    line(CX, CY, EX, EY);
    line(EX, EY, BX, BY);
    line(DX, DY, AX, AY);
    line(DX, DY, BX, BY);
    line(FX, FY, EX, EY);
    line(FX, FY, DX, DY);
    line(GX, GY, FX, FY);
    line(GX, GY, DX, DY);
  } else {
    line(oX+45.0*cos(theata), oY+45.0*sin(theata), CX, 2*oY-CY);
    line(CX, 2*oY-CY, BX, 2*oY-BY);
    line(CX, 2*oY-CY, EX, 2*oY-EY);
    line(EX, 2*oY-EY, BX, 2*oY-BY);
    line(DX, 2*oY-DY, oX+45.0*cos(theata), oY+45.0*sin(theata));
    line(DX, 2*oY-DY, BX, 2*oY-BY);
    line(FX, 2*oY-FY, EX, 2*oY-EY);
    line(FX, 2*oY-FY, DX, 2*oY-DY);
    line(GX, 2*oY-GY, FX, 2*oY-FY);
    line(GX, 2*oY-GY, DX, 2*oY-DY);
  }
  stroke(255);
  strokeWeight(5);
  if (lr==1)  point(BX, BY);
  else point(BX, 2*oY-BY);
  stroke(255, 255, 0);
  if (lr==1)  point(CX, CY);
  else point(CX, 2*oY-CY); 
  stroke(0, 255, 0);
  if (lr==1)  point(EX, EY);
  else point(EX, 2*oY-EY);  
  stroke(0, 255, 255);
  if (lr==1)  point(DX, DY);
  else point(DX, 2*oY-DY);//dは水色
  stroke(0, 0, 255);
  if (lr==1)  point(FX, FY);
  else point(FX, 2*oY-FY);//fは青
  stroke(255);
  if (lr==1)  point(GX, GY);
  else point(GX, 2*oY-GY);//gは動く白
}
void gear( float cx, float cy, float r, float d, float z, float roll) {
  /*歯車を描く関数
   中心座標,中心から歯の先の長さ,中心から谷の深さ,歯の数 ,回る角度 
   参考(http://blog.livedoor.jp/reona396/archives/54602822.html)*/
  noStroke();
  fill(100);
  pushMatrix();
  translate(cx, cy);
  rotate(roll);
  float R, x, y;
  beginShape();
  for (int i=0; i<z*2; i++) {
    if (i%2==0)R=r;
    else R=d;
    x=R*cos(radians(360/z*2*i));
    y=R*sin(radians(360/z*2*i));
    vertex(x, y);
  }
  endShape(CLOSE);
  popMatrix();
  fill(0);
  ellipse(cx, cy, d/4*10, d/4*10);
}
void textWhite(String a, float x, float y) {//白文字をtextする
  fill(255);
  text(a, x, y);
}