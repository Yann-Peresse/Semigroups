#############################################################################
##
#W  reesmat.tst
#Y  Copyright (C) 2011-13                               James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

gap> START_TEST("Semigroups package: reesmat.tst");
gap> LoadPackage( "semigroups", false );;

# Set info levels and user preferences
gap> SemigroupsStartTest();

# find a source of interesting subsemigroups of Rees 0-matrix semigroups...
gap> S:=Semigroup( 
>  Transformation( [ 1, 1, 2, 7, 9, 8, 5, 9, 6 ] ), 
>  Transformation( [ 1, 1, 7, 2, 8, 9, 9, 5, 6 ] ), 
>  Transformation( [ 1, 2, 2, 3, 6, 5, 5, 7 ] ), 
>  Transformation( [ 1, 2, 2, 3, 6, 9, 9, 7, 5 ] ), 
>  Transformation( [ 1, 2, 2, 3, 7, 5, 5, 7 ] ), 
>  Transformation( [ 1, 2, 2, 3, 7, 9, 9, 7, 5 ] ), 
>  Transformation( [ 1, 2, 3, 1 ] ), Transformation( [ 1, 2, 3, 3 ] ), 
>  Transformation( [ 1, 2, 3, 6, 5, 6 ] ), 
>  Transformation( [ 1, 2, 3, 9, 5, 6, 7, 8, 9 ] ), 
>  Transformation( [ 1, 2, 7, 8, 9, 5, 5, 9, 6 ] ), 
>  Transformation( [ 1, 2, 8, 2, 7, 9, 9, 6, 5 ] ), 
>  Transformation( [ 1, 2, 8, 2, 9, 7, 6, 9, 5 ] ), 
>  Transformation( [ 2, 1, 1, 3, 6, 5, 5, 7 ] ), 
>  Transformation( [ 2, 1, 1, 3, 6, 9, 9, 7, 5 ] ), 
>  Transformation( [ 2, 1, 1, 3, 7, 5, 5, 7 ] ), 
>  Transformation( [ 2, 1, 1, 3, 7, 9, 9, 7, 5 ] ), 
>  Transformation( [ 2, 1, 1, 6, 9, 7, 6, 9, 5 ] ), 
>  Transformation( [ 2, 1, 1, 8, 9, 6, 7, 9, 5 ] ), 
>  Transformation( [ 2, 1, 1, 8, 9, 7, 6, 9, 5 ] ), 
>  Transformation( [ 2, 1, 8, 1, 7, 9, 9, 6, 5 ] ), 
>  Transformation( [ 2, 1, 8, 6, 9, 7, 6, 9, 5 ] ), 
>  Transformation( [ 5, 5, 8, 1, 7, 2, 1, 6 ] ), 
>  Transformation( [ 5, 8, 2, 3, 6, 9, 9, 7, 1 ] ), 
>  Transformation( [ 5, 8, 7, 2, 9, 1, 1, 9, 6 ] ), 
>  Transformation( [ 6, 6, 9, 4, 8, 1, 1, 8, 9 ] ), 
>  Transformation( [ 6, 7, 1, 8, 9, 5, 5, 9, 2 ] ), 
>  Transformation( [ 6, 7, 6, 4, 5, 1, 2 ] ), 
>  Transformation( [ 6, 7, 7, 8, 9, 1, 2, 9, 5 ] ), 
>  Transformation( [ 6, 7, 7, 8, 9, 2, 1, 9, 5 ] ), 
>  Transformation( [ 6, 7, 8, 1, 9, 2, 1, 9, 5 ] ), 
>  Transformation( [ 6, 7, 9, 4, 5, 1, 2, 8, 9 ] ), 
>  Transformation( [ 7, 6, 8, 2, 9, 1, 1, 9, 5 ] ), 
>  Transformation( [ 7, 6, 8, 6, 9, 2, 1, 9, 5 ] ), 
>  Transformation( [ 8, 5, 2, 7, 9, 6, 6, 9, 1 ] ), 
>  Transformation( [ 9, 9, 2, 7, 8, 6, 6, 5, 1 ] ), 
>  Transformation( [ 9, 9, 3, 2, 6, 5, 8, 7, 1 ] ), 
>  Transformation( [ 9, 9, 3, 4, 5, 6, 7, 8, 1 ] ), 
>  Transformation( [ 9, 9, 8, 7, 2, 6, 6, 1, 5 ] ) );;
gap> R:=PrincipalFactor(DClasses(S)[40]);
<Rees 0-matrix semigroup 26x5 over Group([ (5,8)(6,9), (1,6,9), (1,6) ])>
gap> U:=MaximalSubsemigroups(R){[31..36]};
[ <subsemigroup of 26x5 Rees 0-matrix semigroup with 128 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 148 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 140 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 132 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 124 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 144 generators> ]
gap> V:=Semigroup(MultiplicativeZero(U[3]), 
> RMSElement(U[3], 13, (1,6)(5,8),3),
> RMSElement(U[3], 1,(1,6),3), 
> RMSElement(U[3], 7,(1,6)(5,8),3), 
> RMSElement(U[3], 23,(5,8),2), 
> RMSElement(U[3], 22,(1,6),1), 
> RMSElement(U[3],11,(1,9),5), 
> RMSElement(U[3],2,(1,6),5), 
> RMSElement(U[3],24,(1,6)(5,8),4), 
> RMSElement(U[3],6,(1,9)(5,8),1), 
> RMSElement(U[3],15,(1,9)(5,8),2), 
> RMSElement(U[3],22,(1,9),1));;

