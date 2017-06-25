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


//VARIABLES//
//$fn=55;
echo(sin(20));
mot_s = [25.4*5,25.4*5+37,70,25.4*5+5]; //[x,yforLowMots,Z,YforUpMots]
theta = 70;
motP_MT = 3;//material thickness
motP_MT2=3;
motP_mntS=[6,9,7,10];//mount hole spacing [radA1,radA2,radB1,radB2]
motP_mntD = 3.2;//mounting hole diametr
motP_dia = 25;
motP_CD=6; //counter dia
motP_CA=45;//counter angle
motP_BR=4;//brace radius
//motP_WMD=3.2;//wing mount dia
//motP_WMFD=5.7;//fastener dia
//motP_WMFS=6;//fasterner shap (6=hex,4=square)
motP_WMHD=7;//bolt head dia
//motP_WMFDp=2;//fasterner depth
motP_CHD=2;
motP_CHdia=6;

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

//FR fuselage rails
fs=[180,38,39]; //length width height
fusehozoff=-10;
FR=[4,5,6,65,35]; //[carbon thickness,other thickness,trasition radius, front angle, rear angle]
CarRT=4;
CarBT=FR[0];
RCutT=5.5;
//FR_fast=[3.2,5,15,5.5,3,6];//[0dia,1head dia,2head angle,3hex dia,4hex depth,5hexOrSquare]fastner options
//FR_min=[4,4,4,5];//minimum thicknesses
FR_SD=[5,5];//slot depth1,slot depth2
FR_tol=0.2;

Stack_HS=30.5;
Stack_HD=3.2;
Stack_PcbW=38;

//CALCULATIONS// and some varibles

mot_cords=[[(mot_s[0]*cos(theta)+mot_s[2]*sin(theta))/2,mot_s[1]/2,(-mot_s[0]*sin(theta)+mot_s[2]*cos(theta))/2],
[(-mot_s[0]*cos(theta)-mot_s[2]*sin(theta))/2,mot_s[3]/2,(mot_s[0]*sin(theta)-mot_s[2]*cos(theta))/2]];

carbW=[30,20,4,2]; //wing [base width, tip width, thickness,radius]
carbWmin=1.5;
carbLWTO = [-5,-3,20]; //lower wing tip offset [x,y,z]
carbLWR=[10,20];//lower wing radius [front,rear]
carbLWP=[20,17.5,mot_cords[0][2]+carbLWTO[2]]; //lower wing placement [x,y,z]
carbUWP=[-15,(fs[1]+carbW[2])/2,carbLWP[2]+UWB_MO[1]]; //lower wing placement [x,y,z]
carbUWTO = [-1,-12,0]; //lower wing tip offset [x,y,z]
//carbB = 4;


LWXang = atan((mot_cords[0][2]+carbLWTO[2]-carbLWP[2])/(mot_cords[0][1]+carbLWTO[1]-carbLWP[1]));
UWXang = atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/(mot_cords[1][1]+carbUWTO[1]-carbUWP[1]));
UWRYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbW[1]-carbUWP[0]+carbW[0]-carbW[3]/2)));
UWFYang=abs(atan((mot_cords[1][2]+carbUWTO[2]-carbUWP[2])/cos(90-UWXang)/(mot_cords[1][0]+carbUWTO[0]-carbUWP[0]-carbW[3])));

//RENDERS///////////////////////////////////////////////////////////
wantToPrint=0;
rotate([0,0,0])for(i=[0,1])mirror([0,i,0]){
 //translate([0,0,carbLWP[2]-carbW[2]/2])fuse();
 
 translate([fs[0]/2+fusehozoff,0,carbLWP[2]-carbW[2]/2])mirror([1,0,0])thefuselage(fuseHt=fs[2],
frntDia=40,
rearDia=70.1,
RCT1 = CarRT,//rail carbon thickness
RCT2 = RCutT,//rail carbon thickness (cut thickness)
BCT1 =CarBT, //base carbon thickness
slotD=FR_SD[0],
tol=FR_tol,
totLength=fs[0],
fuseW=fs[1],
mergeR=[5,10],
mergeT=3);
 rotate([0,(180-theta)*wantToPrint,0])motMntL(39);
 rotate([0,(180-theta)*wantToPrint,0])motMntU(30);
 wingL();
 translate([wantToPrint*-100,wantToPrint*50,0])rotate([-UWXang*wantToPrint,0,0])wingU();
 rotate([180*wantToPrint,0,0])UWingBrace(MT1=UWB_MT1,MT2=UWB_MT2,Hdia=UWB_Hdia,WBMO=UWB_MO);
 if(wantToPrint==0){
	motSpace(0)rotate([0,theta,0])translate([0,0,17.5+motP_MT])for(i=[0:2:360]) rotate([0,0,i])cube([25.4*2.5,0.1,0.2]);
	motSpace(1)rotate([0,theta,0])translate([0,0,17.5+motP_MT])for(i=[0:2:360]) rotate([0,0,i])cube([25.4*2.5,0.1,0.2]);
 }
}

