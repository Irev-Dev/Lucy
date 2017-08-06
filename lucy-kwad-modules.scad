module thecam(index=0){
    //translate([72,0,cos(theta-camA)*(camD/2)+carbLWP[2]+CarBT/2])rotate([0,theta-camA,0])difference(){
    if(index==0){
        translate([54+fusehozoff,0,carbLWP[2]+CarBT/2+camMH])difference(){
            union(){
                //bracket
                translate([-camM[0]/2,camM[1]/2-camM[3],-camM[4]])cube([camM[0],camM[3],camM[2]]);
                translate([-camM[0]/2,0,-camM[4]])cube([camM[0],camM[1]/2,camM[3]]);
                rotate([0,theta-camA,0])hull(){//camera unit
                    translate([-camPP,-camW/2,-camH/2])cube([10,camW,camH]);
                    translate([camL-camPP,0,0])rotate([0,90,0])cylinder(d=camD,h=0.01);
                    
                }
            }
            union(){
                translate([0,camM[6]/2,-50])cylinder(d=camM[5],h=40);
                
            }
        }  
    } else{
        translate([54+fusehozoff,0,carbLWP[2]+CarBT/2+camMH])translate([0,camM[6]/2,-50])cylinder(d=camM[5],h=40);
        
    }
}
module stackMountHoles(holeD=3.2,holeS=30.5){
 //for(i=[0,90])rotate([0,0,i])translate([holeS/2,holeS/2,-10])cylinder(d=holeD,h=20); 
 for(i=[0,90])rotate([0,0,i])translate([holeS/2,holeS/2,-10])circle(d=holeD); 
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
	 for(i=[1:6])braceMountSpace(i){// loop through different hole positings and remove material
		translate([0,0,-MT1*4])cylinder(h=MT1*8,d=Hdia);
		translate([0,0,MT1])cylinder(h=MT1*4,d=MT2+Hdia,$fn=UWB_HoS);
	 }
	 braceMountSpace(0){//The height of the hole being subtracted here is sensitive, which is why it's outside the above loop
		translate([0,0,-MT1*4])cylinder(h=MT1*6,d=Hdia);
		translate([0,0,MT1])cylinder(h=MT1*3,d=MT2+Hdia,$fn=UWB_HoS);
	 }
	 translate([-100,-1,carbLWP[2]+fs[2]-FR[0]/2/*-RCutT/2-UWB_Hdia/2+UWB_MT2/2*/])cube([200,200,100]);
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
module wingUrev2(shellT=6.2,tol_expand=0){
	difference(){
		union(){
			UpperWingSpace()tranZ(-(carbW[2]+tol_expand)/2)linear_extrude(carbW[2]+tol_expand)offset(tol_expand)shellInwards2d(shellT,0,1)difference(){
				polygon(polyRound(UWingRP,20,0));	
				if(shellT<99)translate(UWing_MMH)circle(d=motP_mntD);//don't include if shell i very large as it is being used to differnce from the motor mount and it causes trouble included
			}
		}
		union(){
			//UpperWingMMHSpace()tranZ(-25)cylinder(d=motP_mntD,h=50);
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
				for(i=[25,65])motSpace(1)rotate([0,theta,0])rotate([0,0,i])translate([0,motP_dia/2+motP_MG[1],0]) cylinder(h=motP_MT,d=motP_MG[0]);
				UpperWingSpace()tranZ(-carbW[2]/2-motP_MT2)linear_extrude(carbW[2]+motP_MT2*2)offset(motP_MT2)polygon(polyRound(UWing_MMP,20,0));	
				//motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
				//motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
			}	
			//translate([0,carbUWP[1],carbUWP[2]])rotate([UWXang,0,0])translate([0,0,-4])linear_extrude(8)offset(2)polygon(polyRound(p,20,0));	
		}
		union(){
			//slightly better than below but hard to print motSpace(1)rotate([0,theta,0]) translate([0,0,motP_MT])cylinder(h=motP_MT*2,d1=motP_dia*1.2,d2=motP_dia*1.2+motP_MT*10);
			motSpace(1)rotate([0,theta,0]) translate([0,0,motP_MT])cylinder(h=motP_MT*2,d=motP_dia*5);
			motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles();
			UpperWingMMHSpace(){
				tranZ(-25)cylinder(d=motP_mntD,h=50);
				tranZ(motP_MT2/2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15);
				tranZ(-motP_MT2-10)cylinder(d=motP_HD,h=10,$fn=motP_HoS);
				}
			//wingU();
			//motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
			//motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
			//motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
			//motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3],-carbW[3],carbW[2]/2+motP_MT2-motP_WMFDp])cylinder(h=carbW[2]+motP_MT2*10,d=motP_WMFD,$fn=motP_WMFS);
			//motSpace(1) translate(carbUWTO) rotate([UWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
			//motSpace(1) translate(carbUWTO-[carbW[1],0,0]) rotate([UWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
			motSpace(1)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia);
			wingUrev2(100,0.2);
			//wingU();
		}
	}
}
module motMntL(Hrot=30){
 difference(){
	union(){
		hull(){
		motSpace(0)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
        for(i=[25,65])motSpace(0)rotate([0,theta,0])rotate([0,0,i])translate([motP_dia/2+motP_MG[1],0,0]) cylinder(h=motP_MT,d=motP_MG[0]);
		tranZ(carbLWP[2]-carbW[2]/2-motP_MT2)linear_extrude(carbW[2]+motP_MT2*2)offset(motP_MT2)polygon(polyRound(LWing_MMP,20,0));	
		//motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
		//motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2])cylinder(h=motP_MT2,r=motP_BR);
	 }
	}
	union(){
	 motSpace(0)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles();
	 motSpace(0)rotate([0,theta,0]) tranZ(motP_MT)cylinder(h=motP_MT*5,d=motP_dia*10);
	 translate([LWing_MMH[0],LWing_MMH[1],carbLWP[2]-carbW[2]/2]){
		tranZ(-25)cylinder(d=motP_mntD,h=50);
		tranZ(motP_MT2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15);
		tranZ(-motP_MT2-10)cylinder(d=motP_HD,h=10,$fn=motP_HoS);
	 }
	 // motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 // motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=carbW[2]+motP_MT2*10,d=motP_mntD);
	 // motSpace(0) translate(carbLWTO) rotate([LWXang,0,0])translate([-carbW[3]-carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5-50])cylinder(h=motP_MT2*4+50,d=motP_WMHD);
	 // motSpace(0) translate(carbLWTO-[carbW[1],0,0]) rotate([LWXang,0,0])translate([carbW[3]+carbWmin,-carbW[3]-carbWmin,-carbW[2]/2-motP_MT2*5])cylinder(h=motP_MT2*4,d=motP_WMHD);
	 motSpace(0)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia);
	 fuseRev2(100,0.2);
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
        }//end diffence
    }
}
module fuseRailsRev2(){
	l=fs[0];//fuselage length
	w=fs[1];
	h=fs[2];//fuselage height
	offs=fusehozoff;
	rearRailClip=[
[-l/2+offs+FR_SD[0]+FR_CuT*tan(FR_RA),	CarBT+FR_CuT,   		15],
[-l/2+offs+FR_SD[0]+FR_SD[1],     			CarBT+FR_tol,       0],
[-l/2+offs+FR_SD[0],              			CarBT+FR_tol,       FR_MIR],
[-l/2+offs+FR_SD[0],              			0,                  FR_MIR],
[-l/2+offs+FR_SD[0]+FR_SD[1],     			0,                  0],
[-l/2+offs+FR_SD[0],              			-FR_MT,             FR_SR],
[-l/2+offs+FR_SD[0]-FR_CuT,       			-FR_MT,             FR_SR],
[-l/2+offs+FR_SD[0]-FR_CuT,       			CarBT+FR_CuT,       10],
	];

