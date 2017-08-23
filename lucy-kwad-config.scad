// todo - camera mount
// todo - make rails even easier to manipulate
//include the modules 
include <lucy-kwad-modules.scad>
//include polyround tool 
include <polyround.scad>


//echo($vpr);echo($vpt);echo($vpd);//rotation, translation, camdist? focal?
//$vpr=[69.7, 0, 51.6];$vpt= [-1.03859, 2.44642, 3.51505];$vpd=412;//comment to stop the view from resetting each time

//VARIABLES//
PropD=5*25.4;//propsize inch
$fn=20;
mot_s = [PropD+8,PropD+40,110,PropD+5]; //[x,yforLowMots,Z,YforUpMots]
dem=max(mot_s[0],mot_s[1],mot_s[3]);
/*
mmix [motor number] [throttle] [roll] [pitch] [yaw]
mmix 1 1.000 -1.000 1.000 -1.000 (Rear Right motor)
mmix 2 1.000 -1.000 -1.000  1.000 (Front Right motor)
mmix 3 1.000 1.000 1.000 1.000 (Rear Left motor)
mmix 4 1.000 1.000 -1.000 -1.000 (Front Left motor)
*/
uroll=mot_s[3]/dem;//upper roll
lroll=mot_s[1]/dem;//lower roll
pitch=mot_s[0]/dem;// pitch
echo(str("mmix 1 1.000 ",-uroll," ",pitch," -1.000"));
echo(str("mmix 2 1.000 ",-lroll," ",-pitch," 1.000"));
echo(str("mmix 3 1.000 ",uroll," ",pitch," -1.000"));
echo(str("mmix 3 1.000 ",lroll," ",-pitch," 1.000"));

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
fs=[180,38,44]; //length width height
fs_mir=1;//min internal radius (set by the size of your routing bit)
fs_mer=0.2;//min external radius
fs_sr=2;//standard radius
fs_wtr=2;//wing tip radius
fs_wbr=[12,20];//wing base radius, [front, rear]
fs_minT=4;//min thickness
fs_bhd=7;//bolt head dia
fs_bd=3.2;//bolt dia
fs_bhh=3;//bolt head height
fs_bmt=3;//bolt min thickness
fs_ph=4;//post height
fs_pt=4;//post thickness
fusehozoff=-17;
FR=[4,5,6,65,35]; //[carbon thickness,other thickness,trasition radius, front angle, rear angle]
CarRT=4;
CarBT=FR[0];
RCutT=5.5;

FR_SD=[5,5];//slot depth1,slot depth2
FR_tol=0.2;
FR_CaT=4;//carbon thickness
FR_CuT=7;//cut thickness
FR_MT=3;//min thickness
FR_RA=30;//rear angle
FR_OH=30;//front overhang
FR_MIR=1;//min internal radius
FR_SR=3;//standard radius
FR_R1=20;//radius 1
FR_R2=5;//radius 2
FR_R3=10;//radius 3
FR_BHD=7;//bolt head dia
FR_BD=3.2;//bolt dia
FR_BHH=3;//bolt head height


Stack_HS=30.5;
Stack_HD=3.2;
Stack_PcbW=38;

//rough model of runcam eagle
camL=33; //length
camH=26.5; // height
camW=26;//width
camD=17;//lens diameter
camPP=3;//pivit point
camA=[theta,10];//angle
camMH=25;//mount height
camP=[fs[0]/2-43,27];//placement, [X,Z]
camHP=[4,8];

//rearfastening
rearF_nh=2.5;// nut height
rearF_nf=5.3;// nut flats (distance between flats)
rearF_ha=20;//hull angle
rearF_bd=3.2;//bolt diameter

//CALCULATIONS// and some varibles

mot_cords=[[(mot_s[0]*cos(theta)+mot_s[2]*sin(theta))/2,mot_s[1]/2,(-mot_s[0]*sin(theta)+mot_s[2]*cos(theta))/2],
[(-mot_s[0]*cos(theta)-mot_s[2]*sin(theta))/2,mot_s[3]/2,(mot_s[0]*sin(theta)-mot_s[2]*cos(theta))/2]];
carbW=[30,20,4,4]; //wing [base width, tip width, thickness,radius]
carbWmin=2; //wing min thickness
carbLWTO = [-5,-3,15]; //lower wing tip offset [x,y,z]
carbLWR=[10,20];//lower wing radius [front,rear]
carbLWP=[22,fs[1]/2,mot_cords[0][2]+carbLWTO[2]]; //lower wing placement [x,y,z]
carbUWP=[-18,(fs[1]+carbW[2])/2+fs_ph,carbLWP[2]+UWB_MO[1]]; //lower wing placement [x,y,z]
carbUWTO = [-5,-12,-5]; //lower wing tip offset [x,y,z]
echo("hmm",carbLWP[2]+fs[2]/2);
FR_RHP=[-fs[0]/2+fusehozoff+FR_SD[0]-FR_CuT+fs[2]*tan(FR_RA)+11,fs[2]-FR_CuT/2];//Rear hole placement, todo hardnum curently offset from the corrner of the rail by an abitary amount, ideally the hole should be placed just behind the wing so that it is still accessible with a allan key

