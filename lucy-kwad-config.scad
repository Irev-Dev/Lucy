/* 
Intellectual property is bullshit, steal this code

This code is licensed under GLPv3, which gives you permission to edit this code to meet your own purposes. 
However the idea that you need permission to edit and hack the things around you is insidious, 
and has been promoted by those who do not have your interests in mind. 
Intellectual property is bullshit.
*/

//include the modules 
include <lucy-kwad-modules.scad>
//include polyround tool 
include <polyround.scad>


//echo($vpr);echo($vpt);echo($vpd);//rotation, translation, camdist? focal?
//$vpr=[69.7, 0, 51.6];$vpt= [-1.03859, 2.44642, 3.51505];$vpd=412;//comment to stop the view from resetting each time

//VARIABLES//
PropD=5*25.4;//propsize inch
$fn=20;
gfn=8;
mot_s = [PropD+8,PropD+40,110,PropD+10]; //[x,yforLowMots,Z,YforUpMots]
dem=max(mot_s[0],mot_s[1],mot_s[3]);

theta = 70;
motP_MT = 3;//material thickness
motP_MT2=3;
motP_mntS=[15.8/2,19.2/2,15.8/2,19.2/2];//mount hole spacing [radA1,radA2,radB1,radB2]
motP_mntD = 3.2;//mounting hole diametr
motP_HD=6.5;//hex diameter
motP_HoS=6;//hex or square (hex=6,square=4);
motP_WMHCS=1.5;//Wing mount hole, counter sink start
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
fs=[185,30+9,43]; //length width height
fs_mir=1;//min internal radius (set by the size of your routing bit)
fs_mer=0.2;//min external radius
fs_sr=2;//standard radius
fs_wtr=2;//wing tip radius
fs_wbr=[12,20];//wing base radius, [front, rear]
fs_minT=4;//min thickness
fs_bhd=5.7;//bolt head dia
fs_bd=3.2;//bolt dia
fs_bhh=3;//bolt head height
fs_bmt=3;//bolt min thickness
fs_ph=4;//post height
fs_pt=4;//post thickness
fusehozoff=-20;
FR=[4,5,6,65,35]; //[carbon thickness,other thickness,trasition radius, front angle, rear angle]
CarRT=4;
CarBT=FR[0];
RCutT=5.5;

//frameRail
FR_SD=[5,5];//slot depth1,slot depth2
FR_tol=0.2;
FR_CaT=4;//carbon thickness
FR_CuT=7;//cut thickness
FR_MT=3;//min thickness
FR_RA=20;//rear angle
FR_OH=13;//front overhang
FR_MIR=1;//min internal radius
FR_SR=3;//standard radius
FR_R1=20;//radius 1
FR_R2=5;//radius 2
FR_R3=10;//radius 3
FR_BHD=7;//bolt head dia
FR_BD=3.2;//bolt dia
FR_BHH=3;//bolt head height

WB_RSD=5;//rail slot depth
WB_CaT=4;
WB_PW=4;//post width
WB_mir=1;
WB_XP=-56;//X position
WB_BNO=1.5;//bottom nut offset
WB_tol=0.2;

Stack_HS=30.5;
Stack_HD=3.2;
Stack_PcbW=38;

//rough model of runcam eagle
camL=33; //length
camH=26.5; // height
camW=27;//width
camD=17;//lens diameter
camPP=3;//pivit point
camA=[theta,10];//angle
camMH=25;//mount height
camP=[fs[0]/2-43,24];//placement, [X,Z]
camRR=18;//rear room (behind camera)
camHP=[2,7];
camST=0.55;//shell thickness
camMT=2;//min thickness
camBMD=3.2;//bottom mount diameter
camBMH=12;//bottom mount height

//rearfastening
rearF_nh=2.5;// nut height
rearF_nf=5.3;// nut flats (distance between flats)
rearF_ha=20;//hull angle
rearF_bd=3.2;//bolt diameter

//CALCULATIONS// and some varibles

mot_cords=[[(mot_s[0]*cos(theta)+mot_s[2]*sin(theta))/2,mot_s[1]/2,(-mot_s[0]*sin(theta)+mot_s[2]*cos(theta))/2],
[(-mot_s[0]*cos(theta)-mot_s[2]*sin(theta))/2,mot_s[3]/2,(mot_s[0]*sin(theta)-mot_s[2]*cos(theta))/2]];
carbW=[33,23,4,4]; //wing [base width, tip width, thickness,radius]
carbWmin=2; //wing min thickness
carbLWTO = [-5,-3,15]; //lower wing tip offset [x,y,z]
carbLWR=[10,20];//lower wing radius [front,rear]
carbLWP=[22,fs[1]/2,mot_cords[0][2]+carbLWTO[2]]; //lower wing placement [x,y,z]
carbUWP=[-28,(fs[1]+carbW[2]*0)/2,carbLWP[2]+CarBT/2+UWB_MO[1]*0]; //lower wing placement [x,y,z]
carbUWTO = [-5,-12,-5]; //lower wing tip offset [x,y,z]
FR_RHP=[-fs[0]/2+fusehozoff+FR_SD[0]-FR_CuT+fs[2]*tan(FR_RA)+11,fs[2]-FR_CuT/2];//Rear hole placement, todo hardnum curently offset from the corrner of the rail by an abitary amount, ideally the hole should be placed just behind the wing so that it is still accessible with a allan key

