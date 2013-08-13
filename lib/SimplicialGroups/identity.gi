#(C) written by Le Van Luyen


#############################################
#############################################
InstallGlobalFunction(HAPHomotopyTuple,
function(C)
	local
		s,t,Kers,Kert,
		A,G,AG,Nat,AutA,
		GensA,GensG,GensAutA,alpha,phi;
		
		s:=C!.sourceMap;
		t:=C!.targetMap;
		Kers:=Kernel(s);
		Kert:=Kernel(t);
		
		Nat:=NaturalHomomorphismByNormalSubgroup(Image(s),Image(t,Kers));
		A:=Intersection(Kers,Kert);
		G:=Range(Nat);
		AutA:=AutomorphismGroup(A);
		GensA:=GeneratorsOfGroup(A);
		GensG:=GeneratorsOfGroup(G);
		GensAutA:=GeneratorsOfGroup(AutA);
		###############################
		alpha:=function(g,a)
			local x;
		x:=PreImagesRepresentative(Nat,g);
			return x^(-1)*a*x;
		end;
		###############################
		phi:= GroupHomomorphismByImages(G,AutA,GensG,List(GensG,g->GroupHomomorphismByImages(A,A,GensA,List(GensA,a->alpha(g,a)))));
		AG:=SemidirectProduct(G,phi,A);
		return [IdGroup(G),AbelianInvariants(A),IdGroup(AG)];
end);
#############################################
#############################################