LWXang = atan((mot_cords[0][2]+carbLWTO[2]-carbLWP[2])/(mot_cords[0][1]+carbLWTO[1]-carbLWP[1]));
UWXang = atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/(mot_cords[1][1]+carbUWTO[1]-carbUWP[1]));
//UWRYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbW[1]-carbUWP[0]+carbW[0]-carbW[3]/2)));
//UWFYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbUWP[0]-carbW[3])));
//[x,yforLowMots,Z,YforUpMots]
diagonalMotDis=sqrt(mot_s[0]*mot_s[0]+(mot_s[1]+mot_s[3])/2*(mot_s[1]+mot_s[3])/2);
echo(str("diagonal motor distance=",diagonalMotDis,"mm"));

TeMT=3;//tether Min thickness

//Upper wing Y length
UWYlen=pointDist([carbUWP[1],carbUWP[2]],[mot_cords[1][1]+carbUWTO[1],mot_cords[1][2]+carbUWTO[2]]);
//Upper wing radii points
UWingRP=[
[carbUWP[0],							0,			3],
[mot_cords[1][0]+carbUWTO[0],			UWYlen,		3],	
[mot_cords[1][0]+carbUWTO[0]-carbW[1],	UWYlen,		3],	
[carbUWP[0]-carbW[0],					0,			3]
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
UWing_MMP=[//motor mount points
	//[UWing_MFBMX-6,		UWing_MFBMY,		0],
	[UWing_MFBMX+UWing_XMHO,		UWing_MFBMY,		1],
	UWingRP[1]+[-carbUWTO.x,0,0],
	UWingRP[2],
	[UWing_MRBMX,		UWing_MRBMY,	0]
];
UWing_MMPS=[//motor mount points small
	[UWing_MFBMSX-5,		UWing_MFBMSY,		0],
	[UWing_MFBMSX,		UWing_MFBMSY,		0],
	UWingRP[1],
	UWingRP[2],
	[UWing_MRBMX,		UWing_MRBMY,	0]
];
UWing_BTO=11;
//UWing_MMH=round3points([UWing_MMP[4],[UWing_MMP[1][0],UWing_MMP[1][1],motP_mntD/2],UWing_MMP[2]])[2]+[UWing_XMHO,0];//motor mount hole
UWing_MMH=round3points([UWing_MMP[3],[UWing_MMP[0][0],UWing_MMP[0][1],(motP_mntD+motP_MT)/2],UWing_MMP[1]])[2]+[UWing_XMHO*0,0];//motor mount hole
UWing_FWMH=round3points([UWingRP[3],[UWingRP[0].x,UWingRP[0].y,5],UWingRP[1]])[2];//front wing mount hole
UWing_RWMH=round3points([UWingRP[2],[UWingRP[3].x,UWingRP[3].y,5],UWingRP[0]])[2];//rear wing mount hole
//UWing_TMHY=(+fs[2]+carbUWP[2]-FR_CuT/2)/cos(UWXang);//Tether Mount Hole Y
UWing_TMHY=(fs[2]-(carbUWP[2]-carbLWP[2])-FR_CuT/2)/sin(UWXang)-5;//Tether Mount Hole Y
UWing_TMHX=interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWing_TMHY)+13;//Tether Mount Hole X

UWing_BFT=[interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWingRP[0].y+UWing_BTO),UWingRP[0].y+UWing_BTO];//brace front top Y
UWing_BRT=[interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWingRP[3].y+UWing_BTO),UWingRP[3].y+UWing_BTO];//brace rear top Y
UWing_BFB=[interpX([UWingRP[0].x,UWingRP[0].y],[UWingRP[1].x,UWingRP[1].y],UWingRP[0].y-20),UWingRP[0].y-20];//brace front bottom Y
UWing_BRB=[interpX([UWingRP[3].x,UWingRP[3].y],[UWingRP[2].x,UWingRP[2].y],UWingRP[3].y-20),UWingRP[3].y-12];//brace rear bottom Y


