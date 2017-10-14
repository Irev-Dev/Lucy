module WbraceP(partLayout = 0){
	difference(){
		hull(){
			translate([carbUWP.x - 8, fs.y / 2 - 4 + 1.6, carbUWP.z])cylinder(h = 4, d = 6);
			translate([carbUWP.x - 8 - 5, fs.y / 2, carbLWP.z])cube([10, 4, 4]);
			tranX(carbUWP.x - 8)UpperWingSpace()tranY(UW_FWO + 3.5)cylinder(h = 4, d = 6);

		}
		translate([carbUWP.x - 8, fs.y / 2 - 4 + 1.6, carbUWP.z])cylinder(h = 4, d = 4);
		tranX(carbUWP.x - 8)UpperWingSpace()tranY(UW_FWO + 3.5)cylinder(h = 4, d = 4);
		wingU3(100, 0.2);
		fuse3(100, 0.2);
	}
}
{module WbraceC(partLayout = 0)
	tranX(-100 * partLayout){//wing brace carbon fiber
		neg = partLayout == 0 ? 1 : 0;
		braceH = fs.z - CarBT - FR_CuT + WB_RSD;
		echo(braceH);
		//moveRadiiPoints(rp,tran=[0,0],rot=0)
		braceP = concat(//brace points
			[[carbUWP.z, 0, 0]],
			moveRadiiPoints(WB_PP(), [carbUWP.z, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2]),
			moveRadiiPoints(fs_BP(), [carbUWP.z, fs.y / 2 - WB_BNO - fs_bd / 2], 90),
			[[carbUWP.z, carbUWP.y, 0]],
			let(h = 3 + WB_PW)moveRadiiPoints(WB_PP(), [carbUWP.z + h, carbUWP.y + (h) / tan(UWXang)], -UWXang),
			moveRadiiPoints(fs_BP(), [carbUWP.z + braceH / 2.5, carbUWP.y + braceH / 2.5 / tan(UWXang)], 90 - UWXang),
			moveRadiiPoints(WB_PP(), [carbUWP.z + braceH - 11, carbUWP.y + (braceH - 11) / tan(UWXang)], -UWXang),
			//[[carbUWP.z+braceH,carbUWP.y+braceH/tan(UWXang),0]],
			[[carbUWP.z + braceH - 7, (fs.y / 2 + carbUWP.y + (braceH - 6) / tan(UWXang)) / 2 - 3, 10]],
			[[carbUWP.z + braceH, fs.y / 2, 0]],
			[[carbUWP.z + braceH - WB_RSD, fs.y / 2, 0]],
			[[carbUWP.z + braceH - WB_RSD, fs.y / 2 - FR_CaT, 0]],
			[[carbUWP.z + fs.z - CarBT, fs.y / 2 - FR_CaT, 0]],
			[[carbUWP.z + fs.z - CarBT + 2, 0, 70]]
		);
		color("red")tranX(WB_XP)rotate([0, -90 * neg, 0])linear_extrude(WB_CaT)shell2d(-4, 0, 1)difference(){
			polygon(polyRound(mirrorPoints(braceP, atten = [1, 1]), gfn));
			for (i = [0, 1])mirror([0, i, 0]){
				translate([carbUWP.z + braceH - WB_RSD, fs.y / 2 - FR_CaT - WB_tol / 2, 0])internalSq([FR_CuT * 3, FR_CaT + WB_tol], WB_mir);
				//#translate([carbUWP.z+braceH-14,carbUWP.y+(braceH-14)/tan(UWXang)])circle(WB_mir);
				for (i = [1, 4, 15, 18, 28])translate(parallelFollow([braceP[i - 1], braceP[i], braceP[i + 1]], thick = WB_mir * cos(45), minR = 0))circle(WB_mir);
				//translate(parallelFollow([braceP[14],braceP[15],braceP[16]],thick=WB_mir*cos(45),minR=0))circle(WB_mir);
				//translate(parallelFollow([braceP[17],braceP[18],braceP[19]],thick=WB_mir*cos(45),minR=0))circle(WB_mir);
				//translate(parallelFollow([braceP[27],braceP[28],braceP[29]],thick=WB_mir*cos(45),minR=0))circle(WB_mir);
			}
		}
	}
	function WB_PP(index1, index2)=//post points
	let(WB_PP = [//post points
		[0, -WB_PW, WB_mir],
		[-WB_CaT, -WB_PW, 0],
		[-WB_CaT, 0, 0],
		[0, 0, WB_mir],
	])
	range(WB_PP, index1, index2);
}
module thecam(index = 0){
	//translate([72,0,cos(theta-camA)*(camD/2)+carbLWP[2]+CarBT/2])rotate([0,theta-camA,0])difference(){
	if (index == 0) {
		translate([64 + fusehozoff, 0, carbLWP[2] + CarBT / 2 + camMH])difference(){
			union(){
				//bracket
				translate([-camM[0] / 2, camM[1] / 2 - camM[3], -camM[4]])cube([camM[0], camM[3], camM[2]]);
				translate([-camM[0] / 2, 0, -camM[4]])cube([camM[0], camM[1] / 2, camM[3]]);
				rotate([0, theta - camA, 0])hull(){//camera unit
					translate([-camPP, -camW / 2, -camH / 2])cube([10, camW, camH]);
					translate([camL - camPP, 0, 0])rotate([0, 90, 0])cylinder(d = camD, h = 0.01);

				}
			}
			union(){
				translate([0, camM[6] / 2, -50])cylinder(d = camM[5], h = 40);

			}
		}
	} else {
		translate([54 + fusehozoff, 0, carbLWP[2] + CarBT / 2 + camMH])translate([0, camM[6] / 2, -50])cylinder(d = camM[5], h = 40);

	}
}
module cam(expand = 0, mode = 0){
	div = mode == 0 ? 2 : 10;
	sl = 10;//square length
	dia = 17;
	translate([camP[0], 0, carbLWP[2] + camP[1]]){
		hull()for(i = [70 - camA.x, 70 - camA.y])rotate([0, i, 0])if(expand > 0) translate([camL + sl * 2 - camHP[1] + expand, 0, 0])rotate([0, -90, 0])cylinder(h = camL + sl - camHP[1] + expand, d = dia + expand * 2);
		if (mode == 0) {
			//hull()rotate([0, 20, 0])difference(){
			hull()for(i = [70 - camA.x:(camA.x - camA.y) / div:70 - camA.y])rotate([0, i, 0])difference(){
				union(){
					translate([sl / 2 - camHP[1] - expand, 0, 0])cube([sl, camW + expand * 2, camH + expand * 2], true);
					translate([camL - camHP[1] + 2 + expand, 0, 0])rotate([0, -90, 0])cylinder(h = 3, d = dia + expand * 2);
				}
				union(){
					translate([0, w / 2 - 3, 0])rotate([-90, 0, 0]){
						cylinder(d = 3.2, h = 10);
						translate([camHP[0] - camHP[1], 0, 0])cylinder(d = 3.2, h = 10);
					}
				}
			}
		} else {
			for (i = [70 - camA.x:(camA.x - camA.y) / div:70 - camA.y])hull(){
				rotate([0, i, 0])translate([camL + sl / 2 - camHP[1] + expand, 0, 0])rotate([0, -90, 0])cylinder(h = 3, d = dia + expand * 2);
				rotate([0, i + 1, 0])translate([camL + sl / 2 - camHP[1] + expand, 0, 0])rotate([0, -90, 0])cylinder(h = 3, d = dia + expand * 2);
			}
		}
	}
}
module camM(partLayout = 0){
	mntT = 3;//mount thick
	cen = [camP.x, carbLWP.z + camP.y];
	H = (camHP.y - camHP.x);//hypotenuse
	p1a = [-cos(theta - camA.x - 10) * H, sin(theta - camA.x - 10) * H] + cen;
	p2a = [-cos(theta - camA.y + 10) * H, sin(theta - camA.y + 10) * H] + cen;
	p1b = [-cos(theta - camA.x - 10) * H - 0.01, sin(theta - camA.x - 10) * H - 0.01] + cen;
	p2b = [-cos(theta - camA.y + 10) * H - 0.01, sin(theta - camA.y + 10) * H - 0.01] + cen;
	thinwall_1side = concat(
		[[camP.x - camRR, 0, 1]],
		[[camP.x - camRR, railTE(0).y, 10]],
		railTE(1, 2),
		[[frontRailClip(1).x, frontRailClip(1).y, 0]]
	);

