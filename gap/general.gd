##
## general.gd
## Version 3.1.3
## Fri  7 Nov 2008 17:45:12 GMT
##

##  <#GAPDoc Label="generaltop">
##  This chapter contains general functions needed to support functions in the 
##	MONOID package.
##	<#/GAPDoc>

###########################################################################
##
##  <#GAPDoc Label="EnumeratorOfCartesian">
##  <ManSection> 
##  <Func Name="EnumeratorOfCartesian" Arg="enums"/>
##  <Description>
##  returns a simple enumerator of the cartesian product of the list of 
##	enumerators <C>enums</C>.
##	</Description>  
##	</ManSection>
##	<#/GAPDoc>

DeclareGlobalFunction("EnumeratorOfCartesian");

###########################################################################
##
##  <#GAPDoc Label="MONOIDPermListList">
##  <ManSection> 
##  <Func Name="MONOIDPermListList" Arg="gens1, gens2"/>
##  <Description>
##  returns the permutation that maps the free generators of <C>gens1</C> to the 
##	free generators <C>gens2</C>.
##	</Description>  
##	</ManSection>
##	<#/GAPDoc>

DeclareOperation("MONOIDPermListList", [IsList, IsList]);