UWing_BP=[//brace points
[UWing_BFT.x,							UWing_BFT.y,	3],
[UWing_BFT.x-7,						UWing_BFT.y,	3],
[(UWing_BFT.x+UWing_BRT.x+6)/2,			UWing_BFT.y-10,	6],
[UWing_BRT.x+10,							UWing_BRT.y,	3],
[UWing_BRT.x,							UWing_BRT.y,	3],
[UWingRP[3].x,							UWingRP[3].y,	5],
[UWingRP[3].x,							carbUWP[2]*cos(UWXang),	4],
[UWingRP[0].x,							carbUWP[2]*cos(UWXang),	4],
[UWingRP[0].x,							UWingRP[0].y,	5],
//[UWing_BRB.x,							UWing_BRB.y,	0],
//[UWing_BFB.x,							UWing_BFB.y,	0],
//[carbUWP[0]-carbW[0],					0,				3],
//[carbUWP[0],							0,				3],
];

l=fs[0];
w=fs[1];
LWingRP=[//Lower ring radii points. First point starts at the rear base of the wing, then moves out to the tip of the wing
[carbLWP[0]-carbW[0],					w/2,							fs_wbr[1]],		
[mot_cords[0][0]+carbLWTO[0]-carbW[1],	mot_cords[0][1]+carbLWTO[1],	fs_wtr],
[mot_cords[0][0]+carbLWTO[0],			mot_cords[0][1]+carbLWTO[1],	fs_wtr],
[carbLWP[0],							w/2,							fs_wbr[0]],
];

fs_RCRP=[//rear clip radii points
[-l/2+fusehozoff,						w/2-FR[0]-FR_tol/2,				0],
[-l/2+fusehozoff+FR_SD[0],				w/2-FR[0]-FR_tol/2,				fs_mir],	
[-l/2+fusehozoff+FR_SD[0],				w/2+FR_tol/2,					fs_mir],
[-l/2+fusehozoff,						w/2+FR_tol/2,					0],						
[-l/2+fusehozoff+fs_minT,				w/2+fs_minT,					10],
[-l/2+fusehozoff+FR_SD[0]+fs_minT*0.5,	w/2+fs_minT,					10],	
[-l/2+fusehozoff+FR_SD[0]+fs_minT*3,	w/2,							25]
];


fs_pp=[//post points 
[fs_minT,			0,							fs_mir],
[fs_minT,			fs_ph,						0],
[fs_minT+fs_pt,		fs_ph,						0],
[fs_minT+fs_pt,		0,							fs_mir],
];

// fs_pp2=[//post points 1
// [carbUWP[0]-fs_minT-fs_pt,		w/2,							fs_mir],
// [carbUWP[0]-fs_minT-fs_pt,		w/2+fs_ph,						0],
// [carbUWP[0]-fs_minT,	w/2+fs_ph,						0],
// [carbUWP[0]-fs_minT,	w/2,							fs_mir],
// ];

fs_BPC=carbUWP[0]-carbW[0]/2;//bolt point centre
// fs_BP=[//bolt points
// [fs_BPC-fs_bd/2,			w/2,							0],
// [fs_BPC-fs_bd/2,			w/2-fs_bmt,						0],
// [fs_BPC-fs_bhd/2,		w/2-fs_bmt,						fs_mir],
// [fs_BPC-fs_bhd/2,		w/2-fs_bmt-fs_bhh,				fs_mir],
// [fs_BPC+fs_bhd/2,		w/2-fs_bmt-fs_bhh,				fs_mir],
// [fs_BPC+fs_bhd/2,		w/2-fs_bmt,						fs_mir],
// [fs_BPC+fs_bd/2,			w/2-fs_bmt,						0],
// [fs_BPC+fs_bd/2,			w/2,							0],
// ];

fs_BP=[//bolt points
[-fs_bd/2,			0,							0],
[-fs_bd/2,			-fs_bmt,					0],
[-fs_bhd/2,			-fs_bmt,					fs_mir],
[-fs_bhd/2,			-fs_bmt-fs_bhh,				fs_mir],
[0,					-fs_bmt*1.7-fs_bhh,				fs_mir],
[fs_bhd/2,			-fs_bmt-fs_bhh,				fs_mir],
[fs_bhd/2,			-fs_bmt,					fs_mir],
[fs_bd/2,			-fs_bmt,					0],
[fs_bd/2,			0,							0],
];

fs_basePoints=concat([
[-l/2+fusehozoff+7,						0,								25],
[-l/2+fusehozoff,						w/2-FR[0]-FR_tol/2-fs_minT,		15]
],fs_RCRP,
//carbUWP[0]-carbW[0]
moveRadiiPoints(fs_pp,[carbUWP[0]-carbW[0],fs[1]/2]),
moveRadiiPoints(fs_BP,[carbUWP[0]-carbW[0]/2,fs[1]/2]),
moveRadiiPoints(fs_pp,[carbUWP[0]-fs_minT-fs_pt*2,fs[1]/2]),
//fs_pp2,
LWingRP,[
[l/2+fusehozoff-fs_minT-CarRT-fs_mir*2,			w/2+fs_minT,					fs_sr],
[l/2+fusehozoff,						w/2+fs_minT,					fs_sr],
[l/2+fusehozoff,						w/2-fs_minT-CarRT*.75,				fs_sr*3],
[l/2+fusehozoff-50,						0,								10]
]);