	frontRailClip=[
[l/2+offs-fs_minT,                    	CarBT+FR_MT+FR_BHH, 0],
[l/2+offs-fs_minT,                    	0,   		    				1],
[l/2+offs-fs_minT-FR_CuT,               0,			       			1],
[l/2+offs-fs_minT-FR_CuT,               CarBT,			       	FR_MIR],
[l/2+offs-fs_minT-FR_CuT-(FR_BHD-FR_BD)/2,CarBT,			      0],
[l/2+offs-fs_minT-FR_CuT-(FR_BHD-FR_BD)/2,CarBT+FR_MT,	    0],
[l/2+offs-fs_minT-FR_CuT,								CarBT+FR_MT,	    	FR_MIR],
[l/2+offs-fs_minT-FR_CuT,								CarBT+FR_MT+FR_BHH,	FR_MIR],
[l/2+offs-fs_minT-FR_CuT-FR_BHD,				CarBT+FR_MT+FR_BHH,	FR_MIR],
[l/2+offs-fs_minT-FR_CuT-FR_BHD,				CarBT+FR_MT,				FR_MIR],
[l/2+offs-fs_minT-FR_CuT-(FR_BHD+FR_BD)/2,CarBT+FR_MT,				0],
[l/2+offs-fs_minT-FR_CuT-(FR_BHD+FR_BD)/2,CarBT,							0],
[l/2+offs-fs_minT-FR_CuT-FR_BHD-FR_MT,	CarBT,							1],
[l/2+offs-fs_minT-FR_CuT-FR_BHD-FR_MT,	CarBT+FR_MT+FR_BHH,	10]
	];
      