#############################################
#############################################
InstallGlobalFunction(IdCatOneGroup,
function(C)	
	local D, HTD,n,i,HTCATS;
	HTCATS:=[];
	HTCATS[1]:=[ [ [ 1, 1 ], [  ], [ 1, 1 ] ] ];
	HTCATS[2]:=[ [ [ 1, 1 ], [ 2 ], [ 2, 1 ] ], [ [ 2, 1 ], [  ], [ 2, 1 ] ] ];
	HTCATS[3]:=[ [ [ 1, 1 ], [ 3 ], [ 3, 1 ] ], [ [ 3, 1 ], [  ], [ 3, 1 ] ] ];
	HTCATS[4]:=[ [ [ 1, 1 ], [ 4 ], [ 4, 1 ] ], [ [ 4, 1 ], [  ], [ 4, 1 ] ], [ [ 1, 1 ], [ 2, 2 ], [ 4, 2 ] ], [ [ 2, 1 ], [ 2 ], [ 4, 2 ] ], [ [ 4, 2 ], [  ], [ 4, 2 ] ] ];
	HTCATS[5]:=[ [ [ 1, 1 ], [ 5 ], [ 5, 1 ] ], [ [ 5, 1 ], [  ], [ 5, 1 ] ] ];
	HTCATS[6]:=[ [ [ 2, 1 ], [ 3 ], [ 6, 1 ] ], [ [ 6, 1 ], [  ], [ 6, 1 ] ], [ [ 1, 1 ], [ 2, 3 ], [ 6, 2 ] ], [ [ 2, 1 ], [ 3 ], [ 6, 2 ] ],
  [ [ 3, 1 ], [ 2 ], [ 6, 2 ] ], [ [ 6, 2 ], [  ], [ 6, 2 ] ] ];
	HTCATS[7]:=[ [ [ 1, 1 ], [ 7 ], [ 7, 1 ] ], [ [ 7, 1 ], [  ], [ 7, 1 ] ] ];
	HTCATS[8]:=[ [ [ 1, 1 ], [ 8 ], [ 8, 1 ] ], [ [ 8, 1 ], [  ], [ 8, 1 ] ], [ [ 1, 1 ], [ 2, 4 ], [ 8, 2 ] ], [ [ 2, 1 ], [ 4 ], [ 8, 2 ] ],
  [ [ 4, 1 ], [ 2 ], [ 8, 2 ] ], [ [ 8, 2 ], [  ], [ 8, 2 ] ], [ [ 2, 1 ], [ 2, 2 ], [ 8, 3 ] ], [ [ 2, 1 ], [ 4 ], [ 8, 3 ] ], [ [ 8, 3 ], [  ], [ 8, 3 ] ],
  [ [ 8, 4 ], [  ], [ 8, 4 ] ], [ [ 1, 1 ], [ 2, 2, 2 ], [ 8, 5 ] ], [ [ 2, 1 ], [ 2, 2 ], [ 8, 5 ] ], [ [ 4, 2 ], [ 2 ], [ 8, 5 ] ], [ [ 8, 5 ], [  ], [ 8, 5 ] ] ];
	HTCATS[9]:=[ [ [ 1, 1 ], [ 9 ], [ 9, 1 ] ], [ [ 9, 1 ], [  ], [ 9, 1 ] ], [ [ 1, 1 ], [ 3, 3 ], [ 9, 2 ] ], [ [ 3, 1 ], [ 3 ], [ 9, 2 ] ], [ [ 9, 2 ], [  ], [ 9, 2 ] ] ];
	HTCATS[10]:=[ [ [ 2, 1 ], [ 5 ], [ 10, 1 ] ], [ [ 10, 1 ], [  ], [ 10, 1 ] ], [ [ 1, 1 ], [ 2, 5 ], [ 10, 2 ] ], [ [ 2, 1 ], [ 5 ], [ 10, 2 ] ],
  [ [ 5, 1 ], [ 2 ], [ 10, 2 ] ], [ [ 10, 2 ], [  ], [ 10, 2 ] ] ];
	HTCATS[11]:=[ [ [ 1, 1 ], [ 11 ], [ 11, 1 ] ], [ [ 11, 1 ], [  ], [ 11, 1 ] ] ];
	HTCATS[12]:=[ [ [ 4, 1 ], [ 3 ], [ 12, 1 ] ], [ [ 12, 1 ], [  ], [ 12, 1 ] ], [ [ 1, 1 ], [ 3, 4 ], [ 12, 2 ] ], [ [ 3, 1 ], [ 4 ], [ 12, 2 ] ],
  [ [ 4, 1 ], [ 3 ], [ 12, 2 ] ], [ [ 12, 2 ], [  ], [ 12, 2 ] ], [ [ 3, 1 ], [ 2, 2 ], [ 12, 3 ] ], [ [ 12, 3 ], [  ], [ 12, 3 ] ], [ [ 2, 1 ], [ 2, 3 ], [ 12, 4 ] ],
  [ [ 4, 2 ], [ 3 ], [ 12, 4 ] ], [ [ 6, 1 ], [ 2 ], [ 12, 4 ] ], [ [ 12, 4 ], [  ], [ 12, 4 ] ], [ [ 1, 1 ], [ 2, 2, 3 ], [ 12, 5 ] ],
  [ [ 2, 1 ], [ 2, 3 ], [ 12, 5 ] ], [ [ 3, 1 ], [ 2, 2 ], [ 12, 5 ] ], [ [ 4, 2 ], [ 3 ], [ 12, 5 ] ], [ [ 6, 2 ], [ 2 ], [ 12, 5 ] ], [ [ 12, 5 ], [  ], [ 12, 5 ] ] ];
	HTCATS[13]:=[ [ [ 1, 1 ], [ 13 ], [ 13, 1 ] ], [ [ 13, 1 ], [  ], [ 13, 1 ] ] ];
	HTCATS[14]:=[ [ [ 2, 1 ], [ 7 ], [ 14, 1 ] ], [ [ 14, 1 ], [  ], [ 14, 1 ] ], [ [ 1, 1 ], [ 2, 7 ], [ 14, 2 ] ], [ [ 2, 1 ], [ 7 ], [ 14, 2 ] ],
  [ [ 7, 1 ], [ 2 ], [ 14, 2 ] ], [ [ 14, 2 ], [  ], [ 14, 2 ] ] ];
	HTCATS[15]:=[ [ [ 1, 1 ], [ 3, 5 ], [ 15, 1 ] ], [ [ 3, 1 ], [ 5 ], [ 15, 1 ] ], [ [ 5, 1 ], [ 3 ], [ 15, 1 ] ], [ [ 15, 1 ], [  ], [ 15, 1 ] ] ];
	HTCATS[16]:=[ [ [ 1, 1 ], [ 16 ], [ 16, 1 ] ], [ [ 16, 1 ], [  ], [ 16, 1 ] ], [ [ 1, 1 ], [ 4, 4 ], [ 16, 2 ] ], [ [ 4, 1 ], [ 4 ], [ 16, 2 ] ],
  [ [ 2, 1 ], [ 2 ], [ 4, 2 ] ], [ [ 16, 2 ], [  ], [ 16, 2 ] ], [ [ 2, 1 ], [ 2, 4 ], [ 16, 3 ] ], [ [ 4, 1 ], [ 2, 2 ], [ 16, 3 ] ], [ [ 16, 3 ], [  ], [ 16, 3 ] ],
  [ [ 4, 1 ], [ 4 ], [ 16, 4 ] ], [ [ 16, 4 ], [  ], [ 16, 4 ] ], [ [ 1, 1 ], [ 2, 8 ], [ 16, 5 ] ], [ [ 2, 1 ], [ 8 ], [ 16, 5 ] ], [ [ 8, 1 ], [ 2 ], [ 16, 5 ] ],
  [ [ 16, 5 ], [  ], [ 16, 5 ] ], [ [ 2, 1 ], [ 8 ], [ 16, 6 ] ], [ [ 16, 6 ], [  ], [ 16, 6 ] ], [ [ 2, 1 ], [ 8 ], [ 16, 7 ] ], [ [ 16, 7 ], [  ], [ 16, 7 ] ],
  [ [ 2, 1 ], [ 8 ], [ 16, 8 ] ], [ [ 16, 8 ], [  ], [ 16, 8 ] ], [ [ 16, 9 ], [  ], [ 16, 9 ] ], [ [ 1, 1 ], [ 2, 2, 4 ], [ 16, 10 ] ], [ [ 2, 1 ], [ 2, 4 ], [ 16, 10 ] ],
  [ [ 4, 1 ], [ 2, 2 ], [ 16, 10 ] ], [ [ 4, 2 ], [ 4 ], [ 16, 10 ] ], [ [ 8, 2 ], [ 2 ], [ 16, 10 ] ], [ [ 16, 10 ], [  ], [ 16, 10 ] ],
  [ [ 2, 1 ], [ 2, 2, 2 ], [ 16, 11 ] ], [ [ 2, 1 ], [ 2, 4 ], [ 16, 11 ] ], [ [ 4, 2 ], [ 2, 2 ], [ 16, 11 ] ], [ [ 4, 2 ], [ 4 ], [ 16, 11 ] ],
  [ [ 8, 3 ], [ 2 ], [ 16, 11 ] ], [ [ 16, 11 ], [  ], [ 16, 11 ] ], [ [ 8, 4 ], [ 2 ], [ 16, 12 ] ], [ [ 16, 12 ], [  ], [ 16, 12 ] ],
  [ [ 2, 1 ], [ 2, 4 ], [ 16, 13 ] ], [ [ 16, 13 ], [  ], [ 16, 13 ] ], [ [ 1, 1 ], [ 2, 2, 2, 2 ], [ 16, 14 ] ], [ [ 2, 1 ], [ 2, 2, 2 ], [ 16, 14 ] ],
  [ [ 4, 2 ], [ 2, 2 ], [ 16, 14 ] ], [ [ 8, 5 ], [ 2 ], [ 16, 14 ] ], [ [ 16, 14 ], [  ], [ 16, 14 ] ] ];
	HTCATS[17]:=[ [ [ 1, 1 ], [ 17 ], [ 17, 1 ] ], [ [ 17, 1 ], [  ], [ 17, 1 ] ] ];
	HTCATS[18]:=[ [ [ 2, 1 ], [ 9 ], [ 18, 1 ] ], [ [ 18, 1 ], [  ], [ 18, 1 ] ], [ [ 1, 1 ], [ 2, 9 ], [ 18, 2 ] ], [ [ 2, 1 ], [ 9 ], [ 18, 2 ] ],
  [ [ 9, 1 ], [ 2 ], [ 18, 2 ] ], [ [ 18, 2 ], [  ], [ 18, 2 ] ], [ [ 2, 1 ], [ 3, 3 ], [ 18, 3 ] ], [ [ 6, 1 ], [ 3 ], [ 18, 3 ] ], [ [ 6, 2 ], [ 3 ], [ 18, 3 ] ],
  [ [ 18, 3 ], [  ], [ 18, 3 ] ], [ [ 2, 1 ], [ 3, 3 ], [ 18, 4 ] ], [ [ 6, 1 ], [ 3 ], [ 18, 4 ] ], [ [ 18, 4 ], [  ], [ 18, 4 ] ], [ [ 1, 1 ], [ 2, 3, 3 ], [ 18, 5 ] ],
  [ [ 2, 1 ], [ 3, 3 ], [ 18, 5 ] ], [ [ 3, 1 ], [ 2, 3 ], [ 18, 5 ] ], [ [ 6, 2 ], [ 3 ], [ 18, 5 ] ], [ [ 9, 2 ], [ 2 ], [ 18, 5 ] ], [ [ 18, 5 ], [  ], [ 18, 5 ] ] ];
	HTCATS[19]:=[ [ [ 1, 1 ], [ 19 ], [ 19, 1 ] ], [ [ 19, 1 ], [  ], [ 19, 1 ] ] ];
	HTCATS[20]:=[ [ [ 4, 1 ], [ 5 ], [ 20, 1 ] ], [ [ 20, 1 ], [  ], [ 20, 1 ] ], [ [ 1, 1 ], [ 4, 5 ], [ 20, 2 ] ], [ [ 4, 1 ], [ 5 ], [ 20, 2 ] ],
  [ [ 5, 1 ], [ 4 ], [ 20, 2 ] ], [ [ 20, 2 ], [  ], [ 20, 2 ] ], [ [ 4, 1 ], [ 5 ], [ 20, 3 ] ], [ [ 20, 3 ], [  ], [ 20, 3 ] ], [ [ 2, 1 ], [ 2, 5 ], [ 20, 4 ] ],
  [ [ 4, 2 ], [ 5 ], [ 20, 4 ] ], [ [ 10, 1 ], [ 2 ], [ 20, 4 ] ], [ [ 20, 4 ], [  ], [ 20, 4 ] ], [ [ 1, 1 ], [ 2, 2, 5 ], [ 20, 5 ] ], [ [ 2, 1 ], [ 2, 5 ], [ 20, 5 ] ],
  [ [ 4, 2 ], [ 5 ], [ 20, 5 ] ], [ [ 5, 1 ], [ 2, 2 ], [ 20, 5 ] ], [ [ 10, 2 ], [ 2 ], [ 20, 5 ] ], [ [ 20, 5 ], [  ], [ 20, 5 ] ] ];
	HTCATS[21]:=[ [ [ 3, 1 ], [ 7 ], [ 21, 1 ] ], [ [ 21, 1 ], [  ], [ 21, 1 ] ], [ [ 1, 1 ], [ 3, 7 ], [ 21, 2 ] ], [ [ 3, 1 ], [ 7 ], [ 21, 2 ] ],
  [ [ 7, 1 ], [ 3 ], [ 21, 2 ] ], [ [ 21, 2 ], [  ], [ 21, 2 ] ] ];
	HTCATS[22]:=[ [ [ 2, 1 ], [ 11 ], [ 22, 1 ] ], [ [ 22, 1 ], [  ], [ 22, 1 ] ], [ [ 1, 1 ], [ 2, 11 ], [ 22, 2 ] ], [ [ 2, 1 ], [ 11 ], [ 22, 2 ] ],
  [ [ 11, 1 ], [ 2 ], [ 22, 2 ] ], [ [ 22, 2 ], [  ], [ 22, 2 ] ] ];
	HTCATS[23]:=[ [ [ 1, 1 ], [ 23 ], [ 23, 1 ] ], [ [ 23, 1 ], [  ], [ 23, 1 ] ] ];
	HTCATS[24]:=[ [ [ 8, 1 ], [ 3 ], [ 24, 1 ] ], [ [ 24, 1 ], [  ], [ 24, 1 ] ], [ [ 1, 1 ], [ 3, 8 ], [ 24, 2 ] ], [ [ 3, 1 ], [ 8 ], [ 24, 2 ] ],
  [ [ 8, 1 ], [ 3 ], [ 24, 2 ] ], [ [ 24, 2 ], [  ], [ 24, 2 ] ], [ [ 24, 3 ], [  ], [ 24, 3 ] ], [ [ 8, 4 ], [ 3 ], [ 24, 4 ] ], [ [ 24, 4 ], [  ], [ 24, 4 ] ],
  [ [ 2, 1 ], [ 3, 4 ], [ 24, 5 ] ], [ [ 6, 1 ], [ 4 ], [ 24, 5 ] ], [ [ 8, 2 ], [ 3 ], [ 24, 5 ] ], [ [ 24, 5 ], [  ], [ 24, 5 ] ], [ [ 2, 1 ], [ 3, 4 ], [ 24, 6 ] ],
  [ [ 6, 1 ], [ 4 ], [ 24, 6 ] ], [ [ 8, 3 ], [ 3 ], [ 24, 6 ] ], [ [ 24, 6 ], [  ], [ 24, 6 ] ], [ [ 4, 1 ], [ 2, 3 ], [ 24, 7 ] ], [ [ 8, 2 ], [ 3 ], [ 24, 7 ] ],
  [ [ 12, 1 ], [ 2 ], [ 24, 7 ] ], [ [ 24, 7 ], [  ], [ 24, 7 ] ], [ [ 2, 1 ], [ 2, 2, 3 ], [ 24, 8 ] ], [ [ 6, 1 ], [ 2, 2 ], [ 24, 8 ] ],
  [ [ 8, 3 ], [ 3 ], [ 24, 8 ] ], [ [ 24, 8 ], [  ], [ 24, 8 ] ], [ [ 1, 1 ], [ 2, 3, 4 ], [ 24, 9 ] ], [ [ 2, 1 ], [ 3, 4 ], [ 24, 9 ] ], [ [ 3, 1 ], [ 2, 4 ], [ 24, 9 ] ],
  [ [ 4, 1 ], [ 2, 3 ], [ 24, 9 ] ], [ [ 6, 2 ], [ 4 ], [ 24, 9 ] ], [ [ 8, 2 ], [ 3 ], [ 24, 9 ] ], [ [ 12, 2 ], [ 2 ], [ 24, 9 ] ],
  [ [ 24, 9 ], [  ], [ 24, 9 ] ], [ [ 2, 1 ], [ 3, 4 ], [ 24, 10 ] ], [ [ 2, 1 ], [ 2, 2, 3 ], [ 24, 10 ] ], [ [ 6, 2 ], [ 4 ], [ 24, 10 ] ], [ [ 6, 2 ], [ 2, 2 ], [ 24, 10 ] ],
  [ [ 8, 3 ], [ 3 ], [ 24, 10 ] ], [ [ 24, 10 ], [  ], [ 24, 10 ] ], [ [ 8, 4 ], [ 3 ], [ 24, 11 ] ], [ [ 24, 11 ], [  ], [ 24, 11 ] ], [ [ 6, 1 ], [ 2, 2 ], [ 24, 12 ] ],
  [ [ 24, 12 ], [  ], [ 24, 12 ] ], [ [ 3, 1 ], [ 2, 2, 2 ], [ 24, 13 ] ], [ [ 6, 2 ], [ 2, 2 ], [ 24, 13 ] ], [ [ 12, 3 ], [ 2 ], [ 24, 13 ] ],
  [ [ 24, 13 ], [  ], [ 24, 13 ] ], [ [ 2, 1 ], [ 2, 2, 3 ], [ 24, 14 ] ], [ [ 4, 2 ], [ 2, 3 ], [ 24, 14 ] ], [ [ 6, 1 ], [ 2, 2 ], [ 24, 14 ] ],
  [ [ 8, 5 ], [ 3 ], [ 24, 14 ] ], [ [ 12, 4 ], [ 2 ], [ 24, 14 ] ], [ [ 24, 14 ], [  ], [ 24, 14 ] ], [ [ 1, 1 ], [ 2, 2, 2, 3 ], [ 24, 15 ] ],
  [ [ 2, 1 ], [ 2, 2, 3 ], [ 24, 15 ] ], [ [ 3, 1 ], [ 2, 2, 2 ], [ 24, 15 ] ], [ [ 4, 2 ], [ 2, 3 ], [ 24, 15 ] ], [ [ 6, 2 ], [ 2, 2 ], [ 24, 15 ] ],
  [ [ 8, 5 ], [ 3 ], [ 24, 15 ] ], [ [ 12, 5 ], [ 2 ], [ 24, 15 ] ], [ [ 24, 15 ], [  ], [ 24, 15 ] ] ];
	HTCATS[25]:=[ [ [ 1, 1 ], [ 25 ], [ 25, 1 ] ], [ [ 25, 1 ], [  ], [ 25, 1 ] ], [ [ 1, 1 ], [ 5, 5 ], [ 25, 2 ] ], [ [ 5, 1 ], [ 5 ], [ 25, 2 ] ], [ [ 25, 2 ], [  ], [ 25, 2 ] ]
 ];
	HTCATS[26]:=[ [ [ 2, 1 ], [ 13 ], [ 26, 1 ] ], [ [ 26, 1 ], [  ], [ 26, 1 ] ], [ [ 1, 1 ], [ 2, 13 ], [ 26, 2 ] ], [ [ 2, 1 ], [ 13 ], [ 26, 2 ] ],
  [ [ 13, 1 ], [ 2 ], [ 26, 2 ] ], [ [ 26, 2 ], [  ], [ 26, 2 ] ] ];
	HTCATS[27]:=[ [ [ 1, 1 ], [ 27 ], [ 27, 1 ] ], [ [ 27, 1 ], [  ], [ 27, 1 ] ], [ [ 1, 1 ], [ 3, 9 ], [ 27, 2 ] ], [ [ 3, 1 ], [ 9 ], [ 27, 2 ] ],
  [ [ 9, 1 ], [ 3 ], [ 27, 2 ] ], [ [ 27, 2 ], [  ], [ 27, 2 ] ], [ [ 3, 1 ], [ 3, 3 ], [ 27, 3 ] ], [ [ 27, 3 ], [  ], [ 27, 3 ] ], [ [ 3, 1 ], [ 9 ], [ 27, 4 ] ],
  [ [ 27, 4 ], [  ], [ 27, 4 ] ], [ [ 1, 1 ], [ 3, 3, 3 ], [ 27, 5 ] ], [ [ 3, 1 ], [ 3, 3 ], [ 27, 5 ] ], [ [ 9, 2 ], [ 3 ], [ 27, 5 ] ], [ [ 27, 5 ], [  ], [ 27, 5 ] ] ];
	HTCATS[28]:=[ [ [ 4, 1 ], [ 7 ], [ 28, 1 ] ], [ [ 28, 1 ], [  ], [ 28, 1 ] ], [ [ 1, 1 ], [ 4, 7 ], [ 28, 2 ] ], [ [ 4, 1 ], [ 7 ], [ 28, 2 ] ],
  [ [ 7, 1 ], [ 4 ], [ 28, 2 ] ], [ [ 28, 2 ], [  ], [ 28, 2 ] ], [ [ 2, 1 ], [ 2, 7 ], [ 28, 3 ] ], [ [ 4, 2 ], [ 7 ], [ 28, 3 ] ], [ [ 14, 1 ], [ 2 ], [ 28, 3 ] ],
  [ [ 28, 3 ], [  ], [ 28, 3 ] ], [ [ 1, 1 ], [ 2, 2, 7 ], [ 28, 4 ] ], [ [ 2, 1 ], [ 2, 7 ], [ 28, 4 ] ], [ [ 4, 2 ], [ 7 ], [ 28, 4 ] ],
  [ [ 7, 1 ], [ 2, 2 ], [ 28, 4 ] ], [ [ 14, 2 ], [ 2 ], [ 28, 4 ] ], [ [ 28, 4 ], [  ], [ 28, 4 ] ] ];
	HTCATS[29]:=[ [ [ 1, 1 ], [ 29 ], [ 29, 1 ] ], [ [ 29, 1 ], [  ], [ 29, 1 ] ] ];
	HTCATS[30]:=[ [ [ 2, 1 ], [ 3, 5 ], [ 30, 1 ] ], [ [ 6, 1 ], [ 5 ], [ 30, 1 ] ], [ [ 10, 2 ], [ 3 ], [ 30, 1 ] ], [ [ 30, 1 ], [  ], [ 30, 1 ] ],
  [ [ 2, 1 ], [ 3, 5 ], [ 30, 2 ] ], [ [ 6, 2 ], [ 5 ], [ 30, 2 ] ], [ [ 10, 1 ], [ 3 ], [ 30, 2 ] ], [ [ 30, 2 ], [  ], [ 30, 2 ] ], [ [ 2, 1 ], [ 3, 5 ], [ 30, 3 ] ],
  [ [ 6, 1 ], [ 5 ], [ 30, 3 ] ], [ [ 10, 1 ], [ 3 ], [ 30, 3 ] ], [ [ 30, 3 ], [  ], [ 30, 3 ] ], [ [ 1, 1 ], [ 2, 3, 5 ], [ 30, 4 ] ],
  [ [ 2, 1 ], [ 3, 5 ], [ 30, 4 ] ], [ [ 3, 1 ], [ 2, 5 ], [ 30, 4 ] ], [ [ 5, 1 ], [ 2, 3 ], [ 30, 4 ] ], [ [ 6, 2 ], [ 5 ], [ 30, 4 ] ], [ [ 10, 2 ], [ 3 ], [ 30, 4 ] ],
  [ [ 15, 1 ], [ 2 ], [ 30, 4 ] ], [ [ 30, 4 ], [  ], [ 30, 4 ] ] ];
	HTCATS[31]:=[ [ [ 1, 1 ], [ 31 ], [ 31, 1 ] ], [ [ 31, 1 ], [  ], [ 31, 1 ] ] ];
	D:=QuasiIsomorph_alt(C);
	if Order(D)>31 then
		Print("The size is greater than 31");
		return fail;
	fi;
	HTD:=HAPHomotopyTuple(D);
	n:=Order(D);
	i:=Position(HTCATS[n],HTD);
	if n=16 and i = 5 then
		if Homology(D,2)=[2] then
			return [4,4];
		fi;
	fi;
	return [n,i];
end);
########################################################
########################################################