# from attributes.xml...

# StuctureDescriptionMaximalSubgroups
gap> StructureDescriptionMaximalSubgroups(U[1]);
[ "1", "D12" ]
gap> StructureDescriptionMaximalSubgroups(V);
[ "1", "D12" ]

# StructureDescriptionSchutzenbergerGroups 
gap> StructureDescriptionSchutzenbergerGroups(U[5]);
[ "1", "D12" ]

# MinimalDClass
gap> List(U, MinimalDClass);
[ {0}, {0}, {0}, {0}, {0}, {0} ]
gap> MinimalDClass(V);
{0}

# MaximalDClasses
gap> MaximalDClasses(V);
[ {(13,(1,6)(5,8),3)}, {(22,(1,6),1)} ]
gap> MaximalDClasses(U[4]);
[ {(2,(),4)}, {(1,(5,8)(6,9),1)} ]

# PrincipalFactor
gap> D:=Filtered(DClasses(V), IsRegularClass)[2];
{(13,(1,6)(5,8),3)}
gap> inj:=InjectionPrincipalFactor(D);; inv:=InverseGeneralMapping(inj);;
gap> ForAll(D, x-> (x^inj)^inv=x);                                         
true
gap> ForAll(D, x-> ForAll(D, y-> (not x*y in D) or (x*y)^inj=x^inj*y^inj));
true

# SmallGeneratingSet
gap> Length(SmallGeneratingSet(V))<Length(Generators(V));
true
gap> Apply(U, x-> Semigroup(SmallGeneratingSet(x)));

#MinimalIdeal
gap> MinimalIdeal(V);
<subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>
gap> List(U, MinimalIdeal);
[ <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 1 generator> ]

#IsomorphismPermGroup
gap> R:=ReesZeroMatrixSemigroup(QuaternionGroup(IsPermGroup, 8), [[()]]);;
gap> T:=Semigroup(Filtered(Generators(R), x-> x![1]<>0));;
gap> iso:=IsomorphismPermGroup(T);              
MappingByFunction( <subsemigroup of 1x1 Rees 0-matrix semigroup 
 with 2 generators>, Group([ (1,5,3,7)(2,8,4,6), (1,2,3,4)
(5,6,7,8) ]), function( x ) ... end, function( x ) ... end )
gap> inv:=InverseGeneralMapping(iso);
MappingByFunction( Group([ (1,5,3,7)(2,8,4,6), (1,2,3,4)
(5,6,7,8) ]), <subsemigroup of 1x1 Rees 0-matrix semigroup with 2 generators>
 , function( x ) ... end, function( x ) ... end )