//MODULES//////////////////

module stackMountHoles(holeD=3.2,holeS=30.5){
 for(i=[0,90])rotate([0,0,i])translate([holeS/2,holeS/2,-10])cylinder(d=holeD,h=20); 
}

module UWingBrace(MT1=2,MT2=3,Hdia=3.2,WBMO=[5,5]){//wingbracemountoffset
 //translate(carbUWP-[carbW[0]+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWRYang,0])translate([0,-carbW[2]/2,0])cube([100,0.5,100]);
 //#translate(carbUWP-[carbW[0]*0-carbW[3]/2+0.1,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWFYang,0])translate([0,-carbW[2]/2,0])cube([100,0.5,100]);
 difference([]){
	union(){
	 hull(){
		braceMountSpace(3)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(3)cube([MT2+Hdia,MT2,MT1]);
		braceMountSpace(1)translate([-(MT2+Hdia)*1.5,0,0])cube([MT2+Hdia,MT2,MT1]);
	 }
	 hull(){
		braceMountSpace(2)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(0)translate([(MT2+Hdia)*1.5,0,0])cube([MT2+Hdia,MT2,MT1]);
	 }
	 
	 hull(){
		braceMountSpace(6)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(2)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(2)translate([-(MT2+Hdia)/2,-(MT2+Hdia)/2,0])cube([MT2+Hdia,MT2,MT1]);
		braceMountSpace(6)translate([-(MT2+Hdia)/2,-MT2+(MT2+Hdia)/2,0])cube([MT2+Hdia,MT2,MT1]);
	 }
	 hull(){
		braceMountSpace(3)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(6)cylinder(h=MT1,d=MT2+Hdia);
		braceMountSpace(3)translate([-(MT2+Hdia)/2,-(MT2+Hdia)/2,0])cube([MT2+Hdia,MT2,MT1]);
		braceMountSpace(6)translate([-(MT2+Hdia)/2,-MT2+(MT2+Hdia)/2,0])cube([MT2+Hdia,MT2,MT1]);
	 }
	 hull(){
		braceMountSpace(6)cylinder(h=UWB_minP,d=Hdia+MT2);
		braceMountSpace(5)cylinder(h=UWB_minP,d=Hdia+MT2);
	 }
	 hull(){
		braceMountSpace(6)cylinder(h=UWB_minP,d=Hdia+MT2);
		braceMountSpace(4)cylinder(h=UWB_minP,d=Hdia+MT2);
	 }
	 hull(){
		for(i=[0,1,5,4])braceMountSpace(i)cylinder(h=MT1,d=MT2+Hdia);
		 braceMountSpace(1)translate([-(MT2+Hdia)*1.5,0,0])cube([MT2+Hdia,MT2,MT1]);
		 braceMountSpace(0)translate([(MT2+Hdia)*1.5,0,0])cube([MT2+Hdia,MT2,MT1]);
	 }
	}
	union(){
        // base holes
	 for(i=[1:6])braceMountSpace(i){
		translate([0,0,-MT1*4])cylinder(h=MT1*8,d=Hdia);
		translate([0,0,MT1])cylinder(h=MT1*4,d=MT2+Hdia,$fn=UWB_HoS);
	 }
	 braceMountSpace(0){
		translate([0,0,-MT1*4])cylinder(h=MT1*6,d=Hdia);
		translate([0,0,MT1])cylinder(h=MT1*3,d=MT2+Hdia,$fn=UWB_HoS);
	 }
	 translate([-100,-1,carbLWP[2]+fs[2]-FR[0]/2-RCutT/2-UWB_Hdia/2+UWB_MT2/2])cube([200,200,100]);
	}
 }
}

