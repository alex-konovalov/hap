#(C) Graham Ellis

##################################################################
##################################################################
InstallGlobalFunction(SimplicialComplexToRegularCWComplex,
function(arg)
local
	K,DM,NrCells,Boundaries,tmp,TMP,Coboundaries,Properties,
        Orientation, 
        cnt,b,bb,k,n,s,x,i,j,dim ;

K:=arg[1];
if Length(arg)>1 then dim:=arg[2]; else dim:=Dimension(K); fi; 

####################
NrCells:=function(n);
if n>dim then return 0; fi;
return Length(Filtered(Boundaries[n+1],x->not x[1]=0));
end;
####################

#dim:=Dimension(K);
Properties:=[["dimension",dim]];

#############################
Orientation:=[];
#Orientation[1]:=ListWithIdenticalEntries(K!.nrSimplices(0),[1]);
Orientation[1]:=List([1..K!.nrSimplices(0)],i->[1]); #more memory but safer!!
for n in [1..dim] do
  tmp:=[];  
  for i in [1..n+1] do
  Add(tmp,(-1)^(i+1));
  od;
#Orientation[n+1]:=ListWithIdenticalEntries(K!.nrSimplices(n),tmp);
Orientation[n+1]:=List([1..K!.nrSimplices(n)],i->StructuralCopy(tmp));
od;

#############################

### BOUNDARIES BEGIN ######################
Boundaries:=[]; #Boundaries[n+1] contains the info on n-cells
Boundaries[1]:=List([1..K!.nrSimplices(0)],x->[1,0]);

                 ##We denote by 0 the unique vertex in dimension -1.

for n in [1..dim] do

  Boundaries[n+1]:=[];
  tmp:=List(Boundaries[1],x->[]);
  TMP:=List(Boundaries[1],x->[]);
  cnt:=0;
  for s in K!.simplicesLst[n] do
    cnt:=cnt+1;
    Add(tmp[s[1]],s);
    Add(TMP[s[1]],cnt);
  od;
 for k in [1..K!.nrSimplices(n)] do
 bb:=K!.simplices(n,k);
 bb:=SSortedList(bb);

 b:=List(bb,x->  Difference(bb,[x]) );
 Apply(b,x->   TMP[x[1]][Position(tmp[x[1]],x)] );

 Boundaries[n+1][k]:=Concatenation([Length(b)],b);
 od;
od;
Boundaries[dim+2]:=[];
### BOUNDARIES END ###############################

### COBOUNDARIES BEGIN ######################
Coboundaries:=[];; #Coboundaries[n+1] contains the info on n-cells.
for n in [0..dim] do
  k:=n+3;
  Coboundaries[n+1]:=List(Boundaries[n+1],i->[0]);
  for j in [1..Length(Boundaries[n+2])] do
    b:=Boundaries[n+2][j]; 
    for i in b{[2..k]} do
      Coboundaries[n+1][i][1]:=Coboundaries[n+1][i][1]+1;
      Add(Coboundaries[n+1][i],j);
    od;
  od;
  #for b in Coboundaries[n+1] do
  #Append(b,List([1..Length(b)-1],a->1)); 
  #od;
od;
Coboundaries[dim+1]:=List(Boundaries[dim+1],a->[0]);
### COBOUNDARIES END ###############################


return Objectify(HapRegularCWComplex,
       rec(
           nrCells:=NrCells,
           boundaries:=Boundaries,
           coboundaries:=Coboundaries,
           orientation:=Orientation,
           vectorField:=fail,
           inverseVectorField:=fail,
           criticalCells:=fail,
           properties:=Properties));

end);
##################################################################
##################################################################

#############################################
#############################################
InstallOtherMethod(Dimension,
"Dimension of  regular CW-complex",
[IsHapRegularCWComplex],
function(f) return EvaluateProperty(f,"dimension");
return EvaluateProperty(f,"dimension");
end);
#############################################
#############################################