gap> ForAll(T, x-> (x^iso)^inv=x);
true
gap> ForAll(T, x-> ForAll(T, y-> (x*y)^iso=x^iso*y^iso));                   
true
gap> iso:=IsomorphismPermGroup(MinimalIdeal(V));
MappingByFunction( <subsemigroup of 26x5 Rees 0-matrix semigroup 
 with 1 generator>, Group(()), function( x ) ... end, function( x ) ... end )
gap> inv:=InverseGeneralMapping(iso);
MappingByFunction( Group(()), <subsemigroup of 26x5 Rees 0-matrix semigroup 
 with 1 generator>, function( x ) ... end, function( x ) ... end )
gap> ForAll(MinimalIdeal(V), x-> (x^iso)^inv=x);         
true
gap> ForAll(MinimalIdeal(V), x-> ForAll(MinimalIdeal(V), y-> 
> (x*y)^iso=x^iso*y^iso));
true

#GroupOfUnits
gap> R:=Semigroup(Generators(R));
<subsemigroup of 1x1 Rees 0-matrix semigroup with 3 generators>
gap> GroupOfUnits(R);
<subsemigroup of 1x1 Rees 0-matrix semigroup with 2 generators>
gap> GroupOfUnits(V);
fail
gap> GroupOfUnits(U[5]);
fail

#IdempotentGeneratedSubsemigroup
gap> eV:=IdempotentGeneratedSubsemigroup(V);
<subsemigroup of 26x5 Rees 0-matrix semigroup with 9 generators>
gap> Size(eV);
15
gap> Size(V);
505
gap> List(U, IdempotentGeneratedSubsemigroup);
[ <subsemigroup of 26x5 Rees 0-matrix semigroup with 27 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 26 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 26 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 27 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 26 generators>, 
  <subsemigroup of 26x5 Rees 0-matrix semigroup with 27 generators> ]
gap> List(last, Size);
[ 47, 47, 47, 47, 47, 47 ]
gap> last2[1]=last2[2];
true

#IrredundantGeneratingSubset
gap> IrredundantGeneratingSubset(V);
[ (1,(1,6),3), (2,(1,6),5), (6,(1,9)(5,8),1), (7,(1,6)(5,8),3), (11,(1,9),5), 
  (13,(1,6)(5,8),3), (15,(1,9)(5,8),2), (22,(1,6),1), (23,(5,8),2), 
  (24,(1,6)(5,8),4) ]
gap> Length(last);
10
gap> IrredundantGeneratingSubset(U[1]);
[ (1,(1,6),1), (2,(),5), (3,(),5), (4,(),1), (5,(),4), (6,(),1), (7,(1,6),2), 
  (8,(),3), (9,(),3), (10,(),1), (10,(),2), (11,(),3), (12,(),2), (13,(),3), 
  (14,(),1), (15,(),1), (16,(),3), (17,(),1), (18,(),2), (19,(),3), 
  (20,(),3), (21,(),2), (22,(),4), (23,(),4), (24,(),5), (25,(),5), (26,(),3) 
 ]
gap> Length(last);
27

# from greens.xml...

# MultiplicativeNeutralElement (for an H-class)
gap> H:=First(HClasses(V), IsRegularClass);
{0}
gap> MultiplicativeNeutralElement(H);
0
gap> H:=First(HClasses(V), x-> not IsRegularClass(x));
{(23,(6,9),3)}
gap> MultiplicativeNeutralElement(H);
fail
gap> H:=First(HClasses(U[5]), IsRegularClass);
{(3,(),4)}
gap> e:=MultiplicativeNeutralElement(H);
(3,(5,8)(6,9),4)
gap> e^2;
(3,(5,8)(6,9),4)
gap> ForAll(H, x-> x*e=x and e*x=x);
true
gap> H:=First(HClasses(U[5]), x-> not IsRegularClass(x));
{(3,(),1)}
gap> MultiplicativeNeutralElement(H);
fail

# StructureDescription (for an H-class) 
gap> H:=First(HClasses(U[5]), IsRegularClass);;
gap> StructureDescription(H);
"D12"

# Random
gap> Random(V);;
gap> List(U, Random);;
gap> ForAll([1..5], x-> last[x] in U[x]);
true

