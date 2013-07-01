##################################################################################
InstallGlobalFunction(ChainComplexOfSimplicialGroup,

	function(X)
	local 
		ChainComplexOfSimplicialGroup_Objpre,
		ChainComplexOfSimplicialGroup_Obj,
		ChainComplexOfSimplicialGroup_Mappre,
		ChainComplexOfSimplicialGroup_Map,
		ChainComplexOfSimplicialGroup_Seq;
		  
#########################################################################
#########################################################################

ChainComplexOfSimplicialGroup_Objpre:=function(N,Maps,Bar,Hap)
				local 
					BoundHap,Phi,Psi,Equiv,DimHap,MapBar,tmp,
					Dim,BelowDim,
					i,j,k,n,Psiw,ImageBase,t,
					SearchPos,Dimension,Boundary,
					M,m,ii,jj,BoundChain,
					d0,dm;
			####################
			####################
				BoundHap:= function(i,j,k)  ###input position [i,j] and order element k
					return Hap[i+1]!.boundary(j,k);
				end;
				###########################
				Psi:=function(i,j,w)  ###input position [i,j] and word w
					return Bar[i+1]!.psi(j,w);
				end;
				############################
				Phi:=function(i,j,w)  ###input position [i,j] and word w
					return Bar[i+1]!.phi(j,w);
				end;
				#########################
				Equiv:=function(i,j,w) ###input position [i,j] and word w
					return Bar[i+1]!.equiv(j,w);
				end;
				###########################
				DimHap:=function(i,j) ###input position [i,j] 
					return Hap[i+1]!.dimension(j);
				end;	
			#################################################################################	
			MapBar:=function(i,j,w)  ##input position [n] and word w=[[m,g1..gj]..] of columB{n} ouput: image of w of columB{n-1}
				local Rew,sign,ii,jj,iw,d,tmp;
				if j mod 2 = 0 then
					sign:=1;
				else
					sign:=-1;
				fi;
				Rew:=[];
				for ii in [0..i] do
					d:=Maps(i,ii);
					for iw in w do;
						tmp:=[sign*iw[1]];
						for jj in [1..j] do
							Add(tmp,Image(d,iw[jj+1]));
						od;
						AddWord(Rew,tmp);
					od;
					sign:=-sign;
				od;
				return Rew;		
			end;

			##################################################################################
			######### Dimesion of K_i########################################
			Dim:=[];
			for i in [0..N] do
				k:=0;
				for j in [0..i] do;
					k:=k+DimHap(j,i-j);
				od;
				Dim[i+1]:=k;
			od;
			######################################################
			Dimension:=function(n)
				return Dim[n+1];
			end;
			
			#####################  sum of dimension of Hap below the position (i,j);
			BelowDim:=List([0..N],n->[]);  ###i+1,j+1
			for i in [0..N] do
				for j in [0..N-i] do
					n:=i+j;
					tmp:=0;
					for k in [0..j-1] do
						tmp:=tmp+DimHap(n-k,k);
					od;
					BelowDim[i+1][j+1]:=tmp;
				od;	
			od;

			############################################################
			SearchPos:=function(n,t)  ### n: element Chaincomplex of Totalcomplex, k is order element basis, output: [i,j]
				local count,j,k; 

				count:=0;
				for j in [0..n] do
					k:=t-count;
					count:=count+DimHap(n-j,j);
					if t <= count then
						return [n-j,j,k];
						break;
					fi;
				od;
			end;		
			##################################################################	
			d0:=function(i,j,k)   ##input R(i,j) k is order of elemmet of R(i,j)
				local n,t,beg,Bound,Rew;
				n:=i+j;
				if n=0 then
					return [0];
				fi;
				Rew:=List([1..Dimension(n-1)],x->0);   
				if j=0 then 
					return Rew;
				fi;
				beg:=BelowDim[i+1][j];   ###below(i,j-1)
				Bound:=BoundHap(i,j,k);
				for t in [1..DimHap(i,j-1)] do
					Rew[beg+t]:=Bound[t];
				od;
			return Rew;
			end;
			###################################################################
			ImageBase:=[];				##[i][j+1][m][k]   R_n->B_n--B-->
			for i in [1..N] do 
				ImageBase[i]:=[];              
				for j in [0..N-i]do
					ImageBase[i][j+1]:=[];
					for m in [1..i] do
						ImageBase[i][j+1][m]:=[];
					od;
				od;
			od;
			#####Create ImageBase[i][j+1][1][k]
			for i in [1..N] do
				for j in [0..N-i] do
					for k in [1..DimHap(i,j)] do
						ImageBase[i][j+1][1][k]:=MapBar(i,j,Psi(i,j,[[1,k]]));
					od;
				od;
			od;	
			#####Creat m>1###################
			for i in [2..N]do
				for j in [0..N-i]do
					for m in [2..i] do
						for k in [1..DimHap(i,j)] do
							tmp:=StructuralCopy(ImageBase[i][j+1][m-1][k]);
							ImageBase[i][j+1][m][k]:=MapBar(i-m+1,j+m-1,Equiv(i-m+1,j+m-2,tmp));		
						od;
					od;
				od;
			od;	
			####################################################
			####################################################
			dm:=function(i,j,m,k) 	## input d_m input R(i,j) k is order of elemmet of R(i,j) m>0
				local n,t,beg,Rew,Phiw;
				n:=i+j;
				if n=0 then
					return [0];
				fi;
				Rew:=List([1..Dimension(n-1)],x->0);   
				if m>i then 
					return Rew;
				fi;
				Phiw:= Phi(i-m,j+(m-1),ImageBase[i][j+1][m][k]);
				beg:=BelowDim[(i-m)+1][j+(m-1)+1];
				for t in [1..DimHap(i-m,j+(m-1))] do
					Rew[beg+t]:=Phiw[t];
				od;
			return Rew;
			end;		
			#######################################################################
			BoundChain:=List([0..N],x->[]);  
			BoundChain[1][1]:=[0];  ###(d(0,1)=0  n+1,k
			for n in [1..N] do
				for t in [1..Dimension(n)] do
					M:=SearchPos(n,t);
					i:=M[1];
					j:=M[2];
					k:=M[3];
					tmp:=d0(i,j,k);
					for m in [1..i] do
						tmp:=tmp+dm(i,j,m,k);  #compute d_ii
					od;
				BoundChain[n+1][t]:=tmp;
				od;
			od;
			##################
			Boundary:=function(n,k)
				return BoundChain[n+1][k];
			end;
							
			#########################################################################
			return Objectify( HapChainComplex, rec(
							boundary:=Boundary,
							dimension:=Dimension,
						  properties:= [ [ "length",N],
								[ "type", "chainComplex" ], 
								[ "characteristic",0 ] ] ) );
end;

#########################################################################
#########################################################################
ChainComplexOfSimplicialGroup_Obj:=function(G)
local 
		N,Maps,Grps,Bar,Hap,Res;
		
	N:=EvaluateProperty(G,"length");
	Maps:=G!.boundariesList;
	Grps:=G!.groupsList;
	Res:=List([0..N],i->ResolutionGenericGroup(Grps(i),N-i));
	Bar:=List([0..N],i->BarComplexEquivalence(Res[i+1]));
    Hap:=List([0..N],i->TensorWithIntegers(Res[i+1]));
	return ChainComplexOfSimplicialGroup_Objpre(N,Maps,Bar,Hap);
end;

#########################################################################
#########################################################################
ChainComplexOfSimplicialGroup_Mappre:=function(N,map,MapsH,BarH,HapH,MapsG,BarG,HapG)

	local 
		PsiH,PhiH,EquivH,DimH,DimensionH,MapBarH,LDimH,SearchPosH,ZeroVectorH,ImgBaseH,
		PsiG,PhiG,EquivG,DimG,DimensionG,MapBarG,LDimG,SearchPosG,ZeroVectorG,ImgG,Imgs,
		i,j,k,m,n,t,tmp,Tmp,itmp,w,LM,FF,LowDimG,Mapping,
		MapBarHG;
	
	############################
	PsiH:=function(i,j,w)  ###input position [i,j] and word w
		return BarH[i+1]!.psi(j,w);
	end;
	############################
	PhiH:=function(i,j,w)  ###input position [i,j] and word w
		return BarH[i+1]!.phi(j,w);
	end;
	############################
	EquivH:=function(i,j,w) ###input position [i,j] and word w
		return BarH[i+1]!.equiv(j,w);
	end;
	############################
	DimH:=function(i,j) ###input position [i,j] 
		return HapH[i+1]!.dimension(j);
	end;	
	###################################################
	###################################################
	MapBarH:=function(i,j,w)  ##input position [n] and word w=[[m,h1..hn]..] of columB{n} ouput: w of columB{n-1}
		local Rew,sign,k,t,iw,d,n,tmp;
		
		n:=j+1;
		if j mod 2 = 0 then
			sign:=1;
		else
			sign:=-1;
		fi;
		Rew:=[];
		for k in [0..i] do
			d:=MapsH(i,k);
			for iw in w do;
				tmp:=[sign*iw[1]];
				for t in [2..n] do
					Add(tmp,Image(d,iw[t]));
				od;
				AddWord(Rew,tmp);
			od;
			sign:=-sign;
		od;
		return Rew;		
	end;
###################################################
###################################################	
	LDimH:=[];
	for n in [0..N] do
		k:=0;
		for j in [0..n] do;
			k:=k+DimH(n-j,j);
		od;
		LDimH[n+1]:=k;
	od;
######################################################
	DimensionH:=function(n)
		return LDimH[n+1];
	end;
#############################################
#############################################
	SearchPosH:=function(n,t)  ### n: element Chaincomplex of Totalcomplex, k is order element basis, output: [i,j]
		local count,j,k; 
		if t>DimensionH(n) then
			return fail;
		fi;
		count:=0;
		for j in [0..n] do
			k:=t-count;
			count:=count+DimH(n-j,j);
			if t <= count then
				return [n-j,j,k];
				break;
			fi;
		od;
	end;
	
#######################For H  #############################
###########################################################	
	PsiG:=function(i,j,w)  ###input position [i,j] and word w
		return BarG[i+1]!.psi(j,w);
	end;
	########################################
	PhiG:=function(i,j,w)  ###input position [i,j] and word w
		return BarG[i+1]!.phi(j,w);
	end;
	#########################################
	EquivG:=function(i,j,w) ###input position [i,j] and word w
		return BarG[i+1]!.equiv(j,w);
	end;
	########################################
	DimG:=function(i,j) ###input position [i,j] 
		return HapG[i+1]!.dimension(j);
	end;
##################################################
##################################################
	MapBarG:=function(i,j,w)  ##input position [n] and word w=[[m,g1..gn]..] of columB{n} ouput: w of columB{n-1}
		local Rew,sign,k,t,iw,d,n,tmp;
		n:=j+1;
		if j mod 2 = 0 then
			sign:=1;
		else
			sign:=-1;
		fi;
		Rew:=[];
		
		for k in [0..i] do
			d:=MapsG(i,k);
			for iw in w do;
				tmp:=[sign*iw[1]];
				for t in [2..n] do
					Add(tmp,Image(d,iw[t]));
				od;
				AddWord(Rew,tmp);
			od;
			sign:=-sign;
		od;
		return Rew;		
	end;
#############################################
#############################################
	LDimG:=[];
	for n in [0..N] do
		k:=0;
		for j in [0..n] do;
			k:=k+DimG(n-j,j);
		od;
		LDimG[n+1]:=k;
	od;
##############################################
	DimensionG:=function(n)
		return LDimG[n+1];
	end;

#############################################
#############################################
	SearchPosG:=function(n,t)  ### n: element Chaincomplex of Totalcomplex, k is order element basis, output: [i,j]
		local count,j,k; 
		if t>DimensionG(n) then
			return fail;
		fi;
		count:=0;
		for j in [0..n] do
			k:=t-count;
			count:=count+DimG(n-j,j);
			if t <= count then
				return [n-j,j,k];
				break;
			fi;
		od;
	end;	

	
#########################Create the map between Chaincomplex H and G ####################
#########################################################################################
	MapBarHG:=function(i,j,w)  ##Finding the image of w:=[[m,h_1,..h_k],....] at position (i,j) from Bar if H to Bar of G
		local n,iw,f,k,tmp,Rew;
		n:=j+1;     ###iw:=[m,h1,..hk]
		f:=map(i);
		Rew:=[];
		for iw in w do
			tmp:=[iw[1]];
			for k in [2..n] do
			   Add(tmp,Image(f,iw[k]));
			od;
			AddWord(Rew,tmp);
		od;
		return Rew;
	end;	
######################################	
######################################
	ImgBaseH:=[];				##[i+1][j+1][m+1][k]   RH_n->BH_n
	for i in [0..N] do 
		ImgBaseH[i+1]:=[];              
		for j in [0..N-i]do
			ImgBaseH[i+1][j+1]:=[];
			for m in [0..i] do
				ImgBaseH[i+1][j+1][m+1]:=[];
			od;
		od;
	od;
	#####Create ImgBase[i+1][j+1][0+1][k]
	
	for i in [0..N] do
		for j in [0..N-i] do
			for m in [0..i] do
				for k in [1..DimH(i,j)] do
					ImgBaseH[i+1][j+1][m+1][k]:=PsiH(i,j,[[1,k]]);
				od;
			od;
		od;
	od;
	
	#####Create ImgBaseH[i+1][j+1][m+1][k] m>0
	for i in [1..N]do
		for j in [0..N-i]do
			for m in [1..i] do
				for k in [1..DimH(i,j)] do
					tmp:=StructuralCopy(ImgBaseH[i+1][j+1][m][k]);
					ImgBaseH[i+1][j+1][m+1][k]:=EquivH(i-m,j+(m-1),(MapBarH(i-(m-1),j+(m-1),tmp)));		
				od;
			od;
		od;
	od;	
	############################ for BarH -->BarG
    ImgG:=[];				##[i+1][j+1][m+1][k]   RH_n->BH_n
	for i in [0..N] do 
		ImgG[i+1]:=[];              
		for j in [0..N-i]do
			ImgG[i+1][j+1]:=[];
			for m in [0..i] do
				ImgG[i+1][j+1][m+1]:=[];
			od;
		od;
	od;
	
	for i in [0..N]do
		for j in [0..N-i]do
			for m in [0..i] do
				for k in [1..DimH(i,j)] do	
				ImgG[i+1][j+1][m+1][k]:=MapBarHG(i-m,j+m,ImgBaseH[i+1][j+1][m+1][k]);
				od;
			od;
		od;
	od;		
	########Create Imgs for Bar G to HapG
	Imgs:=[];				##[i+1][j+1][m+1][k]   RH_n->BH_n
	for i in [0..N] do 
		Imgs[i+1]:=[];              
		for j in [0..N-i]do
			Imgs[i+1][j+1]:=[];
			for m in [0..i] do
				Imgs[i+1][j+1][m+1]:=[];
			od;
		od;
	od;
		
	for i in [0..N]do
		for j in [0..N-i]do
			for k in [1..DimH(i,j)] do
					Tmp:=List([0..i],m->[]);
					for m in [0..i] do   ##Create Tmp(m,0)
						Tmp[m+1][0+1]:=ImgG[i+1][j+1][m+1][k];
					od;
					for m in [0..i-1] do
						for n in [1..i-m] do
							w:=StructuralCopy(Tmp[m+1][n]);  ##n-1
							Tmp[m+1][n+1]:=MapBarG(i-(m+(n-1)),j+(m+n),EquivG(i-(m+(n-1)),j+(m+(n-1)),w));
						od;
					od;
					for m in [0..i] do
						itmp:=[];
						for n in [0..m] do
							Append(itmp,Tmp[n+1][m-n+1]);
						od;
						Imgs[i+1][j+1][m+1][k]:=PhiG(i-m,j+m,itmp);
					od;
			od;
		od;
	od;		

    LowDimG:=List([0..N],n->[]);
	for i in [0..N] do
		for j in [0..N-i] do
			n:=i+j;
			tmp:=0;
			for k in [0..j-1] do
				tmp:=tmp+DimG(n-k,k);
			od;
			LowDimG[i+1][j+1]:=tmp;
		od;	
	od;		
	####################################
	FF:=List([0..N],n->[]);
	for n in [0..N] do
		for t in [1..DimensionH(n)] do
			LM:=SearchPosH(n,t);
			i:=LM[1];
			j:=LM[2];
			k:=LM[3];		
			Tmp:=List([1..LowDimG[i+1][j+1]],m->0);
			for m in [0..i] do
				Append(Tmp,Imgs[i+1][j+1][m+1][k]);
			od;
			FF[n+1][t]:=Tmp;	
			
		od;
	od;
#################################################
#################################################
  Mapping:=function(v,n)
	local Rew,len,k;
	Rew:=List([1..DimensionG(n)],x->0);
	len:=Length(v);
	for k in [1..len] do;
		if v[k] <> 0 then
			Rew:=Rew+v[k]*FF[n+1][k];
		fi;
	od;	
	return Rew;
  end;
  
  
 return Mapping;
end;
#########################################################################
#########################################################################

ChainComplexOfSimplicialGroup_Map:=function(Sf)
    local map,N,
		H,GrpsH,MapsH,RH,HapH,BarH,
		G,GrpsG,MapsG,RG,HapG,BarG;
	
    H:=Sf!.source;
	G:=Sf!.target;
	map:=Sf!.mapping;
	N:=EvaluateProperty(Sf,"length");

	GrpsH:=H!.groupsList;
	MapsH:=H!.boundariesList;
	RH:=List([0..N],i->ResolutionGenericGroup(GrpsH(i),(N+1)-i));
	HapH:=List([0..N],i->TensorWithIntegers(RH[i+1])); 
	BarH:=List([0..N],i->BarComplexEquivalence(RH[i+1]));
	
	GrpsG:=G!.groupsList;
	MapsG:=G!.boundariesList;	
	RG:=List([0..N],i->ResolutionGenericGroup(GrpsG(i),(N+1)-i));
	HapG:=List([0..N],i->TensorWithIntegers(RG[i+1])); 
	BarG:=List([0..N],i->BarComplexEquivalence(RG[i+1]));
	
	return Objectify( HapChainMap, rec(
                source := ChainComplexOfSimplicialGroup_Objpre(N,MapsH,BarH,HapH),
                target := ChainComplexOfSimplicialGroup_Objpre(N,MapsG,BarG,HapG),
                mapping := ChainComplexOfSimplicialGroup_Mappre(N,map,MapsH,BarH,HapH,MapsG,BarG,HapG),
                properties:= [ [ "type", "chainMap" ],
                    [ "characteristic",0 ] ] ) );
end;


######################################################################
######################################################################
ChainComplexOfSimplicialGroup_Seq:=function(L)

local  
	len,k,
	LSG,G,N,Grps,Maps,R,Hap,Bar,KG,RewL,map;

	len:=Length(L);
	LSG:=[];
	for k in [1..len] do;
		LSG[k]:=L[k]!.source;
	od;
	LSG[len+1]:=L[len]!.target;
	Hap:=[];
	Bar:=[];
	Maps:=[];
	KG:=[];
	for k in [1..len+1] do
		G:=LSG[k];
		N:=EvaluateProperty(G,"length");
		Grps:=G!.groupsList;
		Maps[k]:=G!.boundariesList;	
		R:=List([0..N],i->ResolutionGenericGroup(Grps(i),(N+1)-i));
		Hap[k]:=List([0..N],i->TensorWithIntegers(R[i+1])); 
		Bar[k]:=List([0..N],i->BarComplexEquivalence(R[i+1]));
		KG[k]:=ChainComplexOfSimplicialGroup_Objpre(N,Maps[k],Bar[k],Hap[k]);
	od;
	
	RewL:=[];
	for k in [1..len] do
		N:=EvaluateProperty(L[k],"length");
		map:=L[k]!.mapping;
		RewL[k]:=Objectify( HapChainMap, rec(
					source := KG[k],
					target := KG[k+1],
					mapping := ChainComplexOfSimplicialGroup_Mappre(N,map,Maps[k],Bar[k],Hap[k],Maps[k+1],Bar[k+1],Hap[k+1]),
					properties:= [ [ "type", "chainMap" ],
						[ "characteristic",0 ] ] ) );
	od;
	return RewL;
	end;

##################################################################
##################################################################
if IsHapSimplicialGroup(X) then
	return ChainComplexOfSimplicialGroup_Obj(X);
fi;

if IsHapSimplicialGroupMap(X) then
	return ChainComplexOfSimplicialGroup_Map(X);
fi;

if IsList(X) then
	return ChainComplexOfSimplicialGroup_Seq(X);
fi;

	
end);