########################################################
########################################################
InstallGlobalFunction(SmallCatOneGroup,
function(n,k)
	local G,QN,len;
	
	if n=1 and k=1 then
		G:=TrivialGroup();
		return Objectify( HapCatOneGroup , rec(  
				sourceMap:=IdentityMapping(G) , 
				targetMap:=IdentityMapping(G) ) );
	fi;
	QN:=[];
	QN[2]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[3]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[4]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 4 ] ];
	QN[5]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[6]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[7]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[8]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 4 ], [ 2, 6 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ], [ 4, 1 ], [ 5, 1 ], [ 5, 2 ], [ 5, 4 ], [ 5, 6 ] ];
	QN[9]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 4 ] ];
	QN[10]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[11]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[12]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 3, 2 ], [ 4, 1 ], [ 4, 2 ], [ 4, 3 ],
	  [ 4, 4 ], [ 5, 1 ], [ 5, 2 ], [ 5, 4 ], [ 5, 5 ], [ 5, 6 ], [ 5, 8 ] ];
	QN[13]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[14]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[15]:=[ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ];
	QN[16]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 3, 3 ], [ 2, 5 ], [ 3, 1 ], [ 3, 2 ], [ 3, 4 ], [ 4, 1 ], [ 4, 3 ],
	  [ 5, 1 ], [ 5, 2 ], [ 5, 4 ], [ 5, 6 ], [ 6, 1 ], [ 6, 2 ], [ 7, 1 ], [ 7, 2 ], [ 8, 1 ], [ 8, 2 ], [ 9, 1 ], [ 10, 1 ], [ 10, 2 ], [ 10, 5 ], [ 10, 7 ], [ 10, 9 ],
	  [ 10, 12 ], [ 11, 1 ], [ 11, 2 ], [ 11, 3 ], [ 11, 5 ], [ 11, 7 ], [ 11, 9 ], [ 12, 1 ], [ 12, 3 ], [ 13, 1 ], [ 13, 2 ], [ 14, 1 ],
	  [ 14, 2 ], [ 14, 4 ], [ 14, 7 ], [ 14, 9 ] ];
	QN[17]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[18]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ], [ 3, 4 ], [ 4, 1 ],
	  [ 4, 2 ], [ 4, 4 ], [ 5, 1 ], [ 5, 2 ], [ 5, 3 ], [ 5, 5 ], [ 5, 7 ], [ 5, 8 ] ];
	QN[19]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[20]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 3, 2 ], [ 4, 1 ], [ 4, 2 ], [ 4, 3 ],
	  [ 4, 4 ], [ 5, 1 ], [ 5, 2 ], [ 5, 4 ], [ 5, 5 ], [ 5, 6 ], [ 5, 8 ] ];
	QN[21]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[22]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[23]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[24]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 4, 1 ], [ 4, 2 ], [ 5, 1 ], [ 5, 2 ],
	  [ 5, 3 ], [ 5, 4 ], [ 6, 1 ], [ 6, 2 ], [ 6, 3 ], [ 6, 4 ], [ 7, 1 ], [ 7, 3 ], [ 7, 4 ], [ 7, 6 ], [ 8, 1 ], [ 8, 2 ], [ 8, 3 ], [ 8, 4 ], [ 9, 1 ], [ 9, 2 ], [ 9, 4 ],
	  [ 9, 5 ], [ 9, 7 ], [ 9, 9 ], [ 9, 10 ], [ 9, 12 ], [ 10, 1 ], [ 10, 2 ], [ 10, 3 ], [ 10, 4 ], [ 10, 5 ], [ 10, 6 ], [ 11, 1 ],
	  [ 11, 2 ], [ 12, 1 ], [ 12, 2 ], [ 13, 1 ], [ 13, 2 ], [ 13, 3 ], [ 13, 4 ], [ 14, 1 ], [ 14, 2 ], [ 14, 4 ], [ 14, 5 ], [ 14, 6 ], [ 14, 8 ], [ 15, 1 ], [ 15, 2 ],
	  [ 15, 4 ], [ 15, 5 ], [ 15, 7 ], [ 15, 9 ], [ 15, 10 ], [ 15, 12 ] ];
	QN[25]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 4 ] ];
	QN[26]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ];
	QN[27]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 4 ], [ 2, 6 ], [ 3, 1 ], [ 3, 2 ], [ 4, 1 ], [ 4, 2 ], [ 5, 1 ], [ 5, 2 ], [ 5, 4 ], [ 5, 6 ] ];
	QN[28]:=[ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ], [ 3, 4 ], [ 4, 1 ], [ 4, 2 ], [ 4, 4 ], [ 4, 5 ], [ 4, 6 ], [ 4, 8 ] ];
	QN[29]:=[ [ 1, 1 ], [ 1, 2 ] ];
	QN[30]:=[ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ],
	  [ 3, 4 ], [ 4, 1 ], [ 4, 2 ], [ 4, 3 ], [ 4, 4 ], [ 4, 5 ], [ 4, 6 ], [ 4, 7 ], [ 4, 8 ] ];
	QN[31]:=[ [ 1, 1 ], [ 1, 2 ] ];	
	
	if n>31 then
		Print(" The function only applies for a cat one group of order less than 32\n");
		return fail;
	fi;
	len:=Length(QN[n]);
	if k>len then
		Print("There are just ",len," quasi-isomorphism types of size ",n,"\n");
		return fail;
	fi;
	return XmodToHAP_alt(Cat1Select(n,QN[n][k][1],QN[n][k][2]));
end);
#############################################
#############################################

	
		


