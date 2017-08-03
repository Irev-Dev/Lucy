/*
--Rev1-- Changing the direction somewhat for rev 1:
	Firstly the bottom part of the fuselage and the lower wings will be on the same plane and therefore can be cut from a single pice of carbon fibre
	and orginally the motor mounts rapped around both sides of the wing tips, but now mount to a sing side.
--Rev3-- implementing coording spaces for mounting holes
*/
/*ToDo
--delete un-used variables (also there are a few floating around) this is half done, unused ones are commented out
--at FC and camera hole mount on fuselage
_-_-_-_the following are big changes and should be made under new revisions_-_-_-_
--add coordinate spaces for all mounting holes (besides motors) this will make the code much more oncise and easy to follow.
--Big change!, define the wings (start with the Upper wings) with a plane and cordinates instead of the hull method it will make the wing braces much easier to make and easier to understand the code.
*/

//include the modules 
include <lucy-kwad-modules.scad>
//include polyround tool 
include <polyround.scad>

//VARIABLES//

//$fn=20;
mot_s = [25.4*5+4,25.4*5+40,100,25.4*5+24]; //[x,yforLowMots,Z,YforUpMots]
theta = 70;
motP_MT = 3;//material thickness
motP_MT2=3;
motP_mntS=[16/2,16/2,19/2,19/2];//mount hole spacing [radA1,radA2,radB1,radB2]
motP_mntD = 3.2;//mounting hole diametr
motP_dia = 28;
motP_CD=6; //counter dia
motP_CA=45;//counter angle
motP_BR=4;//brace radius
motP_MG=[1,7];//diameter,offset from motP diameter
//motP_WMD=3.2;//wing mount dia
//motP_WMFD=5.7;//fastener dia
//motP_WMFS=6;//fasterner shap (6=hex,4=square)
motP_WMHD=7;//bolt head dia
//motP_WMFDp=2;//fasterner depth
motP_CHD=2;
motP_CHdia=9.5;

//none of these are used, though I might later?
//mot_ht=12;
//mot_dia=22;
//prop_ht=8;
//prop_dia=5*25.4;

//UWB upper wing brace
//UWB_min=3;//minimum material thickness
//UWB_MT=[4,3]; //material thickness1
//UWB_fast=[3.2,5,5.5,3,6];//[dia,head dia,hex dia,hex depth,hexOrSquare]fastner options
//UWB_BMH=4;//BMH
//UpperWingBrace(MT1=UWB_MT1,MT2=UWB_MT2,Hdia=UWB_Hdia,WBMO=UWB_MO)
UWB_MT1=2;
UWB_MT2=3;
UWB_Hdia=3.2;
UWB_MO=[5,4];//[x,z]
//this will be used soon
UWB_minP=0.5;//min print thickness (support material)
UWB_HoS=6; //hex or square 4=square 6=hex

//fuselage and rails, FR=fuselage rails
fs=[180,46,42]; //length width height
fs_mir=1;//min internal radius (set by the size of your routing bit)
fs_mer=0.2;//min external radius
fs_sr=2;//standard radius
fs_wtr=2;//wing tip radius
fs_wbr=[12,20];//wing base radius, [front, rear]
fs_minT=4;
fusehozoff=-17;
FR=[4,5,6,65,35]; //[carbon thickness,other thickness,trasition radius, front angle, rear angle]
CarRT=4;
CarBT=FR[0];
RCutT=5.5;

FR_SD=[5,5];//slot depth1,slot depth2
FR_tol=0.2;


Stack_HS=30.5;
Stack_HD=3.2;
Stack_PcbW=38;

//rough model of runcam eagle
camL=33; //length
camH=26.5; // height
camW=26;//width
camD=17;//lens diameter
camPP=3;//pivit point
camA=35;//angle
camMH=25;//mount height

//rearfastening
rearF_nh=2.5;// nut height
rearF_nf=5.3;// nut flats (distance between flats)
rearF_ha=20;//hull angle
rearF_bd=3.2;//bolt diameter

//CALCULATIONS// and some varibles