#############################################
#############################################
InstallGlobalFunction(HAPContractRegularCWComplex,
function(Y)
local
      Contract, nn, dim, bool, BOOL, FREE;

#############################################
##### The work-horse function.###############
Contract:=function(n)
local

      b, C, i, j, t, cob, pos, bool,
      Free, UBoundaries, UCoboundaries,
      MBoundaries, MCoboundaries, LCoboundaries, U;

#This function removes pairs of n- and (n+1)-cells if possible.
#U=Upper, M=Middle and L=Lower dimensional cells.

####################
####################
if Y!.vectorField=fail then
Y!.vectorField:=List([1..Dimension(Y)],i->[]);
Y!.inverseVectorField:=List([1..Dimension(Y)],i->[]);
Y!.bnd:=StructuralCopy(Y!.boundaries);
Y!.cobnd:=StructuralCopy(Y!.coboundaries);
fi;
####################
####################

MCoboundaries:=Y!.cobnd[n+1];
MBoundaries:=Y!.bnd[n+1];
UCoboundaries:=Y!.cobnd[n+2];
UBoundaries:=Y!.bnd[n+2];
if n>0 then
  LCoboundaries:=Y!.cobnd[n];
fi;
C:=Length(MCoboundaries);

#######################
#######################THIS TAKES ALL THE TIME
if not IsBound(FREE) then FREE:=[1..C]; fi;

Free:=[];
for i in FREE do
if MCoboundaries[i][1]=1 then Add(Free,i);fi;
od;

#Print([Length(FREE),Length(Free)],"  ");

if Length(Free)=0 then Unbind(FREE); return false;fi;
#######################
#######################

for i in Free do
if MCoboundaries[i][1]=1 then
Y!.vectorField[n+1][MCoboundaries[i][2]]:=i;
Y!.inverseVectorField[n+1][i]:=MCoboundaries[i][2];
      ###
  if n>0 then
    b:=MBoundaries[i];
    for j in StructuralCopy(b{[2..1+b[1]]}) do
     t:=LCoboundaries[j][1];
     LCoboundaries[j][1]:=LCoboundaries[j][1]-1;
     cob:=LCoboundaries[j];
     pos:=Position(cob{[2..t+1]},i);
     LCoboundaries[j]:=Concatenation(cob{[1..pos]},cob{[2+pos..Length(cob)]});
    od;
  fi;
      ###
    U:=MCoboundaries[i][2];
    b:=UBoundaries[U];
    for j in StructuralCopy(b{[2..1+b[1]]}) do
     t:=MCoboundaries[j][1];
     MCoboundaries[j][1]:=MCoboundaries[j][1]-1;
if t=2 then Add(Free,j);fi;############################ADDED
     cob:=MCoboundaries[j];
     pos:=Position(cob{[2..t+1]},U);
     MCoboundaries[j]:=Concatenation(cob{[1..pos]},cob{[2+pos..Length(cob)]});
    od;
      ###
  MBoundaries[i]:=[0];
  UBoundaries[U]:=[0];
  UCoboundaries[U]:=[0];
  MCoboundaries[i]:=[0];
fi;
od;

Y!.bnd[n+2]:=UBoundaries;
Y!.cobnd[n+2]:=UCoboundaries;
Y!.bnd[n+1]:=MBoundaries;
Y!.cobnd[n+1]:=MCoboundaries;
if n>0 then
  Y!.cobnd[n]:=LCoboundaries;
fi;

Y!.nrCells:=function(k);
            if k>EvaluateProperty(Y,"dimension") then return 0; fi;
            return Length(Filtered(Y!.bnd[k+1],x->not x[1]=0));
            end;

if Length(Free)>0 then FREE:=Free; return true;
else Unbind(FREE); return false; fi;

end;
####End of work-horse function.#############
############################################

dim:=EvaluateProperty(Y,"dimension");
bool:=true;
BOOL:=true;
nn:=dim-1;

while BOOL or nn>0 do
BOOL:=false;
  for nn in Reversed([0..dim-1]) do
    while bool do
      bool:=Contract(nn);
      if bool=true then BOOL:=true; fi;
    od;
    bool:=true;
  od;
od;

end);
############################################
############################################