module wingU(){
 difference(){
	hull(){
			motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3],-carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
			motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([+carbW[3],-carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
			translate(carbUWP) rotate([UWXang,0,0])translate([-carbW[3],carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
			translate(carbUWP-[carbW[0],0,0]) rotate([UWXang,0,0])translate([carbW[3],carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
	}
	union(){
	 motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 for(i=[4:6])braceMountSpace(i){translate([0,0,-UWB_MT1*4])cylinder(h=UWB_MT1*8,d=UWB_Hdia);}
	}
 }
}

module wingL(){
 frntWang=abs(atan((mot_cords[0][1]+carbLWTO[1]-carbLWP[1])/(mot_cords[0][0]-carbLWP[0])));
 rearWang=abs(atan((mot_cords[0][1]+carbLWTO[1]-carbLWP[1])/(mot_cords[0][0]+carbLWTO[0]-carbW[1]-carbLWP[0]+carbW[0])));
 translate(carbLWP) rotate([LWXang,0,0])translate([-carbW[3],0,-carbW[2]/2])angR(ht=carbW[2],ang=frntWang+2,R=carbLWR[0]);
 translate(carbLWP-[carbW[0],0,0]) rotate([LWXang,0,0])translate([carbW[3],0,-carbW[2]/2])mirror([1,0,0,])angR(ht=carbW[2],ang=180-rearWang+0.5,R=carbLWR[1]);
 difference(){
 hull(){
			motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3],-carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
			motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3],-carbW[3],-carbW[2]/2])cylinder(h=carbW[2],r=carbW[3]);
			translate(carbLWP) rotate([LWXang,0,0])translate([-carbW[3],0,-carbW[2]/2])cylinder(h=carbW[2],r=0.01);
			translate(carbLWP-[carbW[0],0,0]) rotate([LWXang,0,0])translate([carbW[3],0,-carbW[2]/2])cylinder(h=carbW[2],r=0.01);
  }
  union(){
	 motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
  }
 }
}


module motMntU(Hrot=30){
 difference(){
	union(){
		hull(){
		motSpace(1)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
		motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
		motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
	 }
	}
	union(){
	 motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles();
	 wingU();
	 motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 //motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
	 //motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
	 motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
	 motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
	 motSpace(1)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia);
	 wingU();
	}
 }
}

module motMntL(Hrot=30){
 difference(){
	union(){
		hull(){
		motSpace(0)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
		motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
		motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
	 }
	}
	union(){
	 motSpace(0)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles();
	 wingL();
	 motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 //motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
	 //motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
	 motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5-50])cylinder(h=motP_MT2*4+50,d=motP_WMHD);
	 motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
	 motSpace(0)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia);
	 wingL();
	}
 }
}

module motMntHoles(){
 coneht=tan(motP_CA)*(motP_CD-motP_mntD)/2;
 for(k=[[0,0],[90,2]])rotate([0,0,k[0]])for(j=[0,1])mirror([0,j,0]){
	hull()for(i=[0,1])translate([0,motP_mntS[i+k[1]],0])translate([0,0,-0.1])cylinder(h=motP_MT*5+0.2,d=motP_mntD);
	hull()for(i=[0,1])translate([0,motP_mntS[i+k[1]],-coneht])cylinder(h=coneht,d1=motP_CD,d2=motP_mntD);
	hull()for(i=[0,1])translate([0,motP_mntS[i+k[1]],-coneht-100+0.01])cylinder(h=100,d=motP_CD);
 }
}
module motMnts(){
    translate(DSmotT)rotate(DSmotR)for(i=[mot_s[0]/2,-mot_s[0]/2],j=[mot_s[1]/2,-mot_s[1]/2]){
        translate([i,j,0])difference(){
            union(){
                cylinder(h=motP_MT,d=motP_dia);
                %translate([0,0,10]) cylinder(h=2,d=125);
            }
            //motMntHoles();
        }//end diffence
    }
}