	thinwall = concat(
		thinwall_1side,
		//RailCustomiser(thinwall_1side,camST,0.5,1,1,0,0)
		//RailCustomiser(rp,thick,minR,sgn=1,endpointenable=1,endAng1=0,endAng2=0)
		revList(RailCustomiser(thinwall_1side, o1 = camST + 0.06/*camMT*1.3*/, minR = 0.5, mode = 0))
	);
	thinwall1 = concat(
		thinwall_1side,
		//RailCustomiser(thinwall_1side,camMT*1.3,0.5,1,1,0,0)
		revList(RailCustomiser(thinwall_1side, o1 = camMT * 1.3, minR = 0.5, mode = 0))
	);
	//#for(i=thinwall_1side)rotate([-90,0,0])translate(i)circle(1);
	//	#for(i=thinwall)rotate([-90,0,0])translate(i)circle(0.5);
	//	#for(i=thinwall1)rotate([-90,0,0])translate(i)circle(1);
	//	echo(len(thinwall),len(thinwall1));
	railsubtract = concat(
		//railTE(),
		//[[frontRailClip(0).x,-50,0]],
		//RailCustomiser(concat([rearRailClip(7)],railTE()),30,2,1,0)
		RailCustomiser(concat(railTE(), [[frontRailClip(0).x, -50, 0]]), o1 = 0, o2 = 60, minR = 2, mode = 0, a2 = -1)
	);
	bottomMountS = [//bottomMountSubtract points
		[camST, camBMH, 3],
		[camMT * 2 + camBMD, camBMH - camMT * 2 - camBMD + camST, 3],
		[camMT * 2 + camBMD, camBMH - camMT * 2 - camBMD + camST - 20, 0],
		[camMT * 2 + camBMD + 4, camBMH - camMT * 2 - camBMD + camST - 20, 0],
		[camMT * 2 + camBMD + 4, camBMH + 4, 0],
		[camST, camBMH + 4, 0],
	];
	tranX(60 * partLayout)rotX(partLayout * 180)difference(){
		union(){
			CamMSpace(0)difference(){
				linear_extrude(camBMH + 2)round2d(0, 2){
					tranX(camMT + camBMD / 2)circle(d = camMT * 2 + camBMD);
					square([camST, fs.y / 4]);
				}
				tranY(fs.y / 4)rotX(90)linear_extrude(fs.y / 2)polygon(polyRound(bottomMountS, gfn, 0));
			}
			hull(){
				intersection(){
					tranY(fs.y / 2 - carbW[2])rotX(90)linear_extrude(mntT * 3)translate([fs.x / 2 + fusehozoff + FR_OH + FR_CuT * tan(atan(fs.z / 2 / FR_OH) / 2 + 90), (carbLWP[2] - carbW[2] / 2) + fs.z - FR_CuT])circle(d = FR_BD + mntT * 3);
					translate([0, w / 2 - FR_CaT, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(camMT * 3)polygon(polyRound(thinwall1, gfn, 0));
				}
				tranY(fs.y / 2 - carbW[2])rotX(90)linear_extrude(mntT * 3)translate([fs.x / 2 + fusehozoff + FR_OH + FR_CuT * tan(atan(fs.z / 2 / FR_OH) / 2 + 90), (carbLWP[2] - carbW[2] / 2) + fs.z - FR_CuT])circle(d = FR_BD + mntT * 2);

			}
			translate([0, w / 2 - FR_CaT, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(fs[1] / 2 - FR_CaT)polygon(polyRound(thinwall, gfn, 0));
			translate([0, w / 2 - FR_CaT, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(camMT)polygon(polyRound(thinwall1, gfn, 0));
			hull(){
				translate([camP.x - 7, w / 2 - FR_CaT - mntT, carbLWP[2] - carbW[2] / 2 + fs.z - 0.1])cube([10, mntT, 0.05]);
				translate([0, camW / 2 + mntT / 2, 0])rotate([90, 0, 0])linear_extrude(mntT * 0.5)union()offset(mntT + 1.1)hull(){
					polygon(concat(CentreN2PointsArc(p1a, p2a, cen, 0, 20), CentreN2PointsArc(p2b, p1b, cen, 0, 20)));
					translate(cen)circle(d = 0.01);
				}
			}
			difference(){
				union(){
					hull()translate([cen.x, 0, cen.y])for(i = [70 - camA.x:(camA.x - camA.y) / 5:70 - camA.y])rotate([0, i, 0])tranX(camL - camHP[1] + camD / 2 - 14)sphere(d = camD + 7);
				}
				translate([0, w / 2 + 0.1, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(fs[1] + 0.2)polygon(polyRound(railsubtract, gfn, 0));
			}
		}
		union(){
			cam(0.4, 0);
			fuseRev2(100, 0.2);
			fuseRailsRev2(0.2);
			tranY(fs.y / 2 - carbW[2] - 0.1)rotX(90)linear_extrude(mntT * 3 + 0.2)translate([fs.x / 2 + fusehozoff + FR_OH + FR_CuT * tan(atan(fs.z / 2 / FR_OH) / 2 + 90), (carbLWP[2] - carbW[2] / 2) + fs.z - FR_CuT])circle(d = FR_BD);
			translate([camMT + camBMD / 2, 0, -0.1])CamMSpace(0)linear_extrude(bottomMountS[1].y)circle(d = camBMD);
			CamMSpace(0)translate([-50, -100.02, -50])cube([150, 100, 100]);
			translate([0, camW / 2 + mntT, 0])rotate([90, 0, 0])tranZ(-0.05)linear_extrude(mntT + 0.1 + 10){//camer mount plate
				union()offset(1.1){
					polygon(concat(CentreN2PointsArc(p1a, p2a, cen, 0, 20), CentreN2PointsArc(p2b, p1b, cen, 0, 20)));
					translate(cen)circle(d = 0.02);
				}
			}
		}
	}
	/*rotX(-90)translate([cen.x,-cen.y])linear_extrude(10)intersection(){
		difference(){
			circle(camL-camHP.x+4,$fn=50);
			circle(camL-camHP.x,$fn=50);
		}
		polygon([[0,0],[cos(70-camA.x-20)*50,sin(70-camA.x-20)*50],[cos(70-camA.y+20)*50,sin(70-camA.y+20)*50]]);
	}*/
}
module stackMountHoles(holeD = 3.2, holeS = 30.5){//two holes for the quad electronics stack
	for (i = [0, 90])rotate([0, 0, i])translate([holeS / 2, holeS / 2, -10])circle(d = holeD);
}
{module wingU3(shellT = 6.2, tol_expand = 0, partLayout = 0)//upper carbon fiber wing
/*rotX(180-UWXang*partLayout)translate([0,0,-(carbUWP[2]-carbW[2]*0)*partLayout])*/{
		tranY(180 * partLayout)UpperWingSpace(partLayout)tranZ((carbW[2] + tol_expand) * partLayout / 2 - (carbW[2] * 2 + tol_expand) / 2)linear_extrude(carbW[2] + tol_expand)offset(tol_expand)shell2d(-shellT, 0, 1)difference(){//difference the mounting holes from the wing polygon, shell the result, extrude it and translate into position.
			polygon(polyRound(UWingRP, gfn, 0));//rounded wing polygon
			if (shellT < 99) {//don't include if shell is very large as it is being used to differnce from the motor mount and it causes trouble when included in the difference
				translate(UWing_MMH)circle(d = motP_mntD);//motor mount hole at the top of the wing
				translate([WB_XP - WB_CaT / 2, (fs.z - CarBT - FR_CuT + WB_RSD) / 2.5 / sin(UWXang)])circle(d = motP_mntD);//motor mount hole at the top of the wing
				translate([WB_XP - WB_CaT, -WB_PW + (3 + WB_PW) / sin(UWXang)])internalSq([WB_CaT, WB_PW], WB_mir);
				translate([WB_XP - WB_CaT, -WB_PW + (fs.z - CarBT - FR_CuT + WB_RSD - 11) / sin(UWXang)])internalSq([WB_CaT, WB_PW], WB_mir);
				translate([carbUWP.x - 8, UW_FWO + 3.5])circle(d = 3.2);
				//fs.z-CarBT-FR_CuT+WB_RSD
				//translate(UWing_FWMH)circle(d=motP_mntD);//bottom front mouting hole (coulpes the wing to the base)
				//translate(UWing_RWMH)circle(d=motP_mntD);//bottom rear mouting hole (coulpes the wing to the base)
				//translate([UWing_TMHX,UWing_TMHY])circle(d=motP_mntD);//teather mounting hole
			}
		}
	}
	{
		function UWing_MMP(index1, index2)=
		let(UWing_MMP = [//motor mount points
			//[UWing_MFBMX-6,		UWing_MFBMY,		0],
			[UWing_MFBMX + UWing_XMHO, UWing_MFBMY, 1],
			UWingRP[1] + [-carbUWTO.x, 0, 0],
			UWingRP[2],
			[UWing_MRBMX, UWing_MRBMY, 0]
		])
		range(UWing_MMP, index1, index2);
	}
}
{
	function UWing_BP(index1, index2)=//brace points
	let(UWing_BP = [//brace points
		[UWing_BFT.x, UWing_BFT.y, 3],
		[UWing_BFT.x - 7, UWing_BFT.y, 3],
		[(UWing_BFT.x + UWing_BRT.x + 6) / 2, UWing_BFT.y - 10, 6],
		[UWing_BRT.x + 10, UWing_BRT.y, 3],
		[UWing_BRT.x, UWing_BRT.y, 3],
		[UWingRP[3].x, UWingRP[3].y, 5],
		[UWingRP[3].x, (carbUWP[2] - 2) * cos(UWXang), 4],
		[UWingRP[0].x, (carbUWP[2] - 2) * cos(UWXang), 4],
		[UWingRP[0].x, UWingRP[0].y, 5]
		//[UWing_BRB.x,							UWing_BRB.y,	0],
		//[UWing_BFB.x,							UWing_BFB.y,	0],
		//[carbUWP[0]-carbW[0],					0,				3],
		//[carbUWP[0],							0,				3],
	])
	range(UWing_BP, index1, index2);
}
{module motMntU(Hrot = 30, partLayout = 0)
	translate([100 * partLayout, 100 * partLayout, ((-mot_s[2] / 2 + motP_MT) * partLayout)])rotY((180 - theta) * partLayout){
		difference(){
			union(){
				UpperWingSpace()tranZ(-carbW[2] * 2 / 2 - motP_MT2)linear_extrude(motP_MT2)offset(motP_MT2)polygon(polyRound(UWing_MMP(), gfn, 0));//wing tip mounting hole polygon extrude
				for (i = [0:3])hullIndiv(){ //using hull here to effectively fill in the gap between where this mount attaches to the wing and where the motor mounts to this part
					UpperWingSpace()tranZ(-carbW[2] * 2 / 2 - motP_MT2)linear_extrude(carbW[2] + motP_MT2 * 2)offset(motP_MT2)polygon(polyRound(UWing_MMPS(), gfn, 0));	//wing tip mount
					if (i < 2) motSpace(1)rotate([0, theta, 0])rotate([0, 0, 25 + i * 40])translate([0, motP_dia / 2 + motP_MG[1], 0]) cylinder(h = motP_MT * 3, d = motP_MG[0] + 3);	//extent motor mount to help protect motor
					motSpace(1)rotate([0, theta, 0])rotate([0, 0, Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d", i);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
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
				motSpace(1)rotate([0, theta, 0]) translate([0, 0, motP_MT + 0.01])cylinder(h = motP_MT * 5, d = motP_dia * 5);//large disk used to ensure the part is printable
				motSpace(1)rotate([0, theta, 0])translate([0, 0, motP_MT - motP_CHD])cylinder(h = motP_CHD * 3, d = motP_CHdia); // centre hole
				motSpace(1)rotate([0, theta, 0])rotate([0, 0, Hrot])motMntHoles("3d"); // motor mount holes (3d)
				wingU3(100, 0.35); //Subtract the wing from this part, expanded a small amount for tolerance
				UpperWingMMHSpace(){
					tranZ(-25)cylinder(d = motP_mntD, h = 50);// mounting hole for this part
					tranZ(-motP_MT2 - 10)cylinder(d = motP_HD, h = 10, $fn = motP_HoS); // hex or square hole or nut capture
					//tranZ(motP_MT2/2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15); // counter sunk hole NOT USED CURRENTLY
				}
			}
		}
	}
	{
		function UWing_MMPS(index1, index2)= 
		let(UWing_MMPS = [//motor mount points small
			[UWing_MFBMSX - 5, UWing_MFBMSY, 0],
			[UWing_MFBMSX, UWing_MFBMSY, 0],
			UWingRP[1],
			UWingRP[2],
			[UWing_MRBMX, UWing_MRBMY, 0]
		])
		range(UWing_MMPS, index1, index2);
	}
}
{
	module motMntL(Hrot = 30, partLayout = 0)
	translate([-100 * partLayout, 100 * partLayout, ((mot_s[2] / 2 + motP_MT) * partLayout)])rotY((180 - theta) * partLayout){
		difference(){
			union(){
				tranZ(carbLWP[2] - carbW[2] / 2 - motP_MT2)linear_extrude(motP_MT2)offset(motP_MT2)polygon(polyRound(LWing_MMP(), gfn, 0));//wing tip mounting hole polygon extrude
				for (i = [0:3])hullIndiv(){//using hull here to effectively fill in the gap between where this mount attaches to the wing and where the motor mounts to this part
					tranZ(carbLWP[2] - carbW[2] / 2 - motP_MT2)linear_extrude(carbW[2] + motP_MT2 * 2)offset(motP_MT2)polygon(polyRound(LWing_MMPS(), gfn, 0)); //wing tip mount
					//motSpace(0)rotate([0,theta,0]) cylinder(h=motP_MT,d=motP_dia);
					motSpace(0)rotate([0, theta, 0])rotate([0, 0, Hrot])linear_extrude(motP_MT)offset(4)motMntHoles("2d", i);// offset and linearly extruded the 2d motor mount holes to form the top of motor mounts
					if (i < 2) motSpace(0)rotate([0, theta, 0])rotate([0, 0, 25 + i * 40])translate([motP_dia / 2 + motP_MG[1], 0, 0]) cylinder(h = motP_MT, d = motP_MG[0] + 3); //extent motor mount to help protect motor
				}
			}
			union(){
				motSpace(0)rotate([0, theta, 0]) tranZ(motP_MT)cylinder(h = motP_MT * 5, d = motP_dia * 5);//large disk used to ensure the part is printable
				motSpace(0)rotate([0, theta, 0])translate([0, 0, motP_MT - motP_CHD])cylinder(h = motP_CHD * 3, d = motP_CHdia);// centre hole
				motSpace(0)rotate([0, theta, 0])rotate([0, 0, Hrot])motMntHoles("3d"); // motor mount holes (3d)
				fuse3(100, 0.35); //Subtract the wing/base from this part, expanded a small amount for tolerance
				translate([LWing_MMH[0], LWing_MMH[1], carbLWP[2] - carbW[2] / 2]){
					tranZ(-25)cylinder(d = motP_mntD, h = 50);// mounting hole for this part
					tranZ(-motP_MT2 - 10)cylinder(d = motP_HD, h = 10, $fn = motP_HoS);// hex or square hole or nut capture
					//tranZ(motP_MT2+motP_WMHCS)cylinder(d1=motP_mntD,d2=motP_mntD+15,h=15);// counter sunk hole NOT USED CURRENTLY
				}
			}
		}
	}
	{
		function LWing_MMPS(index1, index2)= 
		let(LWing_MMPS = [//motor mount points small
			[LWing_MRBMSX, LWing_MRBMSY, 0],
			LWingRP(1),
			LWingRP(2),
			[LWing_MFBMX, LWing_MFBMY, 0]
		])
		range(LWing_MMPS, index1, index2);
	}
}
module motMntHoles(mode = 0, index){
	coneht = tan(motP_CA) * (motP_CD - motP_mntD) / 2;
	a = [0, 180, 90, 270];
	for (i = [0:3]){
		newi = mode == "2d" ? index : i;
		newj = i < 2 ? 0 : 2;
		rotate([0, 0, a[newi]])/*translate([0,motP_mntS[newj+j],-0.1])*/{
			if (mode == 0 || mode == "3d") {//hull()ing mush be done individually otherwise it all of the cylinders below will be hull()ed together into a mess :(
				hull()for(h = [0, 1])translate([0, motP_mntS[newj + h], -0.1])cylinder(h = motP_MT * 5 + 0.2, d = motP_mntD); //hulling two cylinders to form a elongated hole
				hull()for(h = [0, 1])translate([0, motP_mntS[newj + h], -coneht])cylinder(h = coneht, d1 = motP_CD, d2 = motP_mntD);//done again with a cone for the counter sunch section
				hull()for(h = [0, 1])translate([0, motP_mntS[newj + h], -coneht - 100 + 0.05])cylinder(h = 100, d = motP_CD);// and again for the bolt head
				//}
			} else {
				hull()for(h = [0, 1])tranY(motP_mntS[newj + h])circle(d = motP_mntD); //hulling two cylinders to form a elongated oval thing
			}
		}
	}
}
{module fuse3(shellT = 6.5, tol_expand = 0, partLayout = 0){
		tranZ(carbLWP[2] - carbW[2] / 2 - (carbLWP[2] - carbW[2] / 2) * partLayout){
			fs_postP = [
				[fusehozoff + l / 2 - fs_minT + fs_mir, w / 2 + FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT, w / 2 - CarRT / 2 - FR_tol / 4, 0],
				[fusehozoff + l / 2 - fs_minT + fs_mir, w / 2 - CarRT - FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT - FR_CuT - fs_mir, w / 2 - CarRT - FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT - FR_CuT, w / 2 - CarRT / 2 - FR_tol / 4, 0],
				[fusehozoff + l / 2 - fs_minT - FR_CuT - fs_mir, w / 2 + FR_tol / 2, fs_mir]
			];
			WB_ppb = [//wing brace post points for the base
				[WB_XP, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2, 0],
				[WB_XP - WB_CaT, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2, 0],
				[WB_XP - WB_CaT, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2 + WB_PP(1).y, 0],
				[WB_XP, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2 + WB_PP(1).y, 0],
			];
			tranZ(-tol_expand / 2)linear_extrude(CarBT + tol_expand){
				difference(){
					offset(tol_expand)shell2d(-shellT, 0, 1.2){
						difference(){
							union(){
								polygon(polyRound(mirrorPoints(fs_basePoints(), atten = [1, 1]), gfn, 0));
							}
							union(){
								for (i = [0:1])mirror([0, i, 0]){
									//polygon(polyRound(fs_postP,gfn,0));
									translate([fusehozoff + l / 2 - fs_minT - FR_CuT / 2, (w - CarRT) / 2])internalSq([FR_CuT + FR_tol, CarRT + FR_tol], fs_mir, 1);
									translate([fusehozoff - l / 2, (w - FR[0]) / 2])internalSq([FR_SD[0] * 2 + FR_tol, FR[0] + FR_tol], fs_mir, 1);
									//polygon(polyRound(WB_ppb,gfn,0));
									translate([WB_XP - WB_CaT, fs.y / 2 - WB_BNO - (fs_bd + fs_bhd) / 2 + WB_PP(1).y])internalSq([WB_CaT, abs(WB_PP(1).y)], WB_mir);
									if (shellT < 99) translate(LWing_MMH)circle(d = motP_mntD);//don't include if shell i very large as it is being used to differnce from the motor mount and it causes trouble included
									//translate([fusehozoff+l/2-fs_minT-FR_CuT-FR_BHD/2,w/2-CarRT/2])circle(d=3.2);
									translate([l / 2 + fusehozoff - fs_minT - FR_CuT - fs_bhd / 2/*+FR_BD/2*/, w / 2 - CarRT / 2])circle(d = 3.2);
									translate([WB_XP - WB_CaT / 2, fs.y / 2 - WB_BNO - fs_bd / 2])circle(d = 3.2);
									translate([carbUWP.x - 8, fs.y / 2 - 4 + 1.6])circle(d = 3.2);
									for (i = [-79, -79/*20*/])translate([i, 0, 0])stackMountHoles();
								}
								CamMSpace(0)tranX(camMT + camBMD / 2)circle(d = camBMD);
							}
						}
						scale([1.2, 1, 1])translate([-17, 0, 0])gridpattern(4.5, sqrt(sq(fs[1] - 12) / 4), 11, 3);
					}
				}
			}
		}
	}
	{
		function LWingRP(index1, index2)=
		let(l = fs[0],
			w = fs[1],
			LWingRP = [//Lower ring radii points. First point starts at the rear base of the wing, then moves out to the tip of the wing
				[carbLWP[0] - carbW[0], w / 2, fs_wbr[1]],
				[mot_cords[0][0] + carbLWTO[0] - carbW[1], mot_cords[0][1] + carbLWTO[1], fs_wtr],
				[mot_cords[0][0] + carbLWTO[0], mot_cords[0][1] + carbLWTO[1], fs_wtr],
				[carbLWP[0], w / 2, fs_wbr[0]],
			])
		range(LWingRP, index1, index2);
	}
	{
		function fs_basePoints(index1, index2)=
		let(l = fs[0],
			w = fs[1],
			fs_basePoints = concat([
				[-l / 2 + fusehozoff + 7, 0, 25],
				[-l / 2 + fusehozoff, w / 2 - FR[0] - FR_tol / 2 - fs_minT, 15]
			], fs_RCRP(),
				//moveRadiiPoints(fs_pp(),[carbUWP[0]-carbW[0],fs[1]/2]),
				//moveRadiiPoints(fs_BP(),[carbUWP[0]-carbW[0]/2,fs[1]/2]),
				//moveRadiiPoints(fs_pp(),[carbUWP[0]-fs_minT-fs_pt*2,fs[1]/2]),
				LWingRP(), [
					[l / 2 + fusehozoff - fs_minT - CarRT - fs_mir * 2, w / 2 + fs_minT, fs_sr],
					[l / 2 + fusehozoff, w / 2 + fs_minT, fs_sr],
					[l / 2 + fusehozoff, w / 2 - fs_minT - CarRT * .75, fs_sr * 3],
					[l / 2 + fusehozoff - 50, 0, 10]
				]))
		range(fs_basePoints, index1, index2);
	}
	{
		function LWing_MMP(index1, index2)=//motor mount points with wrapper function
		let(LWing_MMP = [//motor mount points
			[LWing_MFBMX, LWing_MFBMY, 0],
			LWingRP(2),
			LWingRP(1),
			[LWing_MRBMX, LWing_MRBMY, 0],
			[LWing_MRBMX + 5, LWing_MRBMY, 0]
		])
		range(LWing_MMP, index1, index2);
	}
	{
		function fs_RCRP(index1, index2)=//rear clip radii points with wrapper function
		let(l = fs[0],
			w = fs[1],
			fs_RCRP = [//rear clip radii points
				[-l / 2 + fusehozoff, w / 2 - FR[0] - FR_tol / 2, 0],
				[-l / 2 + fusehozoff + FR_SD[0], w / 2 - FR[0] - FR_tol / 2, fs_mir],
				[-l / 2 + fusehozoff + FR_SD[0], w / 2 + FR_tol / 2, fs_mir],
				[-l / 2 + fusehozoff, w / 2 + FR_tol / 2, 0],
				[-l / 2 + fusehozoff + fs_minT, w / 2 + fs_minT, 10],
				[-l / 2 + fusehozoff + FR_SD[0] + fs_minT * 0.5, w / 2 + fs_minT, 10],
				[-l / 2 + fusehozoff + FR_SD[0] + fs_minT * 3, w / 2, 25]
			])
		range(fs_RCRP, index1, index2);
	}
	{
		function fs_pp(index1, index2)=//post points with wrapper function
		let(fs_pp = [//post points 
			[fs_minT, 0, fs_mir],
			[fs_minT, fs_ph, 0],
			[fs_minT + fs_pt, fs_ph, 0],
			[fs_minT + fs_pt, 0, fs_mir],
		])
		range(fs_pp, index1, index2);
	}
	{
		function fs_BP(index1, index2)=//bolt radii points with wrapper function
		let(fs_BP = [//bolt points
			[-fs_bd / 2, 0, 0],
			[-fs_bd / 2, -fs_bmt, 0],
			[-fs_bhd / 2, -fs_bmt, fs_mir],
			[-fs_bhd / 2, -fs_bmt - fs_bhh, fs_mir],
			[0, -fs_bmt - fs_bhh - 1.5, fs_mir],
			[fs_bhd / 2, -fs_bmt - fs_bhh, fs_mir],
			[fs_bhd / 2, -fs_bmt, fs_mir],
			[fs_bd / 2, -fs_bmt, 0],
			[fs_bd / 2, 0, 0],
		])
		range(fs_BP, index1, index2);
	}
}
{
	module fuseRailsRev2(expand = 0, partLayout = 0)
/*tranZ(-carbLWP[2])rotX(partLayout*-90)*/{
		neg = partLayout == 1 ? 0 : 1;

		l = fs.x;//fuselage length. Temp varible for use in polyRound() arrays
		w = fs.y;//fuselage width. Temp varible for use in polyRound() arrays
		h = fs.z;//fuselage height. Temp varible for use in polyRound() arrays
		offs = fusehozoff;//fuselage offset. Temp varible for use in polyRound() arrays

		WBBp = [//wing brace brace points
			[WB_XP - WB_CaT - 10, fs.z - FR_CuT, 0],
			[WB_XP - WB_CaT - 5, fs.z - FR_CuT, 8],
			[WB_XP - WB_CaT, fs.z - FR_CuT - 2, 0],
			[WB_XP - WB_CaT, fs.z - FR_CuT, FR_MIR],
			[WB_XP, fs.z - FR_CuT, FR_MIR],
			[WB_XP, fs.z - FR_CuT - 2.5, 0],
			[WB_XP + 5, fs.z - FR_CuT, 8],
			[WB_XP + 10, fs.z - FR_CuT, 0],
			[WB_XP - WB_CaT / 2, fs.z - FR_CuT + 1, 0],
		];

		railPoints = concat(
			rearRailClip(),
			railTE(),
			frontRailClip(),
			revList(RailCustomiser(concat([rearRailClip(7)], railTE(), [frontRailClip(0)]), o1 = FR_CuT, minR = 2, mode = 1))
		);
		translate([0, w / 2 + partLayout * 100, (carbLWP[2] - carbW[2] / 2) * neg])rotX(90 * neg)tranZ(expand)linear_extrude(CarRT + expand * 2)offset(expand)difference(){
			union(){
				polygon(polyRound(railPoints, gfn, 0));
				polygon(polyRound(WBBp, gfn));
				//translate(FR_RHP)circle(d=FR_BD+FR_CuT);
				translate([l / 2 + offs + FR_OH + FR_CuT * tan(atan(h / 2 / FR_OH) / 2 + 90), h - FR_CuT])circle(d = FR_BD + FR_CuT);
			}
			union(){
				//translate(FR_RHP)circle(d=FR_BD);
				translate([l / 2 + offs + FR_OH + FR_CuT * tan(atan(h / 2 / FR_OH) / 2 + 90), h - FR_CuT])circle(d = FR_BD);
				translate([WB_XP - WB_CaT / 2, fs.z - FR_CuT * 1.5])internalSq([WB_CaT + FR_tol, FR_CuT + FR_tol], FR_MIR, 1);
			}
		}

	}
	{
		function rearRailClip(index1, index2)=
		let(l = fs[0],//fuselage length. Temp varible for use in polyRound() arrays
			w = fs[1],//fuselage width. Temp varible for use in polyRound() arrays
			h = fs[2],//fuselage height. Temp varible for use in polyRound() arrays
			offs = fusehozoff,//fuselage offset. Temp varible for use in polyRound() arrays
			rearRailClip = [
				[-l / 2 + offs + FR_SD[0] + FR_CuT * tan(FR_RA), CarBT + FR_CuT, 15],
				[-l / 2 + offs + FR_SD[0] + FR_SD[1], CarBT + FR_tol, 0],
				[-l / 2 + offs + FR_SD[0], CarBT + FR_tol, FR_MIR],
				[-l / 2 + offs + FR_SD[0], 0, FR_MIR],
				[-l / 2 + offs + FR_SD[0] + FR_SD[1], 0, 0],
				[-l / 2 + offs + FR_SD[0], -FR_MT, FR_SR],
				[-l / 2 + offs + FR_SD[0] - FR_CuT, -FR_MT, FR_SR],
				[-l / 2 + offs + FR_SD[0] - FR_CuT, CarBT + FR_CuT, 10],
			])
		range(rearRailClip, index1, index2);
	}
	{
		function frontRailClip(index1, index2)=
		let(l = fs[0],//fuselage length. Temp varible for use in polyRound() arrays
			w = fs[1],//fuselage width. Temp varible for use in polyRound() arrays
			h = fs[2],//fuselage height. Temp varible for use in polyRound() arrays
			offs = fusehozoff,//fuselage offset. Temp varible for use in polyRound() arrays
			frontRailClip = concat([
				[l / 2 + offs - fs_minT, CarBT + FR_MT + FR_BHH, 0],
				[l / 2 + offs - fs_minT, 0, 1],
				[l / 2 + offs - fs_minT - FR_CuT, 0, 1],
				[l / 2 + offs - fs_minT - FR_CuT, CarBT, FR_MIR],
				[l / 2 + offs - fs_minT - FR_CuT - (FR_BHD - FR_BD) / 2, CarBT, 0]],
				moveRadiiPoints(fs_BP(), [l / 2 + offs - FR_CuT - fs_minT - fs_bhd / 2.2, CarBT], 180),
				[[l / 2 + offs - fs_minT * 1.4 - FR_CuT - fs_bhd - FR_MT, CarBT, 1],
				[l / 2 + offs - fs_minT * 1.8 - FR_CuT - FR_BHD - FR_MT, CarBT + FR_MT + FR_BHH, 10]
				]))
		range(frontRailClip, index1, index2);
	}
	{
		function railTE(index1, index2)=
		let(l = fs[0],//fuselage length. Temp varible for use in polyRound() arrays
			w = fs[1],//fuselage width. Temp varible for use in polyRound() arrays
			h = fs[2],//fuselage height. Temp varible for use in polyRound() arrays
			offs = fusehozoff,//fuselage offset. Temp varible for use in polyRound() arrays
			railTE = [//rail top edge
				[-l / 2 + offs + FR_SD[0] - FR_CuT + h * tan(FR_RA), h, FR_R1],
				[l / 2 + offs + FR_OH, h, FR_R2],
				[l / 2 + offs - fs_minT, h / 2, FR_R3]
			])
		range(railTE, index1, index2);
	}
}
module prop(NP = 3, propD = 25.4 * 5){
	thick = 1;
	width = 30;
	propR = propD / 2;
	startA = 40;
	finA = 10;

	IP = [
		[5, 0, 0],
		[10, propR / 5, 1],
		[3, propR / 3 + 5, 50],
		[0, propR - 10, 100],
		[3, propR, 1],
		[2, propR, 1],
		[-5, propR - 5, 20],
		[-15, propR * 2 / 3, 50],
		[-5, 0, 0],
	];
	difference(){
		union(){
			translate([0, 0, 5])for(i = [0:NP - 1])rotate([0, 0, 360 * i / NP])intersection(){
				rotate([-90, 0, 0])rotate([0, 0, startA - 90])linear_extrude(height = propR, twist = startA - finA, $fa = 0.5, $fn = 400)square([thick, width], true);
				translate([0, 0, -20])linear_extrude(40)polygon(polyRound(IP));
			}
			cylinder(h = 10, d = 12);
		}
		union(){
			translate([0, 0, -0.1])cylinder(h = 10 + 0.2, d = 5);
		}
	}
}
module motor(motD=28,motH=18){
    motR=motD/2;
    shaftR=2.5;
    rp=[
        [-motR,0,0],
        [-motR,motH*0.75,2],
        [-motR*0.75,motH,2],
        [-shaftR,motH,0.5],
        [-shaftR,motH+8,0.3],
        [0,motH+8,0.3],
    ];

    rp2=RailCustomiser(rp,o1=0,o2=1,mode=0);
    cylinder(r=motR,h=2);
	cylinder(r=motR*0.7,h=motH*0.9);
    difference(){
        union(){
            rotate_extrude()polygon(polyRound(rp2,gfn));
            cylinder(r=motR,h=2);
        }
        for(i=[0:45:360])rotate([0,0,i])translate([0,0,motH*0.7])cube([motD*2,motD*0.25,motH*0.3],true);
        cylinder(r=motR*1.1,h=2.5);
    }
}
module Print2Console(){//Print things to console

	ZposStr = str("fuselage Z position\t= ", carbLWP[2] + fs[2] / 2, "mm (aim for > -10mm as a guide)");
	/* 
	greater than -10mm is a guide because if fuselarge is too far below 0 than the lower
	motors won't have as much levelage on the pitch axis as the upper motors, might start
	making PID tuning problematic!?
	*/
	diagonalMotDis = sqrt(mot_s[0] * mot_s[0] + (mot_s[1] + mot_s[3]) / 2 * (mot_s[1] + mot_s[3]) / 2);
	diagonalMotDisStr = str("diagonal motor distance\t=", diagonalMotDis, "mm");

	/*
	mmix [motor number] [throttle] [roll] [pitch] [yaw]
	mmix 1 1.000 -1.000 1.000 -1.000 (Rear Right motor)
	mmix 2 1.000 -1.000 -1.000  1.000 (Front Right motor)
	mmix 3 1.000 1.000 1.000 1.000 (Rear Left motor)
	mmix 4 1.000 1.000 -1.000 -1.000 (Front Left motor)
	*/
	uroll = mot_s[3] / dem;//upper roll
	lroll = mot_s[1] / dem;//lower roll
	pitch = mot_s[0] / dem;// pitch
	mmix0 = str("mmix 0 1.000\t", -uroll, "\t", pitch, "\t-1.000");
	mmix1 = str("mmix 1 1.000\t", -lroll, "\t", -pitch, "\t1.000");
	mmix2 = str("mmix 2 1.000\t", uroll, "\t", pitch, "\t1.000");
	mmix3 = str("mmix 3 1.000\t", lroll, "\t", -pitch, "\t-1.000");

	echo(str("\r",
		ZposStr, "\r",
		diagonalMotDisStr, "\r\r",
		"mmix values for each motor (currently this does not take into account weight distribution)\r",
		mmix0, "\r",
		mmix1, "\r",
		mmix2, "\r",
		mmix3, "\r"
	));
}
// handly modules, not of specific parts
module axis(size = 50){    
	color("blue"){
		cylinder(h = size, d = 0.5);
		translate([0, 0, size])rotate([90, 0, 0])text("Z");
	}
	color("green"){
		rotate([-90, 0, 0])cylinder(h = size, d = 0.5);
		translate([0, size, 0])text("Y");
	}
	color("red"){
		rotate([0, 90, 0])cylinder(h = size, d = 0.5);
		translate([size, 0, 0])rotate([0, 0, -90])text("X");
	}
}
module gridpattern(memberW = 4, sqW = 12, iter = 5, r = 3){
	round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}
module hullIndiv(){
	for (i = [1:$children - 1])hull(){
		children(0);
		children(i);
	}
}
//COORDINATE SPACE MODULES
module UpperWingMMHSpace(){
	UpperWingSpace()translate(UWing_MMH)children();
}
module UpperWingSpace(disable = 0){
	if (disable == 0) {
		translate([0, carbUWP[1], carbUWP[2]])rotate([UWXang, 0, 0])children();
	} else { children(); }
}
module motSpace(lowOrUp = 0){
	if (lowOrUp > 1) {
		echo("motSpace() index out of range");
	} else {
		translate([mot_cords[lowOrUp][0], mot_cords[lowOrUp][1], mot_cords[lowOrUp][2]])children();
	}
}
module braceMountSpace(holeIndex = 0){
	if (holeIndex == 0) {//front fuselage base mount
		translate([carbUWP[0] - UWB_MT2 / 2 - UWB_Hdia, fs[1] / 2 - UWB_MT2 / 2 - UWB_Hdia / 2, carbLWP[2] + FR[0] / 2]){children(); }
	} else if (holeIndex == 1) {//rear fuselage base mount
		translate([carbUWP[0] - carbW[0] + UWB_MT2 / 2 + UWB_Hdia / 2, fs[1] / 2 - UWB_MT2 / 2 - UWB_Hdia / 2, carbLWP[2] + FR[0] / 2]){children(); }
	} else if (holeIndex == 2) {//front rail mount
		translate([carbUWP[0], fs[1] / 2, carbLWP[2]])rotate([0, UWFYang - 90, 0])translate([0, 0, (fs[2] - FR[0] / 2 - RCutT / 2) / cos(90 - UWFYang)])rotate([0, -UWFYang + 90, 0])rotate([-90, 0, 0]){children(); }
	} else if (holeIndex == 3) {//rear rail mount
		translate([carbUWP[0] - carbW[0], fs[1] / 2, carbLWP[2]])rotate([0, UWRYang - 90, 0])translate([0, 0, (fs[2] - FR[0] / 2 - RCutT / 2) / cos(90 - UWRYang)])rotate([0, -UWRYang + 90, 0])rotate([-90, 0, 0]){children(); }
	} else if (holeIndex == 4) {//front wing base mount
		translate(carbUWP - [-carbW[3] / 2 + UWB_MO[0] * 1.3, 0, 0])rotate([-90 + UWXang, 0, 0])rotate([0, -90 + UWFYang, 0])translate([0, -carbW[2] / 2, (UWB_MT2 + UWB_Hdia + UWB_MO[1]) / (2 * cos(90 - UWFYang) * cos(90 - UWXang))])rotate([90, 0, 0]){children(); }
	} else if (holeIndex == 5) {//rear wing base mount
		translate(carbUWP - [carbW[0] + carbW[3] * 0 - UWB_MO[0], 0, 0])rotate([-90 + UWXang, 0, 0])rotate([0, -90 + UWRYang, 0])translate([0, -carbW[2] / 2, (UWB_MT2 + UWB_Hdia + UWB_MO[1]) / (2 * cos(90 - UWRYang) * cos(90 - UWXang))])rotate([90, 0, 0]){children(); }
	} else if (holeIndex == 6) {//top centre wing mount
		//translate(carbUWP-[carbW[0]/2+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+(UWRYang+UWRYang)/2,0])translate([0,-carbW[2]/2,(fs[2]-(UWB_MT2*2+UWB_Hdia*2+RCutT)/2-UWB_MO[1])/(cos(90-UWRYang)*cos(90-UWXang))])rotate([0,90-(UWRYang+UWRYang)/2,0])rotate([90,0,0]){children();}
		translate(carbUWP - [carbW[0] / 2 + carbW[3] * -0 + 0.1 - 0.5, 0, 0])rotate([-90 + UWXang, 0, 0])rotate([0, -90 + (UWRYang + UWRYang) / 2, 0])translate([0, -carbW[2] / 2, (-UWB_MO[1] + fs[2] - FR[0] - RCutT / 2) / (cos(90 - UWRYang) * cos(90 - UWXang))])rotate([0, 90 - (UWRYang + UWRYang) / 2, 0])rotate([90, 0, 0]){children(); }
		//(fs[2]-FR[0]/2-RCutT/2-UWB_Hdia)
	} else { echo("braceMountSpace() index out of range"); }
}
module CamMSpace(index = 0){
	if (index == 0) {//rear hole
		translate([camP.x - camRR, 0, carbLWP.z + carbW[2] / 2])children();
	}
}
module tranX(offset){
	translate([offset, 0, 0])children();
}
module tranY(offset){
	translate([0, offset, 0])children();
}
module tranZ(offset){
	translate([0, 0, offset])children();
}
module rotX(rot){
	rotate([rot, 0, 0])children();
}
module rotY(rot){
	rotate([0, rot, 0])children();
}
module rotZ(rot){	
	rotate([0, 0, rot])children();
}
//FUNCTIONS - Put inside braces {} so that they collapse :)
/*{function mirrorPoints(a)= //mirrors a list of points about Y, ignoring the first and last points and returning them in reverse order for use with polygon or polyRound
 let(temp=[for(i=[2:len(a)-1]) [a[len(a)-i][0],a[len(a)-i][1]*-1,a[len(a)-i][2]]])
 concat(a,temp);}*/
{
	function interpX(p0, p1, theY)=//outputs linearly interpolated X value for a given Y.
	p0.x + (theY - p0.y) * (p1.x - p0.x) / (p1.y - p0.y);
}
{
	function range(p, index1, index2)=
	index1 > len(p) - 1 || index2 > len(p) - 1 ?//error check
		"outside range" :
		index1 > index2 ?
			"index1 less than index2" :
			index1 == undef ?
				p : //index1 is not defined,return all
				index2 == undef ?
					p[index1] ://index2 is not define, return element at index1
					[for(i = [index1:index2]) p[i]];//return range
}

// Old modules, will probably delete sooner or later	
{
	module fuseRev2(shellT = 6.5, tol_expand = 0, partLayout = 0){
		tranZ(carbLWP[2] - carbW[2] / 2 - (carbLWP[2] - carbW[2] / 2) * partLayout){
			fs_postP = [
				[fusehozoff + l / 2 - fs_minT + fs_mir, w / 2 + FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT, w / 2 - CarRT / 2 - FR_tol / 4, 0],
				[fusehozoff + l / 2 - fs_minT + fs_mir, w / 2 - CarRT - FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT - FR_CuT - fs_mir, w / 2 - CarRT - FR_tol / 2, fs_mir],
				[fusehozoff + l / 2 - fs_minT - FR_CuT, w / 2 - CarRT / 2 - FR_tol / 4, 0],
				[fusehozoff + l / 2 - fs_minT - FR_CuT - fs_mir, w / 2 + FR_tol / 2, fs_mir]
			];
			tranZ(-tol_expand / 2)linear_extrude(CarBT + tol_expand){
				difference(){
					offset(tol_expand)shell2d(-shellT, 0, 1.2){
						difference(){
							union(){
								polygon(polyRound(mirrorPoints(fs_basePoints(), atten = [1, 1]), gfn, 0));
							}
							union(){
								for (i = [0:1])mirror([0, i, 0]){
									polygon(polyRound(fs_postP, gfn, 0));
									if (shellT < 99) translate(LWing_MMH)circle(d = motP_mntD);//don't include if shell i very large as it is being used to differnce from the motor mount and it causes trouble included
									//translate([fusehozoff+l/2-fs_minT-FR_CuT-FR_BHD/2,w/2-CarRT/2])circle(d=3.2);
									translate([l / 2 + fusehozoff - fs_minT - FR_CuT - fs_bhd / 2/*+FR_BD/2*/, w / 2 - CarRT / 2])circle(d = 3.2);
									for (i = [-76, -76/*20*/])translate([i, 0, 0])stackMountHoles();
								}
								CamMSpace(0)tranX(camMT + camBMD / 2)circle(d = camBMD);
							}
						}
						scale([1.2, 1, 1])translate([-17, 0, 0])gridpattern(4.5, sqrt(sq(fs[1] - 12) / 4), 11, 3);
					}
				}
			}
		}
	}
}
{
	module UWingBrace2(printLayout = 0){//printed part that connects the upper wings to the base
		w = fs[1];// temp base width varible for use in polygons
		UWB2_MT1 = 2;
		UWing_BEC = [0, carbUWP[2] + sin(90 - UWXang) * carbW[2] / 2, w / 2 + fs_ph + carbW[2] / 2 - cos(90 - UWXang) * carbW[2] / 2];//bottom edge coordinates
		UWing_BEO = [0, -1 * sin(UWXang), -1 * cos(UWXang)];//bottom edge offset
		UWing_BT = [0, UWing_BTO * sin(UWXang), UWing_BTO * cos(UWXang)];//brace tip
		UWB_XEP = [// Upper Wing Brace X Extrude Points
			[UWing_BEC.y + UWing_BT.y, UWing_BEC.z + UWing_BT.z - 3, 2],
			[UWing_BEC.y + UWing_BT.y, UWing_BEC.z + UWing_BT.z, 0],
			[UWing_BEC.y + UWing_BEO.y, UWing_BEC.z + UWing_BEO.z, 3],
			[carbLWP[2] - CarBT / 2 - UWB2_MT1, w / 2 + fs_ph, 0.5],
			[carbLWP[2] - CarBT / 2 - UWB2_MT1, w / 2, 0.5],
			[carbLWP[2] + CarBT / 2, w / 2, 0],
			[carbLWP[2] + CarBT / 2, w / 2 - FR_CaT, 0],
			[carbLWP[2] + CarBT / 2 + 2, w / 2 - FR_CaT, 1.5],
		];
		UWB_ZEP = [// Upper Wing Brace Z Extrude Points
			[carbUWP[0] + 5, w / 2 - FR_CaT, 0],
			[carbUWP[0] + 5, w / 2 + 30, 0],
			[carbUWP[0] + 5 - carbW[0] * 2, w / 2 + 30, 0],
			[carbUWP[0] + 5 - carbW[0] * 2, w / 2 - FR_CaT, 0],
			[fs_BPC - fs_bhd, w / 2 - FR_CaT, 8],
			[fs_BPC, w / 2, 20],
			[fs_BPC + fs_bhd, w / 2 - FR_CaT, 8],
		];
		translate([-130 * partLayout, 25 * partLayout, 0])rotX(printLayout * (getAngle(UWB_XEP[len(UWB_XEP) - 1], UWB_XEP[0]) + 90))difference(){ //rotate ready to be printed
			intersection(){ //bulk of the brace is made from intertecting extruded polygons
				translate([carbUWP[0] + 5, 0, 0])rotate([0, -90, 0])linear_extrude(carbW[0] * 2)polygon(polyRound(UWB_XEP, gfn, 0)); //X Extrued
				tranZ(carbLWP[2] - 20)linear_extrude(40)polygon(polyRound(UWB_ZEP, gfn, 0)); // Z Extrude
				UpperWingSpace()tranZ(-20)linear_extrude(40)polygon(polyRound(UWing_BP(), gfn, 0)); // perpendictular to wing extrude
			}
			union(){
				fuseRev2(100, 0.2); // Subtract the frame base (with very large shell thickness and expanded a small amount for tolerance)
				UpperWingSpace()tranZ(-25)translate(UWing_RWMH)cylinder(d = motP_mntD, h = 50); // Subtract rear wing mounting hole
				UpperWingSpace()tranZ(-25)translate(UWing_FWMH)cylinder(d = motP_mntD, h = 50); // Subtract front wing mounting hole
				translate([fs_BPC, 0, carbLWP[2]])rotate([-90, 0, 0])cylinder(d = motP_mntD, h = 50); // Subtracte hole for mounting to the base
			}
		}
	}
}
/*{module wingUrev2(shellT=6.2,tol_expand=0,partLayout=0)//upper carbon fiber wing
{
	tranY(180*partLayout)UpperWingSpace(partLayout)tranZ((carbW[2]+tol_expand)*partLayout/2-(carbW[2]+tol_expand)/2)linear_extrude(carbW[2]+tol_expand)offset(tol_expand)shell2d(-shellT,0,1)difference(){//difference the mounting holes from the wing polygon, shell the result, extrude it and translate into position.
		polygon(polyRound(UWingRP,gfn,0));//rounded wing polygon
		if(shellT<99){//don't include if shell is very large as it is being used to differnce from the motor mount and it causes trouble when included in the difference
			translate(UWing_MMH)circle(d=motP_mntD);//motor mount hole at the top of the wing
			translate(UWing_FWMH)circle(d=motP_mntD);//bottom front mouting hole (coulpes the wing to the base)
			translate(UWing_RWMH)circle(d=motP_mntD);//bottom rear mouting hole (coulpes the wing to the base)
			translate([UWing_TMHX,UWing_TMHY])circle(d=motP_mntD);//teather mounting hole
		}
	}
}
{function UWing_MMP(index1,index2)=
	let(UWing_MMP=[//motor mount points
//[UWing_MFBMX-6,		UWing_MFBMY,		0],
[UWing_MFBMX+UWing_XMHO,		UWing_MFBMY,		1],
UWingRP[1]+[-carbUWTO.x,0,0],
UWingRP[2],
[UWing_MRBMX,		UWing_MRBMY,	0]
	])
	range(UWing_MMP,index1,index2);
}
}*/
module teather(partLayout = 0){
	r = 0.5;
	/*p=[
	[-FR_CuT*2,-FR_CuT/2+,1],
	[0,-FR_CuT/2,r],
	[FR_CuT*1.3+2,FR_CuT/2,1.5],
	[2,FR_CuT/2,5]
	];*/
	p = [
		[-FR_CuT * 2, 0, 1],
		[0, 0, r],
		[FR_CuT * 1.3 + 2, FR_CuT, 1.5],
		[2, FR_CuT, 5]
	];
	TTSP = [ //teather tip subtract points
		[-TeMT * 4, TeMT * 2, 0],
		[-TeMT * 4, 0, 0],
		[0, TeMT, 5],
		[TeMT * 2, 0, 0],
		[50, 0, 0],
		[50, TeMT * 2, 0],
	];
	TeH = FR_CuT;//teather height
	TeXO = 8;//x offset
	//translate([0,w/2+TeMT,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(TeMT)translate(FR_RHP)circle(d=FR_BD+FR_CuT);
	//UpperWingSpace()tranZ(carbW[2]/2)linear_extrude(0.05)translate([UWing_TMHX-TeXO,UWing_TMHY])scale([2,1.1])circle(d=TeH);
	tranX(-180 * partLayout)rotX(-getAngle([TePoint.y, TePoint.z], [TePoint2.y, TePoint2.z]) * partLayout)difference(){
		union(){
			hull(){
				translate([0, w / 2 + TeMT, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(TeMT)translate(FR_RHP)circle(d = FR_BD + FR_CuT);
				translate([0, w / 2 + TeMT, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(TeMT)translate(FR_RHP - [-FR_CuT, 0])circle(d = FR_BD);
			}
			hull(){
				UpperWingSpace()tranZ(carbW[2] / 2)linear_extrude(TeMT)translate([UWing_TMHX, UWing_TMHY])circle(d = FR_BD + FR_CuT);
				UpperWingSpace()tranZ(carbW[2] / 2)linear_extrude(TeMT)translate([UWing_TMHX - FR_CuT, UWing_TMHY])circle(d = FR_BD);
			}
			hull(){
				//translate([0,w/2+0.05,carbLWP[2]-carbW[2]/2])rotate([90,0,0])linear_extrude(0.05)translate(FR_RHP+[TeXO,0])scale([2,1])circle(d=TeH);
				translate([0, w / 2, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(0.02)
				//translate(FR_RHP)circle(d=FR_BD+FR_CuT);
				translate(FR_RHP + [TeXO, -FR_CuT / 2])polygon(polyRound(p, gfn, 0));
				tranY((carbW[2] / 2 + TeMT) / cos(90 - UWXang))UpperWingSpace()linear_extrude(0.05)translate([UWing_TMHX - TeXO, UWing_TMHY - FR_CuT / sin(UWXang)])scale([1, 1.0])polygon(polyRound(p, 20, 0));
			}
			//#UpperWingSpace()cube([5,10,50]);
		}
		union(){
			hull(){
				translate([0, w / 2, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(0.02)translate(FR_RHP + [-FR_CuT * 3, -FR_CuT * 1.5])square([FR_CuT * 6, FR_CuT]);
				tranY((carbW[2] / 2 + TeMT) / cos(90 - UWXang))UpperWingSpace()linear_extrude(0.05)translate([UWing_TMHX - TeXO, UWing_TMHY] + [-FR_CuT * 3, -FR_CuT - FR_CuT / sin(UWXang)])square([FR_CuT * 6, FR_CuT]);
			}
			translate([0, w / 2 + TeMT + 0.1, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])linear_extrude(TeMT + 0.2)translate(FR_RHP)circle(d = 3.2);
			translate([0, w / 2 + TeMT + 30, carbLWP[2] - carbW[2] / 2])rotate([90, 0, 0])/*linear_extrude(10)*/translate(FR_RHP)cylinder(h = 30, d1 = 3.2, d2 = 7.2);
			UpperWingSpace()tranZ(carbW[2] / 2 - 0.1)linear_extrude(TeMT + 0.2)translate([UWing_TMHX, UWing_TMHY])circle(d = 3.2);
			UpperWingSpace()tranZ(carbW[2] / 2 + TeMT)/*linear_extrude(10)*/translate([UWing_TMHX, UWing_TMHY])cylinder(h = 30, d1 = 7.2, d2 = 3.2);
			UpperWingSpace()translate([carbUWP[0] - carbW[0], 0, -carbW[2] / 2])rotate([-90, 0, UWRYang + 90])linear_extrude(100)polygon(polyRound(TTSP, 20, 0));
			wingU3(100, 0.2);
		}
	}
}
module UWingBrace(MT1 = 2, MT2 = 3, Hdia = 3.2, WBMO = [5, 5]){//wingbracemountoffset
	//translate(carbUWP-[carbW[0]+carbW[3]*-0+0.1-0.5,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWRYang,0])translate([0,-carbW[2]/2,0])cube([100,0.5,100]);
	//#translate(carbUWP-[carbW[0]*0-carbW[3]/2+0.1,0,0])rotate([-90+UWXang,0,0])rotate([0,-90+UWFYang,0])translate([0,-carbW[2]/2,0])cube([100,0.5,100]);
	difference([]){
		union(){
			hull(){
				braceMountSpace(3)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(3)cube([MT2 + Hdia, MT2, MT1]);
				braceMountSpace(1)translate([-(MT2 + Hdia) * 1.5, 0, 0])cube([MT2 + Hdia, MT2, MT1]);
			}
			hull(){
				braceMountSpace(2)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(0)translate([(MT2 + Hdia) * 1.5, 0, 0])cube([MT2 + Hdia, MT2, MT1]);
			}

			hull(){
				braceMountSpace(6)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(2)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(2)translate([-(MT2 + Hdia) / 2, -(MT2 + Hdia) / 2, 0])cube([MT2 + Hdia, MT2, MT1]);
				braceMountSpace(6)translate([-(MT2 + Hdia) / 2, -MT2 + (MT2 + Hdia) / 2, 0])cube([MT2 + Hdia, MT2, MT1]);
			}
			hull(){
				braceMountSpace(3)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(6)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(3)translate([-(MT2 + Hdia) / 2, -(MT2 + Hdia) / 2, 0])cube([MT2 + Hdia, MT2, MT1]);
				braceMountSpace(6)translate([-(MT2 + Hdia) / 2, -MT2 + (MT2 + Hdia) / 2, 0])cube([MT2 + Hdia, MT2, MT1]);
			}
			hull(){
				braceMountSpace(6)cylinder(h = UWB_minP, d = Hdia + MT2);
				braceMountSpace(5)cylinder(h = UWB_minP, d = Hdia + MT2);
			}
			hull(){
				braceMountSpace(6)cylinder(h = UWB_minP, d = Hdia + MT2);
				braceMountSpace(4)cylinder(h = UWB_minP, d = Hdia + MT2);
			}
			hull(){
				for (i = [0, 1, 5, 4])braceMountSpace(i)cylinder(h = MT1, d = MT2 + Hdia);
				braceMountSpace(1)translate([-(MT2 + Hdia) * 1.5, 0, 0])cube([MT2 + Hdia, MT2, MT1]);
				braceMountSpace(0)translate([(MT2 + Hdia) * 1.5, 0, 0])cube([MT2 + Hdia, MT2, MT1]);
			}
		}
		union(){
			// base holes
			for (i = [1:6])braceMountSpace(i){// loop through different hole positings and remove material
				translate([0, 0, -MT1 * 4])cylinder(h = MT1 * 8, d = Hdia);
				translate([0, 0, MT1])cylinder(h = MT1 * 4, d = MT2 + Hdia, $fn = UWB_HoS);
			}
			braceMountSpace(0){//The height of the hole being subtracted here is sensitive, which is why it's outside the above loop
				translate([0, 0, -MT1 * 4])cylinder(h = MT1 * 6, d = Hdia);
				translate([0, 0, MT1])cylinder(h = MT1 * 3, d = MT2 + Hdia, $fn = UWB_HoS);
			}
			translate([-100, -1, carbLWP[2] + fs[2] - FR[0] / 2/*-RCutT/2-UWB_Hdia/2+UWB_MT2/2*/])cube([200, 200, 100]);
		}
	}
}
module wingU(){
	difference(){
		hull(){
			motSpace(1) translate(carbUWTO) rotate([UWXang, 0, 0])translate([-carbW[3], -carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
			motSpace(1) translate(carbUWTO - [carbW[1], 0, 0]) rotate([UWXang, 0, 0])translate([+carbW[3], -carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
			translate(carbUWP) rotate([UWXang, 0, 0])translate([-carbW[3], carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
			translate(carbUWP - [carbW[0], 0, 0]) rotate([UWXang, 0, 0])translate([carbW[3], carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
		}
		union(){
			motSpace(1) translate(carbUWTO) rotate([UWXang, 0, 0])translate([-carbW[3] - carbWmin, -carbW[3] - carbWmin, -carbW[2] / 2 - motP_MT2 * 5])cylinder(h = carbW[2] + motP_MT2 * 10, d = motP_mntD);
			motSpace(1) translate(carbUWTO - [carbW[1], 0, 0]) rotate([UWXang, 0, 0])translate([carbW[3] + carbWmin, -carbW[3] - carbWmin, -carbW[2] / 2 - motP_MT2 * 5])cylinder(h = carbW[2] + motP_MT2 * 10, d = motP_mntD);
			for (i = [4:6])braceMountSpace(i){translate([0, 0, -UWB_MT1 * 4])cylinder(h = UWB_MT1 * 8, d = UWB_Hdia); }
		}
	}
}
module wingL(){
	frntWang = abs(atan((mot_cords[0][1] + carbLWTO[1] - carbLWP[1]) / (mot_cords[0][0] - carbLWP[0])));
	rearWang = abs(atan((mot_cords[0][1] + carbLWTO[1] - carbLWP[1]) / (mot_cords[0][0] + carbLWTO[0] - carbW[1] - carbLWP[0] + carbW[0])));
	translate(carbLWP) rotate([LWXang, 0, 0])translate([-carbW[3], 0, -carbW[2] / 2])angR(ht = carbW[2], ang = frntWang + 2, R = carbLWR[0]);
	translate(carbLWP - [carbW[0], 0, 0]) rotate([LWXang, 0, 0])translate([carbW[3], 0, -carbW[2] / 2])mirror([1, 0, 0,])angR(ht = carbW[2], ang = 180 - rearWang + 0.5, R = carbLWR[1]);
	difference(){
		hull(){
			motSpace(0) translate(carbLWTO) rotate([LWXang, 0, 0])translate([-carbW[3], -carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
			motSpace(0) translate(carbLWTO - [carbW[1], 0, 0]) rotate([LWXang, 0, 0])translate([carbW[3], -carbW[3], -carbW[2] / 2])cylinder(h = carbW[2], r = carbW[3]);
			translate(carbLWP) rotate([LWXang, 0, 0])translate([-carbW[3], 0, -carbW[2] / 2])cylinder(h = carbW[2], r = 0.01);
			translate(carbLWP - [carbW[0], 0, 0]) rotate([LWXang, 0, 0])translate([carbW[3], 0, -carbW[2] / 2])cylinder(h = carbW[2], r = 0.01);
		}
		union(){
			motSpace(0) translate(carbLWTO) rotate([LWXang, 0, 0])translate([-carbW[3] - carbWmin, -carbW[3] - carbWmin, -carbW[2] / 2 - motP_MT2 * 5])cylinder(h = carbW[2] + motP_MT2 * 10, d = motP_mntD);
			motSpace(0) translate(carbLWTO - [carbW[1], 0, 0]) rotate([LWXang, 0, 0])translate([carbW[3] + carbWmin, -carbW[3] - carbWmin, -carbW[2] / 2 - motP_MT2 * 5])cylinder(h = carbW[2] + motP_MT2 * 10, d = motP_mntD);
		}
	}
}
module thefuselage(fuseHt = 40, frntDia = 45, rearDia = 180, RCT1 = 4.5,//rail carbon thickness
	RCT2 = 5,//rail carbon thickness (cut thickness)
	BCT1 = 4, //base carbon thickness
	slotD = 6, tol = 0.1, totLength = 150, fuseW = 40, mergeR = [5, 10], boltD = 3.2, mergeT = 3){
	difference(){
		union(){
			translate([0, 0, 0])fuseB(frntDia, rearDia, fuseW, fuseHt, BCT1, RCT1, RCT2, totLength, tol, slotD, mergeT, mergeR);
			//translate([80*partLayout,0,0])fuseSlot(rearDia,fuseHt,BCT1,RCT2,slotD,totLength,fuseW,RCT1);
			translate([0, fuseW / 2 - RCT1 + partLayout * 70, 0])rotate([partLayout * 270, 0, 0]){
				difference(){
					union(){
						railHalf(thedia = frntDia, theheight = fuseHt, thick1 = RCT1, thick2 = RCT2, leng = totLength / 2, carT = BCT1, slotD = slotD, tol = tol);
						//back half
						//#translate([totLength,0,BCT1])mirror([1,0,0])railHalf(thedia=rearDia,theheight=fuseHt-BCT1,thick1=RCT1,thick2=RCT2,leng=totLength/2,carT=BCT1,slotD=slotD,tol=tol);
						translate([totLength, 0, BCT1])mirror([1, 0, 0])railHalfRear(thedia = rearDia, theheight = fuseHt - BCT1, thick1 = RCT1, thick2 = RCT2, leng = totLength / 2, carT = BCT1, slotD = slotD, tol = tol);
						translate([fs[0] / 2 + fusehozoff, 0, -carbLWP[2] + carbW[2] / 2])mirror([1, 0, 0]){
							braceMountSpace(2)translate([0, 0, -fuseW / 2])cylinder(h = CarRT, d = RCT2 + UWB_Hdia);
							braceMountSpace(3)translate([0, 0, -fuseW / 2])cylinder(h = CarRT, d = RCT2 + UWB_Hdia);
						}
					}
					union(){
						translate([fs[0] / 2 + fusehozoff, 0, -carbLWP[2] + carbW[2] / 2])mirror([1, 0, 0]){
							braceMountSpace(2)translate([0, 0, -fuseW / 2 - UWB_MT1 * 7])cylinder(h = UWB_MT1 * 15, d = UWB_Hdia);
							braceMountSpace(3)translate([0, 0, -fuseW / 2 - UWB_MT1 * 7])cylinder(h = UWB_MT1 * 15, d = UWB_Hdia);
						}
					}
				}
			}
		}
		union(){
			translate([fs[0] - Stack_PcbW / 2 - 5, 0, 0])stackMountHoles(Stack_HD, Stack_HS);
			translate([camL + Stack_PcbW / 2 + 13.7, 0, 0])stackMountHoles(Stack_HD, Stack_HS);
			translate([fs[0] / 2 + fusehozoff, 0, -carbLWP[2] + carbW[2] / 2])mirror([1, 0, 0]){
				//translate([carbUWP[0]-carbW[0]+UWB_MT2/2+UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*8,d=UWB_Hdia);
				//translate([carbUWP[0]-UWB_MT2/2-UWB_Hdia/2,fs[1]/2-UWB_MT2/2-UWB_Hdia/2,carbLWP[2]+FR[0]/2-UWB_MT1*4])cylinder(h=UWB_MT1*7,d=UWB_Hdia);
				rearOff = getRearOffset(rearDia, fuseHt, BCT1, RCT2);
				thecam(1);
				//fuseSlotMountHoles(rearOff);

			}
		}
	}
}
module fuseSlot(rearDia, fuseHt, BCT1, RCT2, slotD, totLength, fuseW, RCT1){
	rearOff = getOffset(rearDia, fuseHt, BCT1, RCT2);
	difference(){
		union(){
			translate([totLength - rearOff - RCT2 - slotD, fuseW / 2 - RCT1 - RCT2, BCT1])cube([slotD, RCT1 + RCT2, BCT1]);
			translate([totLength - rearOff - RCT2, 0, BCT1])cube([RCT2, fuseW / 2 - RCT1, BCT1]);
		}
		union(){
			//cylinder(h=5,d=2);
		}
	}
}
module fuseSlotMountHoles(rearOff){
	translate([fs[0] / 2 + fusehozoff, 0, +carbLWP[2] - carbW[2] / 2])mirror([1, 0, 0]){
		//translate([fs[0]-rearOff-RCutT/2,fs[2]/2-CarRT*2,-CarBT*5])cylinder(d=3.2,h=CarBT*10);
		#translate([fs[0] - rearOff - RCutT, fs[2] / 2 - CarRT * 2, -CarBT * 5])cube([RCutT, CarRT, CarBT * 10]);
	}
}
module fuseB(frntDia, rearDia, fuseW, fuseHt, BCT1, RCT1, RCT2, totLength, tol, slotD, mergeT, mergeR){
	//need to fix up toll in here
	frntOff = getOffset(frntDia, fuseHt, BCT1, RCT2);
	rearOff = getOffset(rearDia, fuseHt, BCT1, RCT2);
	difference(){
		union(){
			translate([frntOff, -0.1, 0])cube([totLength - frntOff - rearOff, fuseW / 2 + 0.1, BCT1]);
			//fron side brace
			translate([frntOff, fuseW / 2 + tol, 0])cube([slotD + RCT1, mergeT, BCT1]);
			translate([frntOff + slotD, fuseW / 2, 0])cube([RCT1, mergeT, BCT1]);
			translate([frntOff + slotD + RCT1, fuseW / 2, 0])Rmerge(ht = BCT1, dp = mergeT + tol, R1 = mergeR[0], R2 = mergeR[1]);
			//rear side brace
			translate([totLength - rearOff - RCT1 - (RCT2 + tol + slotD * 2 + 0.1), fuseW / 2 + tol * 0, 0])cube([RCT2 + tol + slotD * 2 + 0.1 + RCT1, mergeT, BCT1]);
			translate([totLength - rearOff - RCT1 - (RCT2 + tol + slotD * 2 + 0.1), fuseW / 2, 0])cube([RCT1, mergeT, BCT1]);
			translate([totLength - rearOff - RCT1 - (RCT2 + tol + slotD * 2 + 0.1), fuseW / 2, 0])mirror([1, 0, 0])Rmerge(ht = BCT1, dp = mergeT + tol, R1 = mergeR[0], R2 = mergeR[1]);
			translate([totLength - rearOff, 0, 0])cube([mergeT, fuseW / 2 + mergeT + tol, BCT1]);
		}
		union(){
			translate([totLength, fuseW / 2 - RCT1, BCT1])mirror([1, 0, 0])railHalfRear(thedia = rearDia, theheight = fuseHt - BCT1, thick1 = RCT1, thick2 = RCT2, leng = totLength / 2, carT = BCT1, slotD = slotD, tol = tol, bolt = 1);
			translate([0, fuseW / 2 - RCT1, 0])railHalf(thedia = frntDia, theheight = fuseHt, thick1 = RCT1, thick2 = RCT2, leng = totLength / 2, carT = BCT1, slotD = slotD, tol = tol);
			translate([fs[0] / 2 + fusehozoff, 0, -carbLWP[2] + carbW[2] / 2])mirror([1, 0, 0]){
         
				for (i = [0, 1])braceMountSpace(i){
					translate([0, 0, -UWB_MT1 * 4])cylinder(h = UWB_MT1 * 8, d = UWB_Hdia);
				}
			}
		}
	}
}
module railHalf(thedia = 120, theheight = 40, thick1 = 4, thick2 = 5, leng = 80, carT = 4, slotD = 8, leng = 60,,tol = 0.1){
	frntRingHtO = thedia > theheight * 1.5 ? carT + thick2 : (carT - thick2) / 2;
	frntRingHt = theheight - frntRingHtO;
	theoffset3 = thedia > theheight * 2 ? thedia / 2 : sqrt(abs((thedia / 2) * (thedia / 2) - ((-thedia / 2 + frntRingHt) * (-thedia / 2 + frntRingHt))));
	difference(){
		union(){
			translate([thedia / 2, 0, -thedia / 2 + theheight])rotate([0, 40, 0])translate([-thedia / 2 + thick2 / 2 + 1.6, 0, 0])rotate([-90, 0, 0])cylinder(h = thick1, d = thick2 + 3.2);
			translate([0, 0, frntRingHtO])ringPart(thedia = thedia, theheight = frntRingHt, thick1 = thick1, thick2 = thick2, leng = leng, carT = carT, slotD = slotD);
			clip(thedia / 2 - theoffset3, carT, thick1, thick2, slotD, tol);
		}
		union(){
			translate([thedia / 2, 0, -thedia / 2 + theheight])rotate([0, 40, 0])translate([-thedia / 2 + thick2 / 2 + 1.6, -thick1 * 3, 0])rotate([-90, 0, 0])cylinder(h = thick1 * 6, d = 3.2);
		}
	}
}
module railHalfRear(thedia = 120, theheight = 40, thick1 = 4, thick2 = 5, leng = 80, carT = 4, slotD = 8, leng = 60, tol = 0.1, bolt = 0){
	//frntRingHtO=thedia>theheight*1.5?carT+thick2:(carT-thick2)/2;
	frntRingHtO = 0;
	frntRingHt = theheight - frntRingHtO;
	theoffset3 = thedia > theheight * 2 ? thedia / 2 : sqrt(abs((thedia / 2) * (thedia / 2) - ((-thedia / 2 + frntRingHt) * (-thedia / 2 + frntRingHt))));
	difference(){
		union(){
			if (bolt > 0) {
				translate([thedia / 2 - theoffset3 + thick2 + rearF_nf / 2, thick1 / 2, -25])cylinder(d = rearF_bd, h = 50);
			}
			translate([0, 0, frntRingHtO])ringPart(thedia = thedia, theheight = frntRingHt, thick1 = thick1, thick2 = thick2, leng = leng, carT = carT, slotD = slotD);
			hull(){
				translate([thedia / 2, 0, -thedia / 2 + theheight])rotate([0, rearF_ha, 0])translate([-thedia / 2 + thick2 / 2, 0, 0])rotate([-90, 0, 0])cylinder(h = thick1, d = thick2);
				translate([thedia / 2 - theoffset3, 0, 0])cube([thick2 * 2 + rearF_nf, thick1, thick1 * 0.7 + rearF_nh]);
			}
			translate([thedia / 2 - theoffset3, 0, -FR[0]])cube([thick2, thick1, FR[0] + 0.01]);
		}
		union(){
			translate([thedia / 2 - theoffset3 + thick2, -thick1 / 2, thick1 * 0.7])cube([rearF_nf, thick1 * 2, rearF_nh]);
			translate([thedia / 2 - theoffset3 + thick2 + (rearF_nf - rearF_bd) / 2, -thick1 / 2, -0.01])cube([rearF_bd, thick1 * 2, rearF_nh + thick1 * 0.7]);
		}
	}
}
module clip(aoffset, carT, thick1, thick2, slotD, tol){
	translate([aoffset, 0, -thick2])cube([thick2, thick1, thick2 * 2 + carT + tol / 2]);
	translate([aoffset, 0, -thick2])cube([slotD + thick2, thick1, thick2]);
	translate([aoffset, 0, carT + tol / 2])cube([slotD + thick2, thick1, thick2]);
}
module ringPart(thedia = 120, theheight = 40, thick1 = 4, thick2 = 5, leng = 80, carT = 4, slotD = 8){
	theoffset3 = sqrt((thedia / 2) * (thedia / 2) - ((-thedia / 2 + theheight) * (-thedia / 2 + theheight)));
	thedia = thedia < theheight ? theheight : thedia;
	circCenter = -thedia / 2 + theheight;
	theoffset = thedia > theheight * 2 ? sqrt((thedia / 2) * (thedia / 2) - (circCenter * circCenter)) : thedia / 2;
	theoffset2 = thedia > theheight * 2 ? 0 : theoffset;
	rotate([0, 0, 180])difference(){
		union(){
			translate([-theoffset, 0, circCenter]) rotate([90, 0, 0]) cylinder(h = thick1, d = thedia);
			translate([-leng, -thick1, circCenter + thedia / 2 - thick2])cube([leng - theoffset, thick1, thick2]);
		}
		union(){
			translate([-theoffset, 0.1, circCenter]) rotate([90, 0, 0]) cylinder(h = thick1 + 5, d = thedia - thick2 * 2);
			translate([-thedia, -thick1 - 0.1, -thedia - 0.1])cube([thedia * 2, thick1 + 0.2, thedia + 0.1]);
			translate([-thedia - theoffset, -thick1 - 0.1, -0.1])cube([thedia, thick1 + 0.2, circCenter + thedia / 2 + 0.1 - thick2]);
			translate([-thedia * 1.5 + theoffset3 - thick2, -thick1 - 0.1, -0.1])cube([thedia, thick1 + 0.2, circCenter]);
		}
	}
}
module Rmerge(ht = 3, dp = 3, ang = 30, R1 = 3, R2 = 3){
	difference(){
		union(){
			translate([0, dp - R1, 0])cylinder(h = ht, r = R1);
			translate([0, dp - R1, 0])rotate([0, 0, -ang])translate([0, -dp + R1, 0])cube([(dp - R1) / tan(ang) + R1 / sin(ang), dp, ht]);
			translate([(dp - R1) / tan(ang) + R1 / sin(ang), 0, 0])angR(ht = ht, ang = 180 - ang, R = R2);
		}
		union(){
			translate([-R1, -R1 * 2 - dp, -0.1])cube([(dp - R1) / tan(ang) + R1 / sin(ang) + R1 * 2 + R2 + 2, R1 * 2 + dp, ht + 0.2]);
			translate([-R1, 0, -0.1])cube([R1, R1 + dp, ht + 0.2]);
		}
	}
}
module angR(ht = 3, ang = 120, R = 3){
	difference(){
		hull()for(i = [0, ang])rotate([0, 0, i])cube([R / tan(ang / 2), 0.001, ht]);
		translate([R / tan(ang / 2), R, -0.1])cylinder(h = ht + 0.2, r = R);

	}
}
module motMnts(){
	translate(DSmotT)rotate(DSmotR)for(i = [mot_s[0] / 2, -mot_s[0] / 2], j = [mot_s[1] / 2, -mot_s[1] / 2]){
		translate([i, j, 0])difference(){
			union(){
				cylinder(h = motP_MT, d = motP_dia);
				translate([0, 0, 10]) cylinder(h = 2, d = 125);
			}
		}//end diffence
	}
}
{
	function getOffset(dia, ht, BCT1, RCT2)=
	let(newht = ht - (dia > ht * 1.5 ? BCT1 + RCT2 : (BCT1 - RCT2) / 2))
	dia > ht * 2 ? 0 : dia / 2 - (sqrt(abs((dia / 2) * (dia / 2) - ((-dia / 2 + newht) * (-dia / 2 + newht)))));
}