	railPoints=concat(
rearRailClip,[
[-l/2+offs+FR_SD[0]-FR_CuT+h*tan(FR_RA),h,            			FR_R1],
[l/2+offs+FR_OH,                  			h,                  FR_R2],
[l/2+offs-fs_minT,                      h/2,                FR_R3]
],
frontRailClip,[
[l/2+offs-fs_minT-FR_CuT,               h/2-FR_CuT*tan((atan(h/2/FR_OH)+90)/2+90),FR_R3+FR_CuT],
[l/2+offs+FR_OH+FR_CuT*tan(atan(h/2/FR_OH)/2+90),h-FR_CuT,2],
[-l/2+offs+FR_SD[0]-FR_CuT+h*tan(FR_RA)+FR_CuT/tan((FR_RA-90)/2+90),h-FR_CuT,FR_R1-FR_CuT]
]
	);
	translate([0,w/2,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(CarRT)polygon(polyRound(railPoints,5,0));

}
module fuseRev2(shellT=6.5,tol_expand=0){
    tranZ(carbLWP[2]-carbW[2]/2){
		/*hull(){
			translate([carbLWP[0]-carbW[0],fs[1]/2,0])cylinder(h=6,d=1);
			translate([mot_cords[0][0]+carbLWTO[0]-carbW[1],mot_cords[0][1]+carbLWTO[1],0])cylinder(h=6,d=1);
		}*/
		
		fs_postP=[
[fusehozoff+l/2-fs_minT+fs_mir,			w/2+FR_tol/2,		fs_mir],
//[fusehozoff+l/2-fs_minT,				w/2-CarRT/2-FR_tol/4,0],
[fusehozoff+l/2-fs_minT+fs_mir,			w/2-CarRT-FR_tol/2,	fs_mir],
[fusehozoff+l/2-fs_minT-FR_CuT-fs_mir,	w/2-CarRT-FR_tol/2,	fs_mir],
//[fusehozoff+l/2-fs_minT-FR_CuT,			w/2-CarRT/2-FR_tol/4,0],
[fusehozoff+l/2-fs_minT-FR_CuT-fs_mir,	w/2+FR_tol/2,		fs_mir]
		];				
		tranZ(-tol_expand/2)linear_extrude(CarBT+tol_expand){
			difference(){
				offset(tol_expand)shellInwards2d(shellT,0,1.7)difference(){
					union(){
						polygon(polyRound(mirrorYpoints(fs_basePoints),20,0));
					}
					union(){
						for(i=[0:1])mirror([0,i,0]){
							polygon(polyRound(fs_postP,20,0));
							if(shellT<99)translate(LWing_MMH)circle(d=motP_mntD);//don't include if shell i very large as it is being used to differnce from the motor mount and it causes trouble included
							//translate([fusehozoff+l/2-fs_minT-FR_CuT-FR_BHD/2,w/2-CarRT/2])circle(d=3.2);
							translate([l/2+fusehozoff-fs_minT-FR_CuT-FR_BHD/2/*+FR_BD/2*/,w/2-CarRT/2])circle(d=3.2);
							for(i=[-70,-70/*20*/])translate([i,0,0])stackMountHoles();
						}
					}
				}
				//offset(2)offset(-8)polygon(polyRound(mirrorYpoints(fs_basePoints,20,0)));
			}
		}
	}
}
module thefuselage(fuseHt=40,frntDia=45,rearDia=180,RCT1 = 4.5,//rail carbon thickness
RCT2 = 5,//rail carbon thickness (cut thickness)
BCT1 =4, //base carbon thickness
slotD=6,tol=0.1,totLength=150,fuseW=40,mergeR=[5,10],boltD=3.2,mergeT=3){
 difference(){
	union(){
	 translate([0,0,0])fuseB(frntDia,rearDia,fuseW,fuseHt,BCT1,RCT1,RCT2,totLength,tol,slotD,mergeT,mergeR);
	 //translate([80*wantToPrint,0,0])fuseSlot(rearDia,fuseHt,BCT1,RCT2,slotD,totLength,fuseW,RCT1);
	 translate([0,fuseW/2-RCT1+wantToPrint*70,0])rotate([wantToPrint*270,0,0]){
		difference(){
		 union(){
			railHalf(thedia=frntDia,theheight=fuseHt,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
             //back half
			//#translate([totLength,0,BCT1])mirror([1,0,0])railHalf(thedia=rearDia,theheight=fuseHt-BCT1,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
             translate([totLength,0,BCT1])mirror([1,0,0])railHalfRear(thedia=rearDia,theheight=fuseHt-BCT1,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
			translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
                braceMountSpace(2)translate([0,0,-fuseW/2])cylinder(h=CarRT,d=RCT2+UWB_Hdia);
                braceMountSpace(3)translate([0,0,-fuseW/2])cylinder(h=CarRT,d=RCT2+UWB_Hdia);
			}
		 }
		 union(){
			translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
                braceMountSpace(2)translate([0,0,-fuseW/2-UWB_MT1*7])cylinder(h=UWB_MT1*15,d=UWB_Hdia);
                braceMountSpace(3)translate([0,0,-fuseW/2-UWB_MT1*7])cylinder(h=UWB_MT1*15,d=UWB_Hdia);
			}
		 }
		}
	 }
	}
	union(){
	 translate([fs[0]-Stack_PcbW/2-5,0,0])stackMountHoles(Stack_HD,Stack_HS);
     translate([camL+Stack_PcbW/2+13.7,0,0])stackMountHoles(Stack_HD,Stack_HS);
	 translate([fs[0]/2+fusehozoff,0,-carbLWP[2]+carbW[2]/2])mirror([1,0,0]){
		//translate([carbUWP[0]-carbW[0]+UWB_MT2/2+UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*8,d=UWB_Hdia);
		//translate([carbUWP[0]-UWB_MT2/2-UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*7,d=UWB_Hdia);
		rearOff=getRearOffset(rearDia,fuseHt,BCT1,RCT2);
         thecam(1);
		//fuseSlotMountHoles(rearOff);
        
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
	//translate([fs[0]-rearOff-RCutT/2,fs[2]/2-CarRT*2,-CarBT*5])cylinder(d=3.2,h=CarBT*10);
    #translate([fs[0]-rearOff-RCutT,fs[2]/2-CarRT*2,-CarBT*5])cube([RCutT,CarRT,CarBT*10]);
 }
}
module fuseB(frntDia,rearDia,fuseW,fuseHt,BCT1,RCT1,RCT2,totLength,tol,slotD,mergeT,mergeR){
 //need to fix up toll in here
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
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2+tol*0,0])cube([RCT2+tol+slotD*2+0.1+RCT1,mergeT,BCT1]);
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2,0])cube([RCT1,mergeT,BCT1]);
	 translate([totLength-rearOff-RCT1-(RCT2+tol+slotD*2+0.1),fuseW/2,0])mirror([1,0,0])Rmerge(ht=BCT1,dp=mergeT+tol,R1=mergeR[0],R2=mergeR[1]);
	 translate([totLength-rearOff,0,0])cube([mergeT,fuseW/2+mergeT+tol,BCT1]);
	}
	union(){
        translate([totLength,fuseW/2-RCT1,BCT1])mirror([1,0,0])railHalfRear(thedia=rearDia,theheight=fuseHt-BCT1,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol,bolt=1);
        translate([0,fuseW/2-RCT1,0])railHalf(thedia=frntDia,theheight=fuseHt,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);        
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
     translate([thedia/2,0,-thedia/2+theheight])rotate([0,40,0])translate([-thedia/2+thick2/2+1.6,0,0])rotate([-90,0,0])cylinder(h=thick1,d=thick2+3.2);
	 translate([0,0,frntRingHtO])ringPart(thedia=thedia,theheight=frntRingHt,thick1=thick1,thick2=thick2,leng=leng,carT=carT,slotD=slotD);
	 clip(thedia/2-theoffset3,carT,thick1,thick2,slotD,tol);
	}
	union(){
        translate([thedia/2,0,-thedia/2+theheight])rotate([0,40,0])translate([-thedia/2+thick2/2+1.6,-thick1*3,0])rotate([-90,0,0])cylinder(h=thick1*6,d=3.2);
	}
 }
}
module railHalfRear(thedia=120,theheight=40,thick1=4,thick2=5,leng=80,carT=4,slotD=8,leng=60,tol=0.1,bolt=0){
 //frntRingHtO=thedia>theheight*1.5?carT+thick2:(carT-thick2)/2;
 frntRingHtO=0;
 frntRingHt=theheight-frntRingHtO;
 theoffset3=thedia>theheight*2?thedia/2:sqrt(abs((thedia/2)*(thedia/2)-((-thedia/2+frntRingHt)*(-thedia/2+frntRingHt))));
 difference(){
	union(){
        if(bolt>0){
            translate([thedia/2-theoffset3+thick2+rearF_nf/2,thick1/2,-25])cylinder(d=rearF_bd,h=50);
        }
	 translate([0,0,frntRingHtO])ringPart(thedia=thedia,theheight=frntRingHt,thick1=thick1,thick2=thick2,leng=leng,carT=carT,slotD=slotD);
        hull(){
            translate([thedia/2,0,-thedia/2+theheight])rotate([0,rearF_ha,0])translate([-thedia/2+thick2/2,0,0])rotate([-90,0,0])cylinder(h=thick1,d=thick2);
            translate([thedia/2-theoffset3,0,0])cube([thick2*2+rearF_nf,thick1,thick1*0.7+rearF_nh]);
        }
        translate([thedia/2-theoffset3,0,-FR[0]])cube([thick2,thick1,FR[0]+0.01]);
	}
	union(){
        translate([thedia/2-theoffset3+thick2,-thick1/2,thick1*0.7])cube([rearF_nf,thick1*2,rearF_nh]);
        translate([thedia/2-theoffset3+thick2+(rearF_nf-rearF_bd)/2,-thick1/2,-0.01])cube([rearF_bd,thick1*2,rearF_nh+thick1*0.7]);
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
// handly modules, not of specific parts
module shellInwards2d(off,OR,IR){
	difference(){
		children();
		round2d(IR,OR)offset(-off)children();
	}
}
module round2d(OR=3,IR=1){
    offset(OR)offset(-IR-OR)offset(IR)children();
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
module UpperWingMMHSpace(){
	UpperWingSpace()translate(UWing_MMH)children();
}
module UpperWingSpace(){
	translate([0,carbUWP[1],carbUWP[2]])rotate([UWXang,0,0])children();
}
module tranZ(offset){
	translate([0,0,offset])children();
}
module motSpace(lowOrUp = 0){
    if(lowOrUp>1){
		echo("motSpace() index out of range");
	}else{
    translate([mot_cords[lowOrUp][0],mot_cords[lowOrUp][1],mot_cords[lowOrUp][2]])children();}
}
module braceMountSpace(holeIndex = 0){
    if(holeIndex==0){//front fuselage base mount
        translate([carbUWP[0]-UWB_MT2/2-UWB_Hdia,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2]){children();}
    } else if(holeIndex==1){//rear fuselage base mount
        translate([carbUWP[0]-carbW[0]+UWB_MT2/2+UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2]){children();}
    } else if(holeIndex==2){//front rail mount
        translate([carbUWP[0],fs[1]/2,carbLWP[2]])rotate([0,UWFYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2)/cos(90-UWFYang)])rotate([0,-UWFYang+90,0])rotate([-90,0,0]){children();}
    } else if(holeIndex==3){//rear rail mount
        translate([carbUWP[0]-carbW[0],fs[1]/2,carbLWP[2]])rotate([0,UWRYang-90,0])translate([0,0,(fs[2]-FR[0]/2-RCutT/2)/cos(90-UWRYang)])rotate([0,-UWRYang+90,0])rotate([-90,0,0]){children();}
    } else if(holeIndex==4){//front wing base mount
        translate(carbUWP-[-carbW[3]/2+UWB_MO[0]*1.3,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWFYang,0])translate([0,-carbW[2]/2,(UWB_MT2+UWB_Hdia+UWB_MO[1])/(2*cos(90-UWFYang)*cos(90-UWXang))])rotate([90,0,0]){children();}
    } else if(holeIndex==5){//rear wing base mount
        translate(carbUWP-[carbW[0]+carbW[3]*0-UWB_MO[0],0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWRYang,0])translate([0,-carbW[2]/2,(UWB_MT2+UWB_Hdia+UWB_MO[1])/(2*cos(90-UWRYang)*cos(90-UWXang))])rotate([90,0,0]){children();}
    } else if(holeIndex==6){//top centre wing mount
        //translate(carbUWP-[carbW[0]/2+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+(UWRYang+UWRYang)/2,0])translate([0,-carbW[2]/2,(fs[2]-(UWB_MT2*2+UWB_Hdia*2+RCutT)/2-UWB_MO[1])/(cos(90-UWRYang)*cos(90-UWXang))])rotate([0,90-(UWRYang+UWRYang)/2,0])rotate([90,0,0]){children();}
		    translate(carbUWP-[carbW[0]/2+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+(UWRYang+UWRYang)/2,0])translate([0,-carbW[2]/2,(-UWB_MO[1]+fs[2]-FR[0]-RCutT/2)/(cos(90-UWRYang)*cos(90-UWXang))])rotate([0,90-(UWRYang+UWRYang)/2,0])rotate([90,0,0]){children();}
		    //(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)
    } else{echo("braceMountSpace() index out of range");}
}
//FUNCTIONS
function getRearOffset(dia,ht,BCT1,RCT2)=
 let(newht=ht-(dia>ht*1.5?BCT1+RCT2:(BCT1-RCT2)/2))
 dia>ht*2?0:dia/2-(sqrt(abs((dia/2)*(dia/2)-((-dia/2+newht)*(-dia/2+newht)))));

function getOffset(dia,ht,BCT1,RCT2)=
 let(newht=ht-(dia>ht*1.5?BCT1+RCT2:(BCT1-RCT2)/2))
 dia>ht*2?0:dia/2-(sqrt(abs((dia/2)*(dia/2)-((-dia/2+newht)*(-dia/2+newht)))));
 
function mirrorYpoints(a)=
 let(temp=[for(i=[2:len(a)-1]) [a[len(a)-i][0],a[len(a)-i][1]*-1,a[len(a)-i][2]]])
 concat(a,temp);

function interpX(p0,p1,theY)=//outputs linearly interpolated X value for a given Y.
	p0.x+(theY-p0.y)*(p1.x-p0.x)/(p1.y-p0.y);