module thefuselage(fuseHt=40,frntDia=45,rearDia=180,RCT1 = 4.5,//rail carbon thickness
RCT2 = 5,//rail carbon thickness (cut thickness)
BCT1 =4, //base carbon thickness
slotD=6,tol=0.1,totLength=150,fuseW=40,mergeR=[5,10],boltD=3.2,mergeT=3){
 difference(){
	union(){
	 translate([0,0,0])fuseB(frntDia,rearDia,fuseW,fuseHt,BCT1,RCT1,RCT2,totLength,tol,slotD,mergeT,mergeR);
	 translate([80*wantToPrint,0,0])fuseSlot(rearDia,fuseHt,BCT1,RCT2,slotD,totLength,fuseW,RCT1);
	 //#translate([+fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0])translate([carbUWP[0]-carbW[0]+10,fs[1]/2-CarRT,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT)/sin(UWRYang)])rotate([0,90-UWRYang,0])cube([10,CarRT,10])
	 //translate([fs[0]/2-10,0,carbLWP[2]*0-carbW[2]/2*0])mirror([1,0,0])translate([carbUWP[0]-carbW[0],fs[1]/2+CarRT,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT)/sin(UWRYang)])cylinder(h=5,d=10);
	 translate([0,fuseW/2-RCT1+wantToPrint*70,0])rotate([wantToPrint*270,0,0]){
		difference(){
		 union(){
			railHalf(thedia=frntDia,theheight=fuseHt,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
			translate([totLength,0,BCT1])mirror([1,0,0])railHalf(thedia=rearDia,theheight=fuseHt-BCT1,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
			translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
			 translate([carbUWP[0]-carbW[0],+CarRT,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWRYang)])rotate([90,0,0])cylinder(h=CarRT,d=RCT2+UWB_Hdia);
			 translate([carbUWP[0],+CarRT,carbLWP[2]])rotate([0,UWFYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWFYang)])rotate([90,0,0])cylinder(h=CarRT,d=RCT2+UWB_Hdia);
			}
		 }
		 union(){
			translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
			 translate([carbUWP[0]-carbW[0],UWB_MT1*3+CarRT,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWRYang)])rotate([90,0,0])cylinder(h=UWB_MT1*15,d=UWB_Hdia);
			 translate([carbUWP[0],UWB_MT1*3+CarRT,carbLWP[2]])rotate([0,UWFYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWFYang)])rotate([90,0,0])cylinder(h=UWB_MT1*15,d=UWB_Hdia);
			}
		 }
		}
	 }
	}
	union(){
	 translate([fs[0]-Stack_PcbW/2-slotD-RCutT,0,0])stackMountHoles(Stack_HD,Stack_HS);
	 translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
		translate([carbUWP[0]-carbW[0]+UWB_MT2/2+UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*8,d=UWB_Hdia);
		translate([carbUWP[0]-UWB_MT2/2-UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*7,d=UWB_Hdia);
		rearOff=getOffset(rearDia,fuseHt,BCT1,RCT2);
		fuseSlotMountHoles(rearOff);
	 }
	}
 }
}



module Rmerge(ht=3,dp=3,ang=30,R1=3,R2=3){
 difference(){
	union(){
	 translate([0,dp-R1,0])cylinder(h=ht,r=R1);
	 translate([0,dp-R1,0])rotate([0,0,-ang])translate([0,-dp+R1,0])cube([(dp-R1)/tan(ang)+R1/sin(ang),dp,ht]);
	 translate([(dp-R1)/tan(ang)+R1/sin(ang),0,0])angR(ht=ht,ang=180-ang,R=R2);
	}
	union(){
	 translate([-R1,-R1*2-dp,-0.1])cube([(dp-R1)/tan(ang)+R1/sin(ang)+R1*2+R2+2,R1*2+dp,ht+0.2]);
	 translate([-R1,0,-0.1])cube([R1,R1+dp,ht+0.2]);
	}
 }
}

module angR(ht=3,ang=120,R=3){
 difference(){
	hull()for(i=[0,ang])rotate([0,0,i])cube([R/tan(ang/2),0.001,ht]);
	translate([R/tan(ang/2),R,-0.1])cylinder(h=ht+0.2,r=R);
	
 }
}

module fuseSlot(rearDia,fuseHt,BCT1,RCT2,slotD,totLength,fuseW,RCT1){
 rearOff=getOffset(rearDia,fuseHt,BCT1,RCT2);
 difference(){
	union(){
	 translate([totLength-rearOff-RCT2-slotD,fuseW/2-RCT1-RCT2,BCT1])cube([slotD,RCT1+RCT2,BCT1]);
	 translate([totLength-rearOff-RCT2,0,BCT1])cube([RCT2,fuseW/2-RCT1,BCT1]);
	}
	union(){
	 //cylinder(h=5,d=2);
	}
 }
}
module fuseSlotMountHoles(rearOff){
 translate([fs[0]/2+fusehozoff,0,+carbLWP[2]-carbW[2]/2])mirror([1,0,0]){
	translate([fs[0]-rearOff-RCutT/2,fs[2]/2-CarRT*2,-CarBT*5])cylinder(d=3.2,h=CarBT*10);
 }
}
module fuseB(frntDia,rearDia,fuseW,fuseHt,BCT1,RCT1,RCT2,totLength,tol,slotD,mergeT,mergeR){
 frntOff=getOffset(frntDia,fuseHt,BCT1,RCT2);
 rearOff=getOffset(rearDia,fuseHt,BCT1,RCT2);
 difference(){
	union(){
	 translate([frntOff,-0.1,0])cube([totLength-frntOff-rearOff,fuseW/2+0.1,BCT1]); 
	 //fron side brace
	 translate([frntOff,fuseW/2+tol,0])cube([slotD+RCT1,mergeT,BCT1]);
	 translate([frntOff+slotD,fuseW/2,0])cube([RCT1,mergeT,BCT1]);
	 translate([frntOff+slotD+RCT1,fuseW/2,0])Rmerge(ht=BCT1,dp=mergeT+tol,R1=mergeR[0],R2=mergeR[1]);
	 //rear side brace
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2+tol,0])cube([RCT2+tol+slotD*2+0.1+RCT1,mergeT,BCT1]);
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2,0])cube([RCT1,mergeT,BCT1]);
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2,0])mirror([1,0,0])Rmerge(ht=BCT1,dp=mergeT+tol,R1=mergeR[0],R2=mergeR[1]);
	 translate([totLength-rearOff,0,0])cube([mergeT,fuseW/2+mergeT+tol,BCT1]);
	}
	union(){
	 translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
		for(i=[0,1])braceMountSpace(i){
			translate([0,0,-UWB_MT1*4])cylinder(h=UWB_MT1*8,d=UWB_Hdia);
		}
	 }
	}
 }
}

module railHalf(thedia=120,theheight=40,thick1=4,thick2=5,leng=80,carT=4,slotD=8,leng=60,,tol=0.1){
 frntRingHtO=thedia>theheight*1.5?carT+thick2:(carT-thick2)/2;
 frntRingHt=theheight-frntRingHtO;
 theoffset3=thedia>theheight*2?thedia/2:sqrt(abs((thedia/2)*(thedia/2)-((-thedia/2+frntRingHt)*(-thedia/2+frntRingHt))));
 difference(){
	union(){
	 translate([0,0,frntRingHtO])ringPart(thedia=thedia,theheight=frntRingHt,thick1=thick1,thick2=thick2,leng=leng,carT=carT,slotD=slotD);
	 clip(thedia/2-theoffset3,carT,thick1,thick2,slotD,tol);
	}
	union(){
	}
 }
}

module clip(aoffset,carT,thick1,thick2,slotD,tol){
	translate([aoffset,0,-thick2])cube([thick2,thick1,thick2*2+carT+tol/2]);
	translate([aoffset,0,-thick2])cube([slotD+thick2,thick1,thick2]);
	translate([aoffset,0,carT+tol/2])cube([slotD+thick2,thick1,thick2]);
}

module ringPart(thedia=120,theheight=40,thick1=4,thick2=5,leng=80,carT=4,slotD=8){
    theoffset3=sqrt((thedia/2)*(thedia/2)-((-thedia/2+theheight)*(-thedia/2+theheight)));
    thedia=thedia<theheight?theheight:thedia;
    circCenter=-thedia/2+theheight;
    theoffset=thedia>theheight*2?sqrt((thedia/2)*(thedia/2)-(circCenter*circCenter)):thedia/2;
    theoffset2=thedia>theheight*2?0:theoffset;
    rotate([0,0,180])difference(){
        union(){
            translate([-theoffset,0,circCenter]) rotate([90,0,0]) cylinder(h=thick1,d=thedia);
            translate([-leng,-thick1,circCenter+thedia/2-thick2])cube([leng-theoffset,thick1,thick2]);
        }
        union(){
            translate([-theoffset,0.1,circCenter]) rotate([90,0,0]) cylinder(h=thick1+5,d=thedia-thick2*2);
            translate([-thedia,-thick1-0.1,-thedia-0.1])cube([thedia*2,thick1+0.2,thedia+0.1]);
            translate([-thedia-theoffset,-thick1-0.1,-0.1])cube([thedia,thick1+0.2,circCenter+thedia/2+0.1-thick2]);
            translate([-thedia*1.5+theoffset3-thick2,-thick1-0.1,-0.1])cube([thedia,thick1+0.2,circCenter]);
        }
    }
}