LWXang = atan((mot_cords[0][2]+carbLWTO[2]-carbLWP[2])/(mot_cords[0][1]+carbLWTO[1]-carbLWP[1]));
UWXang = atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/(mot_cords[1][1]+carbUWTO[1]-carbUWP[1]));

TeMT=3;//tether Min thickness

//Upper wing Y length
UWYlen=pointDist([carbUWP[1],carbUWP[2]],[mot_cords[1][1]+carbUWTO[1],mot_cords[1][2]+carbUWTO[2]]);
//Upper wing radii points

UW_FWO=3; //front wing offset
UWingRP=[
[carbUWP[0],							UW_FWO,		3],
[mot_cords[1][0]+carbUWTO[0],			UWYlen,		3],	
[mot_cords[1][0]+carbUWTO[0]-carbW[1],	UWYlen,		3],	
[carbUWP[0]-carbW[0],					0,			3],
[carbUWP[0]-carbW.x/2,					UW_FWO,		10]
];
UWRYang=getAngle(UWingRP[2],UWingRP[3]);
UWFYang=getAngle(UWingRP[1],UWingRP[0]);

UWing_MFBMY=UWingRP[1].y-14;//motor front bottom mount Y
UWing_MRBMY=UWingRP[2].y-5;//motor rear bottom mount Y
UWing_MFBMSY=UWingRP[1].y-5;//motor front bottom mount small Y
UWing_MFBMX=interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWing_MFBMY);//motor front bottom mount X
UWing_MRBMX=interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWing_MRBMY);//motor rear bottom mount X
UWing_MFBMSX=interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWing_MFBMSY);//motor front bottom mount small X
UWing_XMHO=-carbWmin*3/cos(90-getAngle(UWingRP[0],UWingRP[1]));//X mount hole offset

UWing_BTO=11;
//UWing_MMH=round3points([UWing_MMP(4),[UWing_MMP(1)[0],UWing_MMP(1)[1],motP_mntD/2],UWing_MMP(2)])[2]+[UWing_XMHO,0];//motor mount hole
UWing_MMH=round3points([UWing_MMP(3),[UWing_MMP(0)[0],UWing_MMP(0)[1],(motP_mntD+motP_MT)/2],UWing_MMP(1)])[2]+[UWing_XMHO*0,0];//motor mount hole
UWing_FWMH=round3points([UWingRP[3],[UWingRP[0].x,UWingRP[0].y,5],UWingRP[1]])[2];//front wing mount hole
UWing_RWMH=round3points([UWingRP[2],[UWingRP[3].x,UWingRP[3].y,5],UWingRP[0]])[2];//rear wing mount hole
UWing_TMHY=(fs[2]/*-(carbUWP[2]-carbLWP[2])*/-UWB_MO[1]-FR_CuT)/sin(UWXang)-10;//Tether Mount Hole Y
//UWing_TMHY=(+fs[2]+carbUWP[2]-FR_CuT/2)/cos(UWXang);//Tether Mount Hole Y
TePoint=[100,fs.y/2,(carbLWP.z+fs.z/*-(carbUWP[2]-carbLWP[2])*/-FR_CuT*1.5)];//tether point - bad name will do for now.
//TePoint2=[100,carbUWP.y+(fs[2]/*-(carbUWP[2]-carbLWP[2])*/-UWB_MO[1]-FR_CuT)*cos(UWXang)+(carbW[2]/2+TeMT)*cos(UWXang)+TeMT*sin(UWXang),(carbLWP.z+fs.z/*-(carbUWP[2]-carbLWP[2])*/-FR_CuT*1.5-FR_CuT*cos(UWXang))];//tether point - bad name will do for now.
TePoint2=[-0,carbUWP.y,carbUWP.z]+[0,(UWing_TMHY-FR_CuT/sin(UWXang))*cos(UWXang)+(carbW[2]/2+TeMT)/sin(UWXang),(UWing_TMHY-FR_CuT/sin(UWXang))*sin(UWXang)];//(fs[2]-UWB_MO[1]-FR_CuT)/sin(UWXang)-FR_CuT*0-FR_CuT*sin(UWXang)];//tether point - bad name will do for now.
//#translate(TePoint)sphere(0.2);
//#translate(TePoint2)sphere(0.2);//translate([0,-10,0.2])cube([1,20,1]);
//UWing_TMHY=(fs[2]/*-(carbUWP[2]-carbLWP[2])*/-UWB_MO[1]-FR_CuT)/sin(UWXang);//Tether Mount Hole Y
UWing_TMHX=interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWing_TMHY)+9;//Tether Mount Hole X

