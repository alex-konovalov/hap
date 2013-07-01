InstallGlobalFunction(CrystGFullBasis_alt,    # search for a G-fullbasis of a G-lattice 
                                          # for the given crystallographic G generated by 
					   # the set of generators S
function(arg)
local G,P,Bt,d,n,vect,
      i,j,a,faclst,S,gens,L,c,
      B_delta,ctr,v,
      x,SbGrp,T,coef;

gens:=GeneratorsOfGroup(arg[1]);
G:=AffineCrystGroup(gens);
SbGrp:=TranslationSubGroup(G);
Bt:=G!.TranslationBasis;
n:=G!.DimensionOfMatrixGroup-1;
if Length(arg)=1 then 
L:=CrystCubicalTiling(n);
Add(L,Bt,1);
for i in [1..Length(L)] do
B_delta:=CrystGFullBasis_alt(G,[L[i],Sum(L[i])/2]);
if IsList(B_delta) then return B_delta;
fi;
od;
return fail;
else #begin of length 2 input

L:=arg[2][1];
c:=arg[2][2];
vect:=Sum(L)/2-c;
S:=RightTransversal(G,SbGrp);
P:=PointGroup(G);

d:=DivisorsInt(Order(P));
i:=Length(d);

##########

while i>0 do
faclst:=FactorizationNParts(d[i],n);
for x in faclst do
 B_delta:=List([1..n],i->x[i]^-1*L[i]);
 if IsCrystSufficientLattice(B_delta,S) then 
 ctr:=Sum(B_delta)/2-vect;
 coef:=CombinationDisjointSets(x);
 j:=1;
 while j <= d[i] do
  v:=ctr+coef[j]*B_delta;
  if IsCrystSameOrbit(G,Bt,S,ctr,v)=false then break;fi;
  j:=j+1;
 od;
 if j=d[i]+1 then return [B_delta,ctr];fi;
fi;
od;
i:=i-1;
od;
return fail;

fi;  #end of length 2 input

end);