# DClassOf.Class etc
gap> H:=First(HClasses(V), x-> not IsRegularClass(x));
{(23,(6,9),3)}
gap> DClass(H);
{(13,(5,8)(6,9),3)}
gap> RClass(H);
{(23,(6,9),3)}
gap> LClass(H);
{(13,(5,8)(6,9),3)}
gap> LClass(H)<LClass(V, Representative(V));
false

# DClasses etc...
gap> RClasses(V);
[ {0}, {(13,(1,6)(5,8),3)}, {(1,(1,6),3)}, {(7,(1,6)(5,8),3)}, 
  {(23,(6,9),3)}, {(22,(1,6),1)}, {(11,(1,6),3)}, {(2,(6,9),3)}, 
  {(24,(5,8)(6,9),3)}, {(6,(1,9)(5,8),1)}, {(15,(1,6,9),3)}, {(22,(),3)}, 
  {(6,(1,9,6)(5,8),3)} ]
gap> LClasses(V);
[ {0}, {(13,(1,6)(5,8),3)}, {(13,(),2)}, {(13,(1,9,6)(5,8),5)}, 
  {(13,(1,9,6)(5,8),4)}, {(1,(1,6),3)}, {(1,(5,8),2)}, {(1,(1,9,6),5)}, 
  {(1,(1,9,6),4)}, {(1,(5,8),3)}, {(1,(1,6),2)}, {(1,(5,8)(6,9),5)}, 
  {(1,(5,8)(6,9),4)}, {(1,(5,8)(6,9),3)}, {(1,(1,6,9),2)}, {(1,(5,8),5)}, 
  {(1,(5,8),4)}, {(1,(1,9,6)(5,8),3)}, {(1,(1,9),2)}, {(1,(1,6)(5,8),5)}, 
  {(1,(1,6)(5,8),4)}, {(1,(1,9),3)}, {(1,(1,9,6)(5,8),2)}, {(1,(1,6,9),5)}, 
  {(1,(1,6,9),4)}, {(1,(1,6,9),3)}, {(1,(5,8)(6,9),2)}, {(1,(1,9),5)}, 
  {(1,(1,9),4)}, {(1,(1,9,6),3)}, {(1,(1,9)(5,8),2)}, {(1,(1,6),5)}, 
  {(1,(1,6),4)}, {(1,(1,9)(5,8),3)}, {(1,(1,9,6),2)}, {(1,(1,6,9)(5,8),5)}, 
  {(1,(1,6,9)(5,8),4)}, {(1,(1,6,9)(5,8),3)}, {(1,(6,9),2)}, 
  {(1,(1,9)(5,8),5)}, {(1,(1,9)(5,8),4)}, {(1,(1,6)(5,8),3)}, {(1,(),2)}, 
  {(1,(1,9,6)(5,8),5)}, {(1,(1,9,6)(5,8),4)}, {(1,(),3)}, {(1,(1,6)(5,8),2)}, 
  {(1,(6,9),5)}, {(1,(6,9),4)}, {(1,(6,9),3)}, {(1,(1,6,9)(5,8),2)}, 
  {(1,(),5)}, {(1,(),4)}, {(22,(1,6),1)}, {(15,(1,6,9),3)}, 
  {(15,(5,8)(6,9),2)}, {(15,(1,9),5)}, {(15,(1,9),4)}, {(15,(5,8)(6,9),3)}, 
  {(15,(1,6,9),2)}, {(15,(5,8),5)}, {(15,(5,8),4)}, {(15,(5,8),3)}, 
  {(15,(1,6),2)}, {(15,(5,8)(6,9),5)}, {(15,(5,8)(6,9),4)}, 
  {(15,(1,9)(5,8),3)}, {(15,(1,9,6),2)}, {(15,(1,6,9)(5,8),5)}, 
  {(15,(1,6,9)(5,8),4)}, {(15,(1,9,6),3)}, {(15,(1,9)(5,8),2)}, 
  {(15,(1,6),5)}, {(15,(1,6),4)}, {(15,(1,6),3)}, {(15,(5,8),2)}, 
  {(15,(1,9,6),5)}, {(15,(1,9,6),4)}, {(15,(1,9),3)}, {(15,(1,9,6)(5,8),2)}, 
  {(15,(1,6,9),5)}, {(15,(1,6,9),4)}, {(15,(1,9,6)(5,8),3)}, {(15,(1,9),2)}, 
  {(15,(1,6)(5,8),5)}, {(15,(1,6)(5,8),4)}, {(15,(1,6)(5,8),3)}, {(15,(),2)}, 
  {(15,(1,9,6)(5,8),5)}, {(15,(1,9,6)(5,8),4)}, {(15,(1,6,9)(5,8),3)}, 
  {(15,(6,9),2)}, {(15,(1,9)(5,8),5)}, {(15,(1,9)(5,8),4)}, {(15,(6,9),3)}, 
  {(15,(1,6,9)(5,8),2)}, {(15,(),5)}, {(15,(),4)}, {(15,(),3)}, 
  {(15,(1,6)(5,8),2)}, {(15,(6,9),5)}, {(15,(6,9),4)}, {(22,(),3)}, 
  {(22,(1,6)(5,8),2)}, {(22,(6,9),5)}, {(22,(6,9),4)} ]