#####################################################################
#####################################################################
InstallOtherMethod(Size,
"Volume of a regular CW-complex",
[IsHapRegularCWComplex],
function(Y) return Sum(List( [1..Length(Y!.boundaries)],i->Y!.nrCells(i-1)));
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallGlobalFunction(HAPRemoveCellFromRegularCWComplex,
function(Y,dim,n)
local  bnd, x,tmp, cobnd;

#Remove the n-th cell in dimension dim

####################
####################
if Y!.vectorField=fail then
Y!.vectorField:=List([1..Dimension(Y)],i->[]);
Y!.inverseVectorField:=List([1..Dimension(Y)],i->[]);
Y!.bnd:=StructuralCopy(Y!.boundaries);
Y!.cobnd:=StructuralCopy(Y!.coboundaries);
fi;
####################
####################


dim:=dim+1;

bnd:=Y!.bnd[dim][n];
bnd:=bnd{[2..Length(bnd)]};
Y!.bnd[dim][n]:=[0];

cobnd:=Y!.cobnd[dim][n];          ####Added this loop July 2012
cobnd:=cobnd{[2..Length(cobnd)]};                             #
for x in cobnd do                                             # 
tmp:=Y!.bnd[dim+1][x];                                        #
tmp[1]:=tmp[1]-1;                                             #
tmp[Position(tmp{[2..Length(tmp)]},n)+1]:=-42;                #
tmp:=Filtered(tmp,i->not i = -42);                            #
Y!.bnd[dim+1][x]:=tmp;                                        #
od;                                              ############## 


if dim=1 then  return [dim-1,n]; fi;

for x in bnd do
tmp:=Y!.cobnd[dim-1][x];
tmp[1]:=tmp[1]-1;
tmp[Position(tmp{[2..Length(tmp)]},n)+1]:=-42;

tmp:=Filtered(tmp,i->not i = -42);

Y!.cobnd[dim-1][x]:=tmp;
if IsBound(Y!.free) then
if IsBound(Y!.free[dim-1]) then
if tmp[1]=1 then AddSet(Y!.free[dim-1],x); fi;
fi;
fi;
od;

return [dim-1,n];

end);
##########################################################
##########################################################

##########################################################
##########################################################
InstallGlobalFunction(CriticalCellsOfRegularCWComplex,
function(arg)
local Y,ContractSpace,cells,dim,c,pos,ppos,  b,x, bbooll;

Y:=arg[1];
if not Y!.criticalCells=fail then
return Y!.criticalCells;
fi;

##############################
if Length(arg)>1 then 
cells:=CocriticalCellsOfRegularCWComplex(Y,arg[2]);
if arg[2]<EvaluateProperty(Y,"dimension") then 
Y!.criticalCells:=fail;  fi;
return cells;
fi;
##############################


   ContractSpace:=HAPContractRegularCWComplex;


#######
dim:=0;
while true do
if Y!.nrCells(dim)=0 then break; fi;
dim:=dim+1;
od;
dim:=dim-1;
#######

cells:=[];
ContractSpace(Y);

while true do

  if 
Sum(List( [1..Length(Y!.bnd)],i->Y!.nrCells(i-1)))=0
then  
Y!.criticalCells:=cells; 
Y!.nrCells:=function(k);
            if k>EvaluateProperty(Y,"dimension") then return 0; fi;
            return Length(Filtered(Y!.boundaries[k+1],x->not x[1]=0));
            end;
Unbind(Y!.bnd);
Unbind(Y!.cobnd);
return cells; fi;

  pos:=0;

  while true do
    pos:=pos+1;
    ppos:=PositionProperty(Y!.bnd[dim+1]{[pos..Length(Y!.bnd[dim+1])]},                          x->x[1]>0);    if ppos=fail then dim:=dim-1; break; fi;

  pos:=pos+ppos-1;


#######
#######
if dim=0 then bbooll:=true; else
bbooll:=false;
for b in Y!.bnd[dim+1][pos]{[2..Length(Y!.bnd[dim+1][pos])]} do
if bbooll then break; fi;
if Y!.cobnd[dim][b][1]=2 then bbooll:=true; break; fi;
od;
fi;
#######
#######
 
    c:=HAPRemoveCellFromRegularCWComplex(Y,dim,pos);

    Add(cells,c);

if bbooll then
    ContractSpace(Y);
fi;

  od;
od;

Y!.criticalCells:=cells;
Y!.nrCells:=function(k);
            if k>EvaluateProperty(Y,"dimension") then return 0; fi;
            return Length(Filtered(Y!.boundaries[k+1],x->not x[1]=0));
            end;
Unbind(Y!.bnd);
Unbind(Y!.cobnd);

return cells;
end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallGlobalFunction(CubicalComplexToRegularCWComplex,
function(arg)
local M,dim,C, Properties, Boundaries, Coboundaries, BinLst, 
      LstBin,   bnd,  Boundary, ArrayValueDim, Orientation, 
      Dimension,   n, i, j, k, b, v;

M:=arg[1];
if Length(arg)>1 then dim:=arg[2];
else
dim:=EvaluateProperty(M,"dimension");
fi;
ArrayValueDim:=ArrayValueFunctions(EvaluateProperty(M,"dimension"));

C:=ChainComplex(M);
BinLst:=C!.coordinateToPosition;
LstBin:=C!.positionToCoordinate;

Properties:=[["dimension",dim]];

if Length(arg)=1 then
Dimension:=C!.dimension;
else
###
Dimension:=function(n);
  if n<dim then return C!.dimension(n);
  else return 0; fi;
end;
#######
fi;


#######################################
Boundary:=function(n,j)
local x,poscells,negcells,nn,a,b,cnt;
poscells:=[];
negcells:=[];

cnt:=0;
nn:=LstBin[n+1][j];
for x in [1..Length(nn)] do
  if IsEvenInt(nn[x]) then
    cnt:=cnt+1;
    a:=StructuralCopy(nn);
    a[x]:=a[x]+1;
    b:=StructuralCopy(nn);
    b[x]:=b[x]-1;
    if IsOddInt(cnt) then
        Add(poscells,a);
        Add(negcells,b);
    else
        Add(poscells,b);
        Add(negcells,a);
    fi;
  fi;
od;

Apply(poscells,x->ArrayValueDim(BinLst,x));
Apply(negcells,x->ArrayValueDim(BinLst,x));
return [poscells,negcells];
end;
################################

##############################
Boundaries:=[];
Boundaries[1]:=List([1..C!.dimension(0)],x->[1,0]);
Orientation:=[];
Orientation[1]:=List([1..C!.dimension(0)],x->[1]);

for n in [1..dim] do
Boundaries[n+1]:=[];
Orientation[n+1]:=[];
for i in [1..C!.dimension(n)] do
v:=StructuralCopy(Boundary(n,i));
bnd:=Concatenation([Length(v[1])+Length(v[2])],Flat(v));
Add(Boundaries[n+1],bnd);
Add(Orientation[n+1],
Concatenation(List([1..Length(v[1])],a->1),List([1..Length(v[2])],a->-1)));
od;

od;
Boundaries[dim+2]:=[];
##############################

### COBOUNDARIES BEGIN ######################
Coboundaries:=[];; #Coboundaries[n+1] contains the info on n-cells.
for n in [0..dim] do
  k:=2*(n+1)+1;#k:=1+2^(n+1);
  Coboundaries[n+1]:=List(Boundaries[n+1],i->[0]);
  for j in [1..Length(Boundaries[n+2])] do
    b:=Boundaries[n+2][j];
    #k:=Length(b);
    for i in b{[2..k]} do
      Coboundaries[n+1][i][1]:=Coboundaries[n+1][i][1]+1;
      Add(Coboundaries[n+1][i],j);
    od;
  od;
#  for b in Coboundaries[n+1] do
#  Append(b,List([1..Length(b)-1],a->1));
#  od;
od;
Coboundaries[dim+1]:=List(Boundaries[dim+1],a->[0]);
### COBOUNDARIES END ###############################


return Objectify(HapRegularCWComplex,
       rec(
           nrCells:=Dimension,
           boundaries:=Boundaries,
           coboundaries:=Coboundaries,
           vectorField:=fail,
           inverseVectorField:=fail,
           criticalCells:=fail,
           orientation:=Orientation,
           properties:=Properties));


end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallGlobalFunction(ChainComplexOfRegularCWComplex,
function(Y)
local
	C, Dimension, Boundary, one, zero, n, dim, characteristic;


dim:=EvaluateProperty(Y,"dimension");
##########################
Dimension:=function(n);
if n<0 or n>dim then return 0; fi;
return Length(Y!.boundaries[n+1]);
end;
##########################


zero:=[];
for n in [1..dim+1] do
zero[n]:=List([1..Dimension(n-1)],i->0);
od;

if not IsBound(Y!.orientation) then
characteristic:=2;
one:=One(GF(2));
######################
Boundary:=function(n,k)
local b,i,j,B;

if n>dim then return [one]; fi;

b:=StructuralCopy(zero[n]);
B:=Y!.boundaries[n+1][k];

for i in [2..Length(B)] do
b[B[i]]:=1;
od;

return one*b;
end;
######################
else 
characteristic:=0;
######################
Boundary:=function(n,k)
local b,i,j,B,sn;

b:=StructuralCopy(zero[n]);
B:=Y!.boundaries[n+1][k];
sn:=Y!.orientation[n+1][k];

for i in [2..Length(B)] do
b[B[i]]:=sn[i-1];
od;

return b;
end;
######################
fi;

return
Objectify(HapChainComplex,
           rec(
           dimension:=Dimension,
           boundary:=Boundary,
           properties:=[
           ["length",dim],
           ["type","chainComplex"],
           ["characteristic",characteristic]]
           ));


end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallGlobalFunction(ChainComplexOfRegularCWComplexWithVectorField,
function(Y)
local
        basis, bool, bij,Dimension, Boundary, one, zero, b, n, dim, characteristic, DeformCell,DeformCellSgn, HomotopicalDeformCell, 
        HDCrec, DCSrec, AlgRed, HtpyRed;

#HAP_Sequence2Boundaries(Y);

#############################################
HtpyRed:=function(w)
local cnt, tog;

cnt:=1;
tog:=true;

while tog do
tog:=false;
while cnt<Length(w) do
if w[cnt]=-w[cnt+1] then
w[cnt]:=0; w[cnt+1]:=0;
cnt:=cnt+2; tog:=true;
else cnt:=cnt+1;
fi;
od;
w:=Filtered(w,i->not i=0);
od;
return w;
end;
#############################################

AlgRed:=AlgebraicReduction;

dim:=EvaluateProperty(Y,"dimension");

basis:=[];
bij:=[];
for n in [0..dim] do
basis[n+1]:=Filtered(CriticalCellsOfRegularCWComplex(Y),x->x[1]=n);
Apply(basis[n+1],x->x[2]);
bij[n+1]:=[];
for b in [1..Length(basis[n+1])] do
bij[n+1][basis[n+1][b]]:=b;
od;
od;

###############################
Dimension:=function(n);
if IsBound(basis[n+1]) then
return Length(basis[n+1]);
else
return 0; fi;
end;
###############################


zero:=[];
for n in [1..dim+1] do
zero[n]:=List([1..Dimension(n-1)],i->0);
od;


###############################
###############################
DeformCell:=function(n,k)
local x,f,bnd,def;            #This will return a list of n-cells 
                              #into which the k-th n-cell is deformed.

if [n,k] in Y!.criticalCells then
return [k];
fi;
if n>0 then
if IsBound(Y!.vectorField[n][k]) then return []; fi;
fi;
 
f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
def:=[];
for x in [2..Length(bnd)] do
if not bnd[x]=k then
Append(def,DeformCell(n,bnd[x]));
fi;
od;

return def;
end;
###############################
###############################

DCSrec:=List([1..dim+1],i->[]);;
###############################
###############################
DeformCellSgn:=function(n,kk)
local sgnn,x,f,k,sgnk,cnt,bnd,def,sn,tog,def1,def2;            
		        	#This will return a list of signed n-cells
                                #into which the k-th n-cell is deformed.

k:=AbsInt(kk);
sgnk:=SignInt(kk);
if [n,k] in Y!.criticalCells then
return [kk];
fi;

if n>0 then
if IsBound(Y!.vectorField[n][k]) then return []; fi;
fi;

if IsBound(DCSrec[n+1][k]) then
if sgnk=1 then return DCSrec[n+1][k];
else
#return -Reversed(DCSrec[n+1][k]);
return -DCSrec[n+1][k];
fi;
fi;



f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
sn:=Y!.orientation[n+2][f];

def:=[]; def1:=[];def2:=[];

for x in [2..Length(bnd)] do
if not bnd[x]=k then
Add(def1,sn[x-1]*bnd[x]);
else
sgnn:=sn[x-1];
break;
fi;
od;
cnt:=x+1;

for x in [cnt..Length(bnd)] do
Add(def2,sn[x-1]*bnd[x]);
od;

if sgnn=1 then 
#def:=-Concatenation(Reversed(def1),Reversed(def2));
def:=-Concatenation(def1,def2);
else
def:=Concatenation(def2,def1);
fi;

Apply(def,x->DeformCellSgn(n,x));


def:=Flat(def);
Apply(def,x->[x,0]);

def:=AlgRed(def);


Apply(def,x->x[1]);

DCSrec[n+1][k]:=def;

if sgnk=1 then return def;
else
#return -Reversed(def);
return -def;
fi;
end;
###############################
###############################

HDCrec:=List([1..dim+1],i->[]);;
###############################
###############################
HomotopicalDeformCell:=function(n,kk)
local sgnn,x,f,k,sgnk,cnt,bnd,def,sn,tog,def1,def2;
                                #This will return an ordered list of signed 
				#n-cells into which the k-th n-cell is 
				#deformed.

k:=AbsInt(kk);
sgnk:=SignInt(kk);
if [n,k] in Y!.criticalCells then
return [kk];
fi;

if n>0 then
if IsBound(Y!.vectorField[n][k]) then return []; fi;
fi;

if IsBound(HDCrec[n+1][k]) then
if sgnk=1 then return HDCrec[n+1][k];
else
return -Reversed(HDCrec[n+1][k]);
fi;
fi;

f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
sn:=Y!.orientation[n+2][f];

def:=[]; def1:=[];def2:=[];

for x in [2..Length(bnd)] do
if not bnd[x]=k then
Add(def1,sn[x-1]*bnd[x]);
else
sgnn:=sn[x-1];
break;
fi;
od;
cnt:=x+1;

for x in [cnt..Length(bnd)] do
Add(def2,sn[x-1]*bnd[x]);
od;

if sgnn=1 then
def:=-Concatenation(Reversed(def1),Reversed(def2));
else
def:=Concatenation(def2,def1);
fi;

Apply(def,x->HomotopicalDeformCell(n,x));


def:=Flat(def);
Apply(def,x->[x,0]);

def:=HtpyRed(def);


Apply(def,x->x[1]);

HDCrec[n+1][k]:=def;

if sgnk=1 then return def;
else
return -Reversed(def);
fi;
end;
###############################
###############################





if not IsBound(Y!.orientation) then
characteristic:=2;
one:=One(GF(2));
######################
Boundary:=function(n,k)
local b,i,j,B;

b:=StructuralCopy(zero[n]);
B:=Y!.boundaries[n+1][basis[n+1][k]];
B:=B{[2..Length(B)]};
Apply(B,x->DeformCell(n-1,x));
B:=Concatenation(B);
Apply(B,i->bij[n][i]);

for i in B do
b[i]:=b[i]+1;
od;

return one*b;
end;
######################
else
characteristic:=0;
######################
Boundary:=function(n,k)
local b,i,j,B,sn;

b:=StructuralCopy(zero[n]);
B:=Y!.boundaries[n+1][basis[n+1][k]];
B:=B{[2..Length(B)]};
sn:=Y!.orientation[n+1][basis[n+1][k]];
B:=List([1..Length(B)],i->sn[i]*B[i]);

Apply(B,x->DeformCellSgn(n-1,x));
B:=Concatenation(B);
Apply(B,i->SignInt(i)*bij[n][AbsInt(i)]);


for i in B do
#b[AbsInt(i)]:=b[AbsInt(i)]+SignInt(i)*sn[AbsInt(i)];
b[AbsInt(i)]:=b[AbsInt(i)]+SignInt(i);
od;

return b;
end;
######################
fi;

if IsBound(Y!.orientation) then DeformCell:=DeformCellSgn; fi;

return
Objectify(HapChainComplex,
           rec(
           dimension:=Dimension,
           boundary:=Boundary,
           deform:=DeformCell,
           homotopicalDeform:=HomotopicalDeformCell,
           basis:=basis,
           bij:=bij,
           properties:=[
           ["length",dim],
           ["type","chainComplex"],
           ["characteristic",characteristic]]
           ));


end);
##########################################################
##########################################################

##########################################################
##########################################################
InstallMethod( ChainComplex,
"for regular CW spaces, using discrete vector fields",
 [IsHapRegularCWComplex],
 function(Y)
 CriticalCellsOfRegularCWComplex(Y);
 return ChainComplexOfRegularCWComplexWithVectorField(Y);
 end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallMethod( SparseChainComplex,
"for regular CW spaces, using discrete vector fields",
 [IsHapRegularCWComplex],
 function(Y)
 CriticalCellsOfRegularCWComplex(Y);
 return SparseChainComplexOfRegularCWComplexWithVectorField(Y);
 end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallOtherMethod( Homology,
"Homology of a regular CW spaces, using discrete vector fields",
 [IsHapRegularCWComplex,IsInt],
 function(Y,n) local C, H, m, bool;
 if not IsBound(Y!.orientation) then
 Print("Can only compute the mod 2 homology as no orientation is available.\n");
 fi;
 m:=Minimum(n+1,Dimension(Y));
 bool:=Y!.vectorField=fail or Y!.criticalCells=fail;
 if bool then 
    if m=Dimension(Y) then CriticalCellsOfRegularCWComplex(Y); 
    else
    CocriticalCellsOfRegularCWComplex(Y,m); fi;
 fi;
 C:=ChainComplex(Y);
 H:=Homology(C,n);
 if m<Dimension(Y) and bool then 
 Y!.vectorField:=fail; 
 Y!.criticalCells:=fail; 
 Y!.properties:=Filtered(Y!.properties,x->not x[1]="codim");
 fi;
return H;
 end);
##########################################################
##########################################################

##########################################################
##########################################################
InstallGlobalFunction(SparseChainComplexOfRegularCWComplex,
function(Y)
local
        C, Dimension, Boundary, one,  n, dim, characteristic;

#Dimension:=Y!.nrCells;
##########################
Dimension:=function(n);
if n<0 then return 0; fi;
return Length(Y!.boundaries[n+1]);
end;
##########################

dim:=EvaluateProperty(Y,"dimension");


if not IsBound(Y!.orientation) then
characteristic:=2;
one:=One(GF(2));
######################
Boundary:=function(n,k)
local b,i,j,B;

b:=[];
B:=Y!.boundaries[n+1][k];

for i in [2..Length(B)] do
Add(b,[B[i],one]);
od;

return b;
end;
######################
else
characteristic:=0;
######################
Boundary:=function(n,k)
local b,i,j,B,sn;

b:=[];
B:=Y!.boundaries[n+1][k];
sn:=Y!.orientation[n+1][k];

for i in [2..Length(B)] do
Add(b,[B[i],sn[i-1]]);
od;

return b;
end;
######################
fi;

return
Objectify(HapSparseChainComplex,
           rec(
           dimension:=Dimension,
           boundary:=Boundary,
           properties:=[
           ["length",dim],
           ["type","chainComplex"],
           ["characteristic",characteristic]]
           ));


end);
##########################################################
##########################################################


##########################################################
##########################################################
InstallGlobalFunction(SparseChainComplexOfRegularCWComplexWithVectorField,
function(Y)
local
        basis, bij,Dimension, Boundary, one, zero, b, n, dim, characteristic, DeformCell,DeformCellSgn;

dim:=EvaluateProperty(Y,"dimension");

basis:=[];
bij:=[];
for n in [0..dim] do
basis[n+1]:=Filtered(CriticalCellsOfRegularCWComplex(Y),x->x[1]=n);
Apply(basis[n+1],x->x[2]);
bij[n+1]:=[];
for b in [1..Length(basis[n+1])] do
bij[n+1][basis[n+1][b]]:=b;
od;
od;

###############################
Dimension:=function(n);
return Length(basis[n+1]);
end;
###############################


zero:=[];
for n in [1..dim+1] do
zero[n]:=List([1..Dimension(n-1)],i->0);
od;


###############################
###############################
DeformCell:=function(n,k)
local x,f,bnd,def;            #This will return a list of n-cells
                              #into which the k-th n-cell is deformed.

if [n,k] in Y!.criticalCells then
return [k];
fi;
if n>0 then
if IsBound(Y!.vectorField[n][k]) then return []; fi;
fi;

f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
def:=[];
for x in [2..Length(bnd)] do
if not bnd[x]=k then
Append(def,DeformCell(n,bnd[x]));
fi;
od;

return def;
end;
###############################
###############################

###############################
###############################
DeformCellSgn:=function(n,kk)
local sgnn,x,f,k,sgnk,cnt,bnd,def,sn,tog,def1,def2;
                                #This will return a list of signed n-cells
                                #into which the k-th n-cell is deformed.

k:=AbsInt(kk);
sgnk:=SignInt(kk);
if [n,k] in Y!.criticalCells then
return [kk];
fi;

if n>0 then
if IsBound(Y!.vectorField[n][k]) then return []; fi;
fi;

f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
sn:=Y!.orientation[n+2][f];

def:=[]; def1:=[];def2:=[];

for x in [2..Length(bnd)] do
if not bnd[x]=k then
Add(def1,sn[x-1]*bnd[x]);
else
sgnn:=sn[x-1];
break;
fi;
od;
cnt:=x+1;

for x in [cnt..Length(bnd)] do
Add(def2,sn[x-1]*bnd[x]);
od;

if sgnn=1 then
def:=-Concatenation(Reversed(def1),Reversed(def2));
else
def:=Concatenation(def2,def1);
fi;

Apply(def,x->DeformCellSgn(n,x));

if sgnk=1 then return Flat(def);
else
return -Reversed(Flat(def));
fi;
end;
###############################
###############################


if not IsBound(Y!.orientation) then
characteristic:=2;
one:=One(GF(2));
######################
Boundary:=function(n,k)
local b,i,j,B;

b:=[];
B:=Y!.boundaries[n+1][basis[n+1][k]];
B:=B{[2..Length(B)]};
Apply(B,x->DeformCell(n-1,x));
B:=Concatenation(B);
Apply(B,i->bij[n][i]);

for i in B do
Add(b,[i,one]);
#b[i]:=b[i]+1;
od;

b:=SortedList(b);
for i in [1..Length(b)-1] do
if b[i][1]=b[i+1][1] then
b[i+1][2]:=b[i+1][2]+b[i][2];
b[i][2]:=0;
fi;
od;
b:=Filtered(b,x->not IsZero(x[2]));

return b;
end;
######################
else
characteristic:=0;
######################
Boundary:=function(n,k)
local b,i,j,B,sn;

b:=[];
B:=Y!.boundaries[n+1][basis[n+1][k]];
B:=B{[2..Length(B)]};
sn:=Y!.orientation[n+1][basis[n+1][k]];
B:=List([1..Length(B)],i->sn[i]*B[i]);

Apply(B,x->DeformCellSgn(n-1,x));
B:=Concatenation(B);
Apply(B,i->SignInt(i)*bij[n][AbsInt(i)]);



for i in B do
#b[AbsInt(i)]:=b[AbsInt(i)]+SignInt(i);
Add(b,[AbsInt(i),SignInt(i)]);
od;

b:=SortedList(b);
for i in [1..Length(b)-1] do
if b[i][1]=b[i+1][1] then 
b[i+1][2]:=b[i+1][2]+b[i][2];
b[i][2]:=0;
fi;
od;
b:=Filtered(b,x->not IsZero(x[2]));

return b;
end;
######################
fi;

if IsBound(Y!.orientation) then DeformCell:=DeformCellSgn; fi;
return
Objectify(HapSparseChainComplex,
           rec(
           dimension:=Dimension,
           boundary:=Boundary,
           deform:=DeformCell,
           basis:=basis,
           bij:=bij,
           properties:=[
           ["length",dim],
           ["type","chainComplex"],
           ["characteristic",characteristic]]
           ));


end);
##########################################################
##########################################################


#######################################################
#######################################################
InstallGlobalFunction(RegularCWComplex,
function(arg)
local bnd, Y, dim, Coboundaries, k, i, j, n, b;

bnd:=arg[1];
Y:=Objectify(HapRegularCWComplex, rec());
dim:=PositionProperty(bnd,IsEmpty)-2;
Y!.properties:=[["dimension",dim]];


### COBOUNDARIES BEGIN ######################
Coboundaries:=[];; #Coboundaries[n+1] contains the info on n-cells.
for n in [0..dim] do
  #k:=2*(n+1)+1;#k:=1+2^(n+1);
  Coboundaries[n+1]:=List(bnd[n+1],i->[0]);
  for j in [1..Length(bnd[n+2])] do
    b:=bnd[n+2][j];
    k:=Length(b);
    for i in b{[2..k]} do
      Coboundaries[n+1][i][1]:=Coboundaries[n+1][i][1]+1;
      Add(Coboundaries[n+1][i],j);
    od;
  od;
od;
Coboundaries[dim+1]:=List(bnd[dim+1],a->[0]);
### COBOUNDARIES END ###############################


Y!.boundaries:=bnd;
Y!.coboundaries:=Coboundaries;
Y!.vectorField:=fail;
Y!.inverseVectorField:=fail;
Y!.criticalCells:=fail;
if Length(arg)=2 then Y!.orientation:=arg[2]; fi;

####################
Y!.nrCells:=function(n);
if n>dim then return 0; fi;
return Length(Filtered(Y!.boundaries[n+1],x->not x[1]=0));
end;
####################

return Y;
end);
#######################################################
#######################################################

#######################################################
#######################################################
InstallGlobalFunction(ContractedRegularCWComplex,
function(W)
local Y, perm, d, d1, n, x, i, b, cnt, bnd,  dim , F, bool, orien;

if IsBound(W!.orientation) then
Y:=RegularCWComplex(W!.boundaries,W!.orientation);
else
Y:=RegularCWComplex(W!.boundaries);
fi;

if IsBound(Y!.orientation) then bool:=true;
orien:=StructuralCopy(Y!.orientation);
else bool:=false; fi;

HAPContractRegularCWComplex(Y);

bnd:=StructuralCopy(Y!.bnd);

perm:=[];  ##perm[d][i] will be the new position of
           ##the old i-th cell of dimension d;

for d in [1..Length(bnd)] do
perm[d]:=[];
cnt:=0;
for n in [1..Length(bnd[d])] do
if bnd[d][n][1]=0 then cnt:=cnt+1;
else
perm[d][n]:=n-cnt;
fi;
od;
od;

for d in [1..Length(bnd)] do
F:=Filtered([1..Length(bnd[d])],i->not bnd[d][i][1]=0);
#bnd[d]:=Filtered(bnd[d],x->not x[1]=0);
bnd[d]:=bnd[d]{F};
if bool and IsBound(orien[d]) then orien[d]:=orien[d]{F}; fi;
if d>1 then
d1:=d-1;
for x in bnd[d] do
for i in [2..Length(x)] do
x[i]:=perm[d1][x[i]];
od;
od;
fi;
od;

if bool then return RegularCWComplex(bnd, orien);
else return RegularCWComplex(bnd);fi;
end);
#######################################################
#######################################################

#######################################################
#######################################################
InstallGlobalFunction(SimplifiedRegularCWComplex,
function(Y)
local W , a, b, OnceSimplifiedRegularCWComplex;


#######################################################
#######################################################
OnceSimplifiedRegularCWComplex:=function(W)
local Y, perm, cnt, JoinCells, d, d1, n, x, i, b,  cobnd, bnd,  dim , F, bool, orien,  pos;

if IsBound(W!.orientation) then
Y:=RegularCWComplex(StructuralCopy(W!.boundaries),StructuralCopy(W!.orientation));
else
Y:=RegularCWComplex(StructuralCopy(W!.boundaries));
fi;

if IsBound(Y!.orientation) then bool:=true;
orien:=StructuralCopy(Y!.orientation);
else bool:=false; fi;

bnd:=Y!.boundaries;
cobnd:=Y!.coboundaries;


###################################################
###################################################
JoinCells:=function(d1,n)
                                 #The n-th cell in dimension d=d1-1 is removed
                                 #assuming it has a coboundary of size 2.
local cob, d, a, b, d2,d3, m, s, t, pos, poss ;

d2:=d1+1;
d3:=d2+1;
cob:=cobnd[d1][n];
s:=bnd[d2][cob[2]];
s:=s{[2..Length(s)]};
t:=bnd[d2][cob[3]];

t:=t{[2..Length(t)]};
if not Intersection(s,t)=[n] then return false; fi;

if d1>1 then
d:=d1-1;
for m in bnd[d1][n]{[2..Length(bnd[d1][n])]} do
s:=cobnd[d][m][1]-1;  t:=cobnd[d][m]{[2..Length(cobnd[d][m])]};
poss:=Position(t,n);

if poss=fail then return false; fi; #THIS WORRIES ME. I SHOULD NOT NEED THIS LINE!

Remove(t,poss);
cobnd[d][m]:=Concatenation([s],t);
od;

fi;

bnd[d1][n]:=[0];
cobnd[d1][n]:=[0];

s:=bnd[d2][cob[2]];

s:=s{[2..Length(s)]};
pos:=Position(s,n);
Remove(s,pos);
if bool then a:=orien[d2][cob[2]][pos]; Remove(orien[d2][cob[2]],pos); fi;

t:=bnd[d2][cob[3]];

t:=t{[2..Length(t)]};
pos:=Position(t,n);
Remove(t,pos);
if bool then b:=orien[d2][cob[3]][pos]; Remove(orien[d2][cob[3]],pos); fi;

bnd[d2][cob[2]]:=Concatenation([Length(s)+Length(t)],s,t);
if bool then orien[d2][cob[2]]:=Concatenation(orien[d2][cob[2]],-a*b*orien[d2][cob[3]]); fi;
bnd[d2][cob[3]]:=[0];

for m in cobnd[d2][cob[3]]{[2..Length(cobnd[d2][cob[3]])]} do
s:=bnd[d3][m][1]-1;
t:=bnd[d3][m]{[2..Length(bnd[d3][m])]};
if Position(t,cob[2])=fail then Print("HEY!\n"); fi;
pos:=Position(t,cob[3]);
Remove(t,pos);
bnd[d3][m]:=Concatenation([s],t);
if bool then Remove(orien[d3][m],pos); fi;
od;
cobnd[d2][cob[3]]:=[0];
end;
###################################################
###################################################

###################################################
######SIMPLIFICATION STARTS########################

for d in [0..Dimension(Y)-1] do
d1:=d+1;
for n in [1..Length(bnd[d1])] do
if cobnd[d1][n][1] =2 and bnd[d1][n][1]>0 then JoinCells(d1,n);  fi;
od;
od;


######SIMPLIFICATION DONE##########################
###################################################

perm:=[];  ##perm[d][i] will be the new position of
           ##the old i-th cell of dimension d;

for d in [1..Length(bnd)] do
perm[d]:=[];
cnt:=0;
for n in [1..Length(bnd[d])] do
if bnd[d][n][1]=0 then cnt:=cnt+1;
else
perm[d][n]:=n-cnt;
fi;
od;
od;

for d in [1..Length(bnd)] do
F:=Filtered([1..Length(bnd[d])],i->not bnd[d][i][1]=0);
bnd[d]:=bnd[d]{F};
if bool and IsBound(orien[d]) then orien[d]:=orien[d]{F}; fi;

if d>1 then
d1:=d-1;
for x in bnd[d] do
for i in [2..Length(x)] do
x[i]:=StructuralCopy(perm[d1][x[i]]);
od;
od;
fi;
od;

if bool then return RegularCWComplex(bnd, orien);
else
return RegularCWComplex(bnd);
fi;
end;
#######################################################
#######################################################


W:=OnceSimplifiedRegularCWComplex(Y);

a:=Size(Y);
b:=Size(W);

while a>b do
W:=OnceSimplifiedRegularCWComplex(W);
a:=b;
b:=Size(W);
od;

return W;
end);
#######################################################
#######################################################


#####################################################
#####################################################
InstallGlobalFunction(IsPureRegularCWComplex,
function(Y)
local n, x, dim, bool;

dim:=Dimension(Y);
bool:=true;

for n in [1..dim] do
if not bool then break; fi;
for x in Y!.coboundaries[n] do
if x[1]=0 then bool:=false; break; fi;
od;
od;

return bool;
end);
#####################################################
#####################################################

#####################################################
#####################################################
InstallGlobalFunction(BoundaryOfPureRegularCWComplex,
function(Y)
local F, n, m, d, t, i, x, bool, perm, cnt, d1,  dim, bnd, cobnd, orien, B;

if not IsPureRegularCWComplex(Y) then return fail; fi;


dim:=Dimension(Y);

bnd:=Y!.boundaries*1;
cobnd:=Y!.coboundaries*1;
if IsBound(Y!.orientation) then
orien:=Y!.orientation*1; bool:=true;
else bool:=false;
fi;

bnd[dim+1]:=[];

d:=dim;
  for n in [1..Length(bnd[d])] do
    if cobnd[d][n][1]>1 then
      if d>1 then
        t:=bnd[d][n];
        for m in t{[2..Length(t)]} do
          cobnd[d-1][m][1]:=cobnd[d-1][m][1]-1;
        od;
      fi;
      bnd[d][n]:=[0];
    fi;
  od;


for d in Reversed([1..dim-1]) do
  for n in [1..Length(bnd[d])] do
    if cobnd[d][n][1]=0 then
      if d>1 then
        t:=bnd[d][n];
        for m in t{[2..Length(t)]} do
          cobnd[d-1][m][1]:=cobnd[d-1][m][1]-1;
        od;
      fi;
      bnd[d][n]:=[0];
    fi;
  od;
od;


perm:=[];  ##perm[d][i] will be the new position of
           ##the old i-th cell of dimension d;

for d in [1..Length(bnd)] do
perm[d]:=[];
cnt:=0;
for n in [1..Length(bnd[d])] do
if bnd[d][n][1]=0 then cnt:=cnt+1;
else
perm[d][n]:=n-cnt;
fi;
od;
od;

for d in [1..Length(bnd)] do
F:=Filtered([1..Length(bnd[d])],i->not bnd[d][i][1]=0);
#bnd[d]:=Filtered(bnd[d],x->not x[1]=0);
bnd[d]:=bnd[d]{F};
if bool and IsBound(orien[d]) then orien[d]:=orien[d]{F}; fi;
if d>1 then
d1:=d-1;
for x in bnd[d] do
for i in [2..Length(x)] do
x[i]:=perm[d1][x[i]];
od;
od;
fi;
od;


if IsBound(orien) then
B:=RegularCWComplex(bnd,orien);
B!.perm:=perm;
return B;
else
B:=RegularCWComplex(bnd);
B!.perm:=perm;
return B;
fi;

end);
#####################################################
#####################################################

##################################################
##################################################
InstallGlobalFunction(OrientRegularCWComplex,
function(Y)
local bnd, cobnd, orien, dim, d, d1, d2, x, i, j, b, bb, sn, m, S, T, s, t, 
       L, bool ;

#Print("Function not yet implemented.\n\n");
#return fail;

dim:=Dimension(Y);
bnd:=Y!.boundaries;
cobnd:=Y!.coboundaries;
orien:=bnd*0;
for x in orien do
Apply(x,y->y{[2..Length(y)]});
od;

Apply(orien[1], x->x+1);
Apply(orien[2],x->[1,-1]);


#######################
for d in [3..dim+1] do
  d1:=d-1;
  d2:=d-2;
  for i in [1..Length(bnd[d])] do
    b:=bnd[d][i]{[2..Length(bnd[d][i])]};
    bb:=[];
    for j in [1..Length(b)] do
      Add(bb, bnd[d1][b[j]]{[2..Length(bnd[d1][b[j]])]}   );
    od;
    orien[d][i][1]:=1;
    S:=[1..Length(b)];
    T:=[1..Length(b)];
    for s in [2..Length(b)] do
    Unbind(S[s]);
    od;
    Unbind(T[1]);

    while 0 in orien[d][i] do
    ###############################
    bool:=false;
    for s in S do
    for t in T do
      L:=Intersection(bb[s], bb[t]);
      if Length(L)>0 then
        S[t]:=t;
        Unbind(T[t]);   
        bool:=true;
        if orien[d][i][s]*orien[d1][b[s]][Position(bb[s],L[1])]=
           orien[d1][b[t]][Position(bb[t],L[1])]
           then orien[d][i][t]:=-1;
           else
           orien[d][i][t]:=1;
        fi; 
        break;
      fi;
    od;
    od;
    ###############################
    od;
  od;
od;
#######################


Y!.orientation:=orien;
end);
##################################################
##################################################

#############################################
#############################################
InstallGlobalFunction(HAP_Sequence2Boundaries,
function(Y)

local orien, b, i, bb, newb, neworien, pos, s, t;

for i in [1..Y!.nrCells(2)] do
  b:=Y!.boundaries[3][i];
  orien:=Y!.orientation[3][i];
  bb:=List(b{[2..Length(b)]},  j->Y!.boundaries[2][j]{[2,3]});

  s:=bb[1];
  Unbind(bb[1]);
  newb:=[b[1],b[2]];
  neworien:=[orien[1]];
  while Length(newb)<Length(b) do
    for t in bb do
      if Length(Intersection(s,t))>0 then pos:=Position(bb,t); break; fi;
    od;
    s:=bb[pos];
    Unbind(bb[pos]);
    Add(newb,b[pos+1]);
    Add(neworien,orien[pos]);
  od;
  Y!.boundaries[3][i]:=newb;
  Y!.orientation[3][i]:=neworien;


od;
end);
#############################################
#############################################