LWing_MFBMY=LWingRP[2].y-5;//motor front base mount Y
LWing_MRBMY=LWingRP[1].y-14;//motor rear base mount Y
//LWing_MFBMSY=LWingRP[2].y-3;//motor front base mount SMALL Y
LWing_MRBMSY=LWingRP[1].y-5;//motor front base mount SMALL Y
LWing_MFBMX=interpX([LWingRP[3].x,LWingRP[3].y],[LWingRP[2].x,LWingRP[2].y],LWing_MFBMY);//motor front bottom mount X
LWing_MRBMX=interpX([LWingRP[0].x,LWingRP[0].y],[LWingRP[1].x,LWingRP[1].y],LWing_MRBMY);//motor rear bottom mount X
LWing_MRBMSX=interpX([LWingRP[0].x,LWingRP[0].y],[LWingRP[1].x,LWingRP[1].y],LWing_MRBMSY);//motor front bottom mount Small X
LWing_MMP=[//motor mount points
	[LWing_MFBMX,		LWing_MFBMY,		0],
	LWingRP[2],
	LWingRP[1],
	[LWing_MRBMX,		LWing_MRBMY,	0],
	[LWing_MRBMX+5,		LWing_MRBMY,	0]
];
LWing_MMPS=[//motor mount points small
	[LWing_MRBMSX,		LWing_MRBMSY,		0],
	LWingRP[1],
	LWingRP[2],
	[LWing_MFBMX,		LWing_MFBMY,	0]
];
LWing_XMHO=-carbWmin/cos(getAngle(LWingRP[3],LWingRP[2]));//X mount hole offset
LWing_MMH=round3points([LWing_MMP[2],[LWing_MMP[3][0],LWing_MMP[3][1],motP_mntD/2],LWing_MMP[0]])[2]+[-LWing_XMHO,0];//motor mount hole


//echo(for(i=[0,1])let(what=what+hi[i]));
//RENDERS///////////////////////////////////////////////////////////
wantToPrint=0; //0 for model, 1 to print parts
rotate([0,0,0]){
 fuseRev2();
 for(i=[0,0])mirror([0,i,0]){
 //translate([fs[0]/2+fusehozoff,0,carbLWP[2]-carbW[2]/2])mirror([1,0,0])thefuselage(fuseHt=fs[2],frntDia=45,rearDia=70,RCT1 = CarRT,RCT2 = RCutT,BCT1 =CarBT,slotD=FR_SD[0],tol=FR_tol,totLength=fs[0],fuseW=fs[1],mergeR=[5,10],mergeT=3);
 %wingUrev2(6.2,0);
 fuseRailsRev2();
 color("green")rotate([0,(180-theta)*wantToPrint,0])motMntL(-22.5);//was 39
 color("green")rotate([0,(180-theta)*wantToPrint,0])motMntU(UWXang);// was 30
 color("green")UWingBrace2();
 color("green")teather();
 #camM();
 //polygon(polyRound(moveRadiiPoints(fs_BP2,[carbUWP[0]-carbW[0]/2,fs[1]/2])));
 //wingL();
 //translate([wantToPrint*-100,wantToPrint*50,0])rotate([-UWXang*wantToPrint,0,0])wingU();
 //rotate([180*wantToPrint,0,0])UWingBrace(MT1=UWB_MT1,MT2=UWB_MT2,Hdia=UWB_Hdia,WBMO=UWB_MO);
 if(wantToPrint==0){
	//motSpace(0)rotate([0,theta,0])translate([0,0,17.5+motP_MT])mirror([0,1,0])rotate([0,0,-20+360*$t])	prop(3);//for(i=[0:2:360]) rotate([0,0,i])cube([PropD/2,0.1,0.2]);
	//motSpace(1)rotate([0,theta,0])translate([0,0,17.5+motP_MT])rotate([0,0,UWXang+60+360*$t])					prop(3);//for(i=[0:2:360]) rotate([0,0,i])cube([PropD/2,0.1,0.2]);
	cam();
    //thecam();
    //translate([-90,-15,carbLWP[2]+FR[0]/2])cube([85,30,35]);//crude battery
    //%translate([-3.7,-18,carbLWP[2]+FR[0]/2+5])cube([36,36,20]);//crude stack
    //%translate([-33+fusehozoff,-17.5,carbLWP[2]+FR[0]/2])cube([85,35,30]);//crude battery
    //%translate([-71+fusehozoff,-18,carbLWP[2]+FR[0]/2+5])cube([36,36,20]);//crude stack
 }
 }
}

//MODULES//////////////////
camM=[10,31,25,1.2,17,3.2,20];//depth,width,height,Material thickness,mountheight,holeD,hole spacing