module axis(size = 50){    
    color("blue"){
        cylinder(h=size,d=0.5);
        translate([0,0,size])rotate([90,0,0])text("Z");
    }
    color("green"){
        rotate([-90,0,0])cylinder(h=size,d=0.5);
        translate([0,size,0])text("Y");
    }
    color("red"){
        rotate([0,90,0])cylinder(h=size,d=0.5);
        translate([size,0,0])rotate([0,0,-90])text("X");
    }    
}

//COORDINATE SPACE MODULES
module motSpace(lowOrUp = 0){
    if(lowOrUp==0){
        translate([mot_cords[0][0],mot_cords[0][1],mot_cords[0][2]]){children();}
    } else if(lowOrUp==1){
        translate([mot_cords[1][0],mot_cords[1][1],mot_cords[1][2]]){children();}
    } else{echo("motSpace() index out of range");}
}

module braceMountSpace(holeIndex = 0){
    if(holeIndex==0){//front fuselage base mount
        translate([carbUWP[0]-UWB_MT2/2-UWB_Hdia,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2]){children();}
    } else if(holeIndex==1){//rear fuselage base mount
        translate([carbUWP[0]-carbW[0]+UWB_MT2/2+UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2]){children();}
    } else if(holeIndex==2){//front rail mount
        translate([carbUWP[0],fs[1]/2-UWB_MT1*0+CarRT*0,carbLWP[2]])rotate([0,UWFYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWFYang)])rotate([0,-UWFYang+90,0])rotate([-90,0,0]){children();}
    } else if(holeIndex==3){//rear rail mount
        translate([carbUWP[0]-carbW[0],fs[1]/2-UWB_MT1*0+CarRT*0,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)/cos(90-UWRYang)])rotate([0,-UWRYang+90,0])rotate([-90,0,0]){children();}
    } else if(holeIndex==4){//front wing base mount
        translate(carbUWP-[-carbW[3]/2+UWB_MO[0]*1.3,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWFYang,0])translate([0,-carbW[2]/2,(UWB_MT2+UWB_Hdia+UWB_MO[1])/(2*cos(90-UWFYang)*cos(90-UWXang))])rotate([90,0,0]){children();}
    } else if(holeIndex==5){//rear wing base mount
        translate(carbUWP-[carbW[0]+carbW[3]*0-UWB_MO[0],0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWRYang,0])translate([0,-carbW[2]/2,(UWB_MT2+UWB_Hdia+UWB_MO[1])/(2*cos(90-UWRYang)*cos(90-UWXang))])rotate([90,0,0]){children();}
    } else if(holeIndex==6){//top centre wing mount
        //translate(carbUWP-[carbW[0]/2+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+(UWRYang+UWRYang)/2,0])translate([0,-carbW[2]/2,(fs[2]-(UWB_MT2*2+UWB_Hdia*2+RCutT)/2-UWB_MO[1])/(cos(90-UWRYang)*cos(90-UWXang))])rotate([0,90-(UWRYang+UWRYang)/2,0])rotate([90,0,0]){children();}
		    translate(carbUWP-[carbW[0]/2+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+(UWRYang+UWRYang)/2,0])translate([0,-carbW[2]/2,(-UWB_MO[1]+fs[2]-FR[0]-RCutT/2-UWB_Hdia/2)/(cos(90-UWRYang)*cos(90-UWXang))])rotate([0,90-(UWRYang+UWRYang)/2,0])rotate([90,0,0]){children();}
		    //(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)
    } else{echo("braceMountSpace() index out of range");}
}

//FUNCTIONS
function getOffset(dia,ht,BCT1,RCT2)=
 let(newht=ht-(dia>ht*1.5?BCT1+RCT2:(BCT1-RCT2)/2))
 dia>ht*2?0:dia/2-(sqrt(abs((dia/2)*(dia/2)-((-dia/2+newht)*(-dia/2+newht)))));
