module thecam(index=0){
    //translate([72,0,cos(theta-camA)*(camD/2)+carbLWP[2]+CarBT/2])rotate([0,theta-camA,0])difference(){
    if(index==0){
        translate([64+fusehozoff,0,carbLWP[2]+CarBT/2+camMH])difference(){
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
module cam(expand=0){
    //w=25;
    //h=25;
    sl=10;//square length
    hp=[4,8];
    dia=17;
    difference(){
        union(){
            hull(){
                translate([sl/2-hp[1]-expand,0,0])cube([sl,camW+expand*2,camH+expand*2],true);
                translate([camL+sl/2-hp[1]+expand,0,0])rotate([0,-90,0])cylinder(h=3,d=dia+expand*2);
            }
        }
        union(){
            translate([0,w/2-3,0])rotate([-90,0,0]){
                cylinder(d=3.2,h=10);   
                translate([hp[0]-hp[1],0,0])cylinder(d=3.2,h=10);   
            }
        }
    }
}
module stackMountHoles(holeD=3.2,holeS=30.5){
 for(i=[0,90])rotate([0,0,i])translate([holeS/2,holeS/2,-10])circle(d=holeD); 
}
module wingUrev2(shellT=6.2,tol_expand=0){
	UpperWingSpace()tranZ(-(carbW[2]+tol_expand)/2)linear_extrude(carbW[2]+tol_expand)offset(tol_expand)shellInwards2d(shellT,0,1)difference(){//difference the mounting holes from the wing polygon, shell the result, extrude it and translate into position.
		polygon(polyRound(UWingRP,20,0));//rounded wing polygon
		if(shellT<99){//don't include if shell is very large as it is being used to differnce from the motor mount and it causes trouble when included in the difference
			translate(UWing_MMH)circle(d=motP_mntD);//motor mount hole at the top of the wing
			translate(UWing_FWMH)circle(d=motP_mntD);//bottom front mouting hole (coulpes the wing to the base)
			translate(UWing_RWMH)circle(d=motP_mntD);//bottom rear mouting hole (coulpes the wing to the base)
			translate([UWing_TMHX,UWing_TMHY])circle(d=motP_mntD);//teather mounting hole
		}
	}
}
module UWingBrace2(){
	w=fs[1];// temp base width varible for use in polygons
	UWB2_MT1=2;
	UWing_BEC=[0,carbUWP[2]+sin(90-UWXang)*carbW[2]/2,			w/2+fs_ph+carbW[2]/2-cos(90-UWXang)*carbW[2]/2];//bottom edge coordinates
	UWing_BEO=[0,-1*sin(UWXang),-1*cos(UWXang)];//bottom edge offset
	UWing_BT=[0,UWing_BTO*sin(UWXang),UWing_BTO*cos(UWXang)];//brace tip
	UWB_XEP=[// Upper Wing Brace X Extrude Points
	[UWing_BEC.y+UWing_BT.y,			UWing_BEC.z+UWing_BT.z-3,2],
	[UWing_BEC.y+UWing_BT.y,			UWing_BEC.z+UWing_BT.z,	0],
	[UWing_BEC.y+UWing_BEO.y,			UWing_BEC.z+UWing_BEO.z,3],
	[carbLWP[2]-CarBT/2-UWB2_MT1,		w/2+fs_ph,				0.5],
	[carbLWP[2]-CarBT/2-UWB2_MT1,		w/2,					0.5],
	[carbLWP[2]+CarBT/2,				w/2,					0],
	[carbLWP[2]+CarBT/2,				w/2-FR_CaT,				0],
	[carbLWP[2]+CarBT/2+2,				w/2-FR_CaT,				1.5],
	];
	UWB_ZEP=[// Upper Wing Brace Z Extrude Points
	[carbUWP[0]+5,						w/2-FR_CaT,				0],
	[carbUWP[0]+5,						w/2+30,					0],
	[carbUWP[0]+5-carbW[0]*2,			w/2+30,					0],
	[carbUWP[0]+5-carbW[0]*2,			w/2-FR_CaT,				0],
	[fs_BPC-fs_bhd,						w/2-FR_CaT,				8],
	[fs_BPC,							w/2,					20],
	[fs_BPC+fs_bhd,						w/2-FR_CaT,				8],
	];
	difference(){
		intersection(){
			translate([carbUWP[0]+5,0,0])rotate([0,-90,0])linear_extrude(carbW[0]*2)polygon(polyRound(UWB_XEP,20,0)); //X Extrued
			tranZ(carbLWP[2]-20)linear_extrude(40)polygon(polyRound(UWB_ZEP,20,0)); // Z Extrude
			UpperWingSpace()tranZ(-20)linear_extrude(40)polygon(polyRound(UWing_BP,20,0)); // perpendictular to wing extrude
		}
		union(){
			fuseRev2(100,0.2); // Subtract the frame base (with very large shell thickness and expanded a small amount for tolerance)
			UpperWingSpace()tranZ(-25)translate(UWing_RWMH)cylinder(d=motP_mntD,h=50); // Subtract rear wing mounting hole
			UpperWingSpace()tranZ(-25)translate(UWing_FWMH)cylinder(d=motP_mntD,h=50); // Subtract front wing mounting hole
			translate([fs_BPC,0,carbLWP[2]])rotate([-90,0,0])cylinder(d=motP_mntD,h=50); // Subtracte hole for mounting to the base
		}
	}
}
module motMntU(Hrot=30){
	difference(){
		union(){
			UpperWingSpace()tranZ(-carbW[2]/2-motP_MT2)linear_extrude(motP_MT2)offset(motP_MT2)polygon(polyRound(UWing_MMP,20,0));//wing tip mounting hole polygon extrude
			for(i=[0:3])hullIndiv(){ //using hull here to effectively fill in the gap between where this mount attaches to the wing and where the motor mounts to this part
				UpperWingSpace()tranZ(-carbW[2]/2-motP_MT2)linear_extrude(carbW[2]+motP_MT2*2)offset(motP_MT2)polygon(polyRound(UWing_MMPS,20,0));	//wing tip mount
				if(i<2)motSpace(1)rotate([0,theta,0])rotate([0,0,25+i*40])translate([0,motP_dia/2+motP_MG[1],0]) cylinder(h=motP_MT*3,d=motP_MG[0]+3);	//extent motor mount to help protect motor
				motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",i);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
				//motSpace(1)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
				//for(i=[25,65])motSpace(1)rotate([0,theta,0])rotate([0,0,i])translate([0,motP_dia/2+motP_MG[1],0]) cylinder(h=motP_MT,d=motP_MG[0]);	//extent motor mount to help protect motor
				//motSpace(1)rotate([0,theta,0])rotate([0,0,65])translate([0,motP_dia/2+motP_MG[1],0]) cylinder(h=motP_MT,d=motP_MG[0]+2);	//extent motor mount to help protect motor
				//for(i=[0:3])motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",i);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
				//motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",1);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
				//motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",2);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
				//motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",3);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
			}	
		}
		union(){
			//slightly better than below but hard to print motSpace(1)rotate([0,theta,0]) translate([0,0,motP_MT])cylinder(h=motP_MT*2,d1=motP_dia*1.2,d2=motP_dia*1.2+motP_MT*10);
			motSpace(1)rotate([0,theta,0]) translate([0,0,motP_MT+0.01])cylinder(h=motP_MT*5,d=motP_dia*5);//large disk used to ensure the part is printable
			motSpace(1)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia); // centre hole
			motSpace(1)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles("3d"); // motor mount holes (3d)
			wingUrev2(100,0.2); //Subtract the wing from this part, expanded a small amount for tolerance
			UpperWingMMHSpace(){
				tranZ(-25)cylinder(d=motP_mntD,h=50);// mounting hole for this part
				tranZ(-motP_MT2-10)cylinder(d=motP_HD,h=10,$fn=motP_HoS); // hex or square hole or nut capture
				//tranZ(motP_MT2/2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15); // counter sunk hole NOT USED CURRENTLY
			}
		}
	}
}
module motMntL(Hrot=30){
	difference(){
		union(){
			tranZ(carbLWP[2]-carbW[2]/2-motP_MT2)linear_extrude(motP_MT2)offset(motP_MT2)polygon(polyRound(LWing_MMP,20,0));//wing tip mounting hole polygon extrude
			for(i=[0:3])hullIndiv(){//using hull here to effectively fill in the gap between where this mount attaches to the wing and where the motor mounts to this part
				tranZ(carbLWP[2]-carbW[2]/2-motP_MT2)linear_extrude(carbW[2]+motP_MT2*2)offset(motP_MT2)polygon(polyRound(LWing_MMPS,20,0)); //wing tip mount
				//motSpace(0)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
				motSpace(0)rotate([0,theta,0])rotate([0,0,Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d",i);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
				if(i<2)motSpace(0)rotate([0,theta,0])rotate([0,0,25+i*40])translate([motP_dia/2+motP_MG[1],0,0]) cylinder(h=motP_MT,d=motP_MG[0]+3); //extent motor mount to help protect motor
			}
		}
		union(){
			motSpace(0)rotate([0,theta,0]) tranZ(motP_MT)cylinder(h=motP_MT*5,d=motP_dia*5);//large disk used to ensure the part is printable
			motSpace(0)rotate([0,theta,0])translate([0,0,motP_MT-motP_CHD])cylinder(h=motP_CHD*3,d=motP_CHdia);// centre hole
			motSpace(0)rotate([0,theta,0])rotate([0,0,Hrot])motMntHoles("3d"); // motor mount holes (3d)
			fuseRev2(100,0.2); //Subtract the wing/base from this part, expanded a small amount for tolerance
			translate([LWing_MMH[0],LWing_MMH[1],carbLWP[2]-carbW[2]/2]){
				tranZ(-25)cylinder(d=motP_mntD,h=50);// mounting hole for this part
				tranZ(-motP_MT2-10)cylinder(d=motP_HD,h=10,$fn=motP_HoS);// hex or square hole or nut capture
				//tranZ(motP_MT2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15);// counter sunk hole NOT USED CURRENTLY
			}
		}
	}
}
module motMntHoles(mode=0,index){
	coneht=tan(motP_CA)*(motP_CD-motP_mntD)/2;
	a=[0,180,90,270];
	for(i=[0:3]){
		newi=mode=="2d"?index:i;
		newj=i<2?0:2;
		hull()for(j=[0,1])rotate([0,0,a[newi]])translate([0,motP_mntS[newj+j],-0.1]){
			if(mode==0||mode=="3d"){
				cylinder(h=motP_MT*5+0.2,d=motP_mntD); //hulling two cylinders to form a elongated hole
				tranZ(0,0,-coneht)cylinder(h=coneht,d1=motP_CD,d2=motP_mntD);//done again with a cone for the counter sunch section
				tranZ(-coneht-100+0.01)cylinder(h=100,d=motP_CD);// and again for the bolt head
			} else{
				circle(d=motP_mntD); //hulling two cylinders to form a elongated oval thing
			}
		}
	}
}
module fuseRev2(shellT=6.5,tol_expand=0){
    tranZ(carbLWP[2]-carbW[2]/2){
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
				offset(tol_expand)shellInwards2d(shellT,0,1.2){
					difference(){
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
					scale([1.2,1,1])translate([0,0,0])gridpattern(4.5,sqrt(sq(fs[1]-12)/4),11,3);
				}
			}
		}
	}
}
module fuseRailsRev2(){
	l=fs[0];//fuselage length. Temp varible for use in polyRound() arrays
	w=fs[1];//fuselage width. Temp varible for use in polyRound() arrays
	h=fs[2];//fuselage height. Temp varible for use in polyRound() arrays
	offs=fusehozoff;//fuselage offset. Temp varible for use in polyRound() arrays
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
	translate([0,w/2,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(CarRT)difference(){
		union(){
			polygon(polyRound(railPoints,5,0));
			translate(FR_RHP)circle(d=FR_BD+FR_CuT);
			translate([l/2+offs+FR_OH+FR_CuT*tan(atan(h/2/FR_OH)/2+90),h-FR_CuT])circle(d=FR_BD+FR_CuT);
		}
		union(){
			translate(FR_RHP)circle(d=FR_BD);
			translate([l/2+offs+FR_OH+FR_CuT*tan(atan(h/2/FR_OH)/2+90),h-FR_CuT])circle(d=FR_BD);
		}
	}

}
module teather(){
	//#translate([0,w/2+TeMT,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT){
	//	translate(FR_RHP+[6,0])scale([2,1])circle(d=FR_BD+FR_CuT);
	//}
	r=0.5;
	p=[
	[-FR_CuT*2,-FR_CuT/2,1],
	[0,-FR_CuT/2,r],
	[FR_CuT*1.3+2,FR_CuT/2,1.5],
	[2,FR_CuT/2,5]
	];
	TTSP=[//teather tip subtract points
	[-TeMT*4,TeMT*2,0],
	[-TeMT*4,0,0],
	[0,TeMT,5],
	[TeMT*2,0,0],
	[50,0,0],
	[50,TeMT*2,0],
	];
	TeH=FR_CuT;//teather height
	TeXO=10;//x offset
	//translate([0,w/2+TeMT,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT)translate(FR_RHP)circle(d=FR_BD+FR_CuT);
	//UpperWingSpace()tranZ(carbW[2]/2)linear_extrude(0.05)translate([UWing_TMHX-TeXO,UWing_TMHY])scale([2,1.1])circle(d=TeH);
	difference(){
		union(){
			hull(){
				translate([0,w/2+TeMT,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT)translate(FR_RHP)circle(d=FR_BD+FR_CuT);
				translate([0,w/2+TeMT,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT)translate(FR_RHP-[-FR_CuT,0])circle(d=FR_BD);
			}
			hull(){
				UpperWingSpace()tranZ(carbW[2]/2)linear_extrude(TeMT)translate([UWing_TMHX,UWing_TMHY])circle(d=FR_BD+FR_CuT);
				UpperWingSpace()tranZ(carbW[2]/2)linear_extrude(TeMT)translate([UWing_TMHX-FR_CuT,UWing_TMHY-FR_CuT/2])circle(d=FR_BD);
			}
			hull(){
				//translate([0,w/2+0.05,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(0.05)translate(FR_RHP+[TeXO,0])scale([2,1])circle(d=TeH);
				translate([0,w/2,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(0.02)
						//translate(FR_RHP)circle(d=FR_BD+FR_CuT);
						translate(FR_RHP+[TeXO,0])polygon(polyRound(p,20,0));
				UpperWingSpace()tranZ(-carbW[2]/2-TeMT)linear_extrude(0.05)translate([UWing_TMHX-TeXO,UWing_TMHY])scale([1,1.0])polygon(polyRound(p,20,0));
			}
		}
		union(){
			hull(){
				translate([0,w/2,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(0.02)translate(FR_RHP+[-FR_CuT*3,-FR_CuT*1.5])square([FR_CuT*6,FR_CuT]);
				UpperWingSpace()tranZ(-carbW[2]/2-TeMT)linear_extrude(0.05)translate([UWing_TMHX-TeXO,UWing_TMHY]+[-FR_CuT*3,-FR_CuT*1.5*1.0])square([FR_CuT*6,FR_CuT]);
			}
			translate([0,w/2+TeMT+0.1,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT+0.2)translate(FR_RHP)circle(d=3.2);
			translate([0,w/2+TeMT+30,carbLWP[2]-carbW[2]/2])rotate([90,0,0])/*linear_extrude(10)*/translate(FR_RHP)cylinder(h=30,d1=3.2,d2=7.2);
			UpperWingSpace()tranZ(carbW[2]/2-0.1)linear_extrude(TeMT+0.2)translate([UWing_TMHX,UWing_TMHY])circle(d=3.2);
			UpperWingSpace()tranZ(carbW[2]/2+TeMT)/*linear_extrude(10)*/translate([UWing_TMHX,UWing_TMHY])cylinder(h=30,d1=7.2,d2=3.2);
			UpperWingSpace()translate([carbUWP[0]-carbW[0],0,-carbW[2]/2])rotate([-90,0,UWRYang+90])linear_extrude(100)polygon(polyRound(TTSP,20,0));
			wingUrev2(100,0.2);
		}
	}
}
module prop(NP=3){
    thick=1;
    width=30;
    propR=2.5*25.4;
    startA=40;
    finA=10;
    
    IP=[
    [5,        0,				0],
    [10,        propR/5,			1],
	[3,        propR/3+5,			50],
    [0,        propR-10,		100],
    [3,        propR,			1],
	[2,        propR,			1],
	[-5,         propR-5,		20],
    [-15,         propR*2/3,		50],
    [-5,         0,				0],
    ];
    difference(){
        union(){
            translate([0,0,5])for(i=[0:NP-1])rotate([0,0,360*i/NP])intersection(){
                rotate([-90,0,0])rotate([0,0,startA-90])linear_extrude(height=propR,twist=startA-finA,$fa=0.5,$fn=400)square([thick,width],true);
                translate([0,0,-20])linear_extrude(40)polygon(polyRound(IP));
            }
            cylinder(h=10,d=12);   
        }
        union(){
            translate([0,0,-0.1])cylinder(h=10+0.2,d=5);
        }
    }
}
// handly modules, not of specific parts
module shellInwards2d(off,OR,IR){
	difference(){
		children(0);//original 1st child forms the outside of the shell
		round2d(IR,OR)difference(){//round the inside cutout
			offset(-off)children(0);//shrink the 1st child to form the inside of the shell 
			if($children>1)children(1);//second child is used to add material to inside of the shell
		}
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
module gridpattern(memberW=4,sqW=12,iter=5,r=3){
    round2d(0,r)rotate([0,0,45])translate([-(iter*(sqW+memberW)+memberW)/2,-(iter*(sqW+memberW)+memberW)/2])difference(){
        square([(iter)*(sqW+memberW)+memberW,(iter)*(sqW+memberW)+memberW]);
        for(i=[0:iter-1],j=[0:iter-1]){
            translate([i*(sqW+memberW)+memberW,j*(sqW+memberW)+memberW])square([sqW,sqW]);
        }
    }
}
module hullIndiv(){
	for(i=[1:$children-1])hull(){
		children(0);
		children(i);
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
// Old modules, will probably delete sooner or later
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
module motMnts(){
    translate(DSmotT)rotate(DSmotR)for(i=[mot_s[0]/2,-mot_s[0]/2],j=[mot_s[1]/2,-mot_s[1]/2]){
        translate([i,j,0])difference(){
            union(){
                cylinder(h=motP_MT,d=motP_dia);
                translate([0,0,10]) cylinder(h=2,d=125);
            }
        }//end diffence
    }
}