UWing_BFT=[interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWingRP[0].y+UWing_BTO),UWingRP[0].y+UWing_BTO];//brace front top Y
UWing_BRT=[interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWingRP[3].y+UWing_BTO),UWingRP[3].y+UWing_BTO];//brace rear top Y
UWing_BFB=[interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWingRP[0].y-20),UWingRP[0].y-20];//brace front bottom Y
UWing_BRB=[interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWingRP[3].y-20),UWingRP[3].y-12];//brace rear bottom Y


l=fs[0];
w=fs[1];

fs_BPC=carbUWP[0]-carbW[0]/2;//bolt point centre

LWing_MFBMY=LWingRP(2).y-5;//motor front base mount Y
LWing_MRBMY=LWingRP(1).y-14;//motor rear base mount Y
//LWing_MFBMSY=LWingRP(2).y-3;//motor front base mount SMALL Y
LWing_MRBMSY=LWingRP(1).y-5;//motor front base mount SMALL Y
LWing_MFBMX=interpX([LWingRP(3).x,LWingRP(3).y],[LWingRP(2).x,LWingRP(2).y],LWing_MFBMY);//motor front bottom mount X
LWing_MRBMX=interpX([LWingRP(0).x,LWingRP(0).y],[LWingRP(1).x,LWingRP(1).y],LWing_MRBMY);//motor rear bottom mount X
LWing_MRBMSX=interpX([LWingRP(0).x,LWingRP(0).y],[LWingRP(1).x,LWingRP(1).y],LWing_MRBMSY);//motor front bottom mount Small X

LWing_XMHO=-carbWmin/cos(getAngle(LWingRP(3),LWingRP(2)));//X mount hole offset
LWing_MMH=round3points([LWing_MMP(2),[LWing_MMP(3)[0],LWing_MMP(3)[1],motP_mntD/2],LWing_MMP(0)])[2]+[-LWing_XMHO,0];//motor mount hole
//echo(for(i=[0,1])let(what=what+hi[i]));
//RENDERS///////////////////////////////////////////////////////////
Print2Console();
partLayout=0; //0 for model, 1 to print parts
rotate([0,0,0]){
 fuse3(6.5,0,partLayout);
 WbraceC(partLayout);
 for(i=[0,0])mirror([0,i,0]){
 //translate([fs[0]/2+fusehozoff,0,carbLWP[2]-carbW[2]/2])mirror([1,0,0])thefuselage(fuseHt=fs[2],frntDia=45,rearDia=70,RCT1 = CarRT,RCT2 = RCutT,BCT1 =CarBT,slotD=FR_SD[0],tol=FR_tol,totLength=fs[0],fuseW=fs[1],mergeR=[5,10],mergeT=3);
 WbraceP(partLayout);
 wingU3(6.2,0,partLayout);
 fuseRailsRev2(0,partLayout);
 color("green")motMntL(-22.5,partLayout);//was 39
 color("green")motMntU(UWXang,partLayout);// was 30
 color("green")camM(partLayout);
//  motMntL(-22.5,partLayout);//was 39
//  motMntU(UWXang,partLayout);// was 30
 camM(partLayout);
 //polygon(polyRound(moveRadiiPoints(fs_BP2,[carbUWP[0]-carbW[0]/2,fs[1]/2])));
 //translate([partLayout*-100,partLayout*50,0])rotate([-UWXang*partLayout,0,0])wingU();
 //rotate([180*partLayout,0,0])UWingBrace(MT1=UWB_MT1,MT2=UWB_MT2,Hdia=UWB_Hdia,WBMO=UWB_MO);
 if(partLayout==0){
	bladenum=4;
    // tranZ(17.5)prop(bladenum,PropD);
    // motor();
	//motSpace(0)rotate([0,theta,0])translate([0,0,17.5+motP_MT])mirror([0,1,0])rotate([0,0,-20+360*$t])	prop(bladenum,PropD);	motSpace(1)rotate([0,theta,0])translate([0,0,17.5+motP_MT])rotate([0,0,UWXang+60+360*$t])			prop(bladenum,PropD);//for(i=[0:2:360]) rotate([0,0,i])cube([PropD/2,0.1,0.2]);
    //for(i=[0,1])motSpace(i)rotate([0,theta,0])translate([0,0,motP_MT])motor();
	//cam(0,0);
    //thecam();
    //translate([-90,-15,carbLWP[2]+FR[0]/2])cube([85,30,35]);//crude battery
    //%translate([-3.7,-18,carbLWP[2]+FR[0]/2+5])cube([36,36,21]);//crude stack
    //%translate([-35+fusehozoff,-15,carbLWP[2]+FR[0]/2])cube([85,30,35]);//crude battery
    //%translate([-77+fusehozoff,-18,carbLWP[2]+FR[0]/2])cube([36,36,21]);//crude stack
 }
 }
}

//MODULES//////////////////
camM=[10,31,25,1.2,17,3.2,20];//depth,width,height,Material thickness,mountheight,holeD,hole spacing