mot_cords=[[(mot_s[0]*cos(theta)+mot_s[2]*sin(theta))/2,mot_s[1]/2,(-mot_s[0]*sin(theta)+mot_s[2]*cos(theta))/2],
[(-mot_s[0]*cos(theta)-mot_s[2]*sin(theta))/2,mot_s[3]/2,(mot_s[0]*sin(theta)-mot_s[2]*cos(theta))/2]];

carbW=[30,20,4,4]; //wing [base width, tip width, thickness,radius]
carbWmin=1.5;
carbLWTO = [-5,-3,20]; //lower wing tip offset [x,y,z]
carbLWR=[10,20];//lower wing radius [front,rear]
carbLWP=[25,fs[1]/2,mot_cords[0][2]+carbLWTO[2]]; //lower wing placement [x,y,z]
carbUWP=[-25,(fs[1]+carbW[2])/2,carbLWP[2]+UWB_MO[1]]; //lower wing placement [x,y,z]
carbUWTO = [-1,-12,0]; //lower wing tip offset [x,y,z]


LWXang = atan((mot_cords[0][2]+carbLWTO[2]-carbLWP[2])/(mot_cords[0][1]+carbLWTO[1]-carbLWP[1]));
UWXang = atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/(mot_cords[1][1]+carbUWTO[1]-carbUWP[1]));
UWRYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbW[1]-carbUWP[0]+carbW[0]-carbW[3]/2)));
UWFYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbUWP[0]-carbW[3])));
//[x,yforLowMots,Z,YforUpMots]
diagonalMotDis=sqrt(mot_s[0]*mot_s[0]+(mot_s[1]+mot_s[3])/2*(mot_s[1]+mot_s[3])/2);
echo("diagonal motor distance=",diagonalMotDis,"mm");
//fuselage base polygon points


//RENDERS///////////////////////////////////////////////////////////
wantToPrint=0; //0 for model, 1 to print parts
rotate([0,-0,0])for(i=[0,1])mirror([0,i,0]){
 //translate([fs[0]/2+fusehozoff,0,carbLWP[2]-carbW[2]/2])mirror([1,0,0])thefuselage(fuseHt=fs[2],frntDia=45,rearDia=70,RCT1 = CarRT,RCT2 = RCutT,BCT1 =CarBT,slotD=FR_SD[0],tol=FR_tol,totLength=fs[0],fuseW=fs[1],mergeR=[5,10],mergeT=3);
 fuseRev2();
 rotate([0,(180-theta)*wantToPrint,0])motMntL(39);
 //rotate([0,(180-theta)*wantToPrint,0])motMntU(30);
 //wingL();
 //translate([wantToPrint*-100,wantToPrint*50,0])rotate([-UWXang*wantToPrint,0,0])wingU();
 //rotate([180*wantToPrint,0,0])UWingBrace(MT1=UWB_MT1,MT2=UWB_MT2,Hdia=UWB_Hdia,WBMO=UWB_MO);
 if(wantToPrint==0){
	//motSpace(0)rotate([0,theta,0])translate([0,0,17.5+motP_MT])for(i=[0:2:360]) rotate([0,0,i])cube([25.4*2.5,0.1,0.2]);
	//motSpace(1)rotate([0,theta,0])translate([0,0,17.5+motP_MT])for(i=[0:2:360]) rotate([0,0,i])cube([25.4*2.5,0.1,0.2]);
    //thecam();
    //translate([-90,-15,carbLWP[2]+FR[0]/2])cube([85,30,35]);//crude battery
    //%translate([-3.7,-18,carbLWP[2]+FR[0]/2+5])cube([36,36,20]);//crude stack
    //%translate([-44+fusehozoff,-17.5,carbLWP[2]+FR[0]/2])cube([85,35,30]);//crude battery
    //%translate([-83.7+fusehozoff,-18,carbLWP[2]+FR[0]/2+5])cube([36,36,20]);//crude stack
 }
}

//MODULES//////////////////
camM=[10,31,25,1.2,17,3.2,20];//depth,width,height,Material thickness,mountheight,holeD,hole spacing