gap> DClasses(V);
[ {0}, {(13,(1,6)(5,8),3)}, {(1,(1,6),3)}, {(22,(1,6),1)}, {(15,(1,6,9),3)}, 
  {(22,(),3)} ]
gap> NrHClasses(V);
131
gap> NrLClasses(V);
106
gap> RClassReps(U[2]);
[ (18,(),5), (14,(),3), (7,(1,6),3), (16,(1,6),3), (13,(5,8)(6,9),5), 
  (6,(),3), (19,(5,8)(6,9),3), (11,(),3), (22,(1,6),3), (20,(1,6),3), 
  (5,(),5), (10,(5,8)(6,9),5), (26,(5,8)(6,9),3), (1,(5,8)(6,9),5), 
  (25,(),5), (9,(),5), (8,(5,8)(6,9),3), (9,(5,8)(6,9),3), (18,(5,8)(6,9),3), 
  (12,(),3), (3,(5,8)(6,9),5), (4,(),5), (15,(5,8)(6,9),5), (21,(5,8)(6,9),5),
  (21,(),3), (17,(5,8)(6,9),5), (15,(),3), (10,(5,8)(6,9),3), 
  (1,(1,9,6)(5,8),3), (24,(5,8)(6,9),5), (23,(5,8)(6,9),5), (2,(1,6),5), 
  (13,(1,6),3), 0, (14,(1,6,9)(5,8),5), (7,(1,6,9)(5,8),5), 
  (16,(1,6,9)(5,8),5), (6,(1,6,9)(5,8),5), (11,(1,6,9)(5,8),5), 
  (22,(1,6,9)(5,8),5), (20,(1,6,9)(5,8),5), (12,(1,6,9)(5,8),5), 
  (19,(5,8)(6,9),5), (26,(5,8)(6,9),5), (8,(5,8)(6,9),5) ]
gap> LClassReps(U[3]);
[ (12,(),3), (12,(),5), (12,(),2), (12,(),4), (14,(1,6)(5,8),3), 
  (14,(1,6)(5,8),5), (14,(1,6)(5,8),2), (14,(1,6)(5,8),4), (14,(),1), 0 ]
gap> DClassReps(U[4]);
[ (19,(),5), (1,(1,6),1), (25,(),1), 0 ]

# MultiplicativeZero
gap> List(U, MultiplicativeZero);
[ 0, 0, 0, 0, 0, 0 ]
gap> ForAll(last, IsIdempotent);
true

# GroupHClass
gap> D:=Filtered(DClasses(U[1]), IsRegularClass)[2];
{(7,(1,6),2)}
gap> GroupHClass(D);
{(7,(),2)}
gap> StructureDescription(last);
"D12"
gap> D:=First(DClasses(V), IsRegularClass);         
{0}
gap> GroupHClass(D);
{0}
gap> StructureDescription(last);
"1"


#
gap> SemigroupsStopTest();
gap> STOP_TEST( "Semigroups package: testinstall.tst", 10000);
