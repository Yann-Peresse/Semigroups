#############################################################################
##
#W  iterators.gi
#Y  Copyright (C) 2011-12                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

#technical...

# returns func(iter, pos) once at least position <pos> of the orbit <o> is
# known, the starting value for <pos> is <start>. The idea is that this returns
# something that depends on position <pos> of <o> being known but does not
# depend on the entire orbit being known.

InstallGlobalFunction(IteratorByOrbFunc, 
function(o, func, start)
  local func2, record, iter;

  if not IsOrbit(o) then 
    Error("<o> must be an orbit,");
    return;
  elif not IsFunction(func) then 
    Error("<func> must be a function,");
    return;
  fi;
  
  # change 1 arg <func> to 2 arg 
  if NumberArgumentsFunction(func)=1 then 
    func2:=function(iter, x)
      return func(x);
    end;
  else 
    func2:=func;
  fi;

  record:=rec();
  record.pos:=start-1;

  record.NextIterator:=function(iter)
    local pos, f;

    pos:=iter!.pos;

    if IsClosed(o) and pos>=Length(o) then
      return fail;
    fi;

    pos:=pos+1;

    if pos>Length(o) then
      Enumerate(o, pos);
      if pos>Length(o) then
        return fail;
      fi;
    fi;

    iter!.pos:=pos;
    return func2(iter, pos);
  end;

  record.ShallowCopy:=iter-> rec(pos:=1);

 return IteratorByNextIterator( record );
end);

# returns pairs of the form [coords1[i], coords2[i][j]] 

InstallGlobalFunction(IteratorOfPairs, 
function(coords1, coords2)
  local record;
  
  if not (IsDenseList(coords1) and IsDenseList(coords2) 
    and Length(coords2)=Length(coords1)) then 
    Error("<coords1> and <coords2> must be dense lists of equal length,");
  elif not ForAll(coords2, IsDenseList) then 
    Error("<coords2> must be a list of dense lists,");
  fi;

  record:=rec();
  
  record.i:=1; # 1st coord
  record.j:=0; # 2nd coord
  record.coords1:=coords1;
  record.coords2:=coords2;

  record.IsDoneIterator:=function(iter)
    return iter!.i=Length(iter!.coords1) 
     and iter!.j=Length(iter!.coords2[Length(iter!.coords2)]);
  end;
  
  record.NextIterator:=function(iter)
    local i, j;

    if IsDoneIterator(iter) then 
      return fail;
    fi;

    i:=iter!.i; j:=iter!.j; 

    if j<Length(iter!.coords2[i]) then
      j:=j+1;
    else
      i:=i+1; j:=1;
    fi;

    iter!.i:=i; iter!.j:=j;
    return [iter!.coords1[i], iter!.coords2[i][j]];
  end; 

  record.ShallowCopy:=function(iter)
    return rec(i:=1, j:=1, coords1:=iter!.coords1, coords2:=iter!.coords2);
  end;

  return IteratorByFunctions(record);
end);

# NextIterator in opts must return fail if the iterator is finished. 

InstallGlobalFunction(IteratorByNextIterator, 
function(record)
  local iter, comp, shallow;
  if not ( IsRecord( record ) and IsBound( record.NextIterator )
                              and IsBound( record.ShallowCopy ) ) then 
    Error("<record> must be a record with components `NextIterator'\n",
    "and `ShallowCopy'");
  elif IsRecord (record ) and ( IsBound(record.last_called_by_is_done) 
                          or IsBound(record.next_value) 
                          or IsBound(record.IsDoneIterator) ) then
    Error("<record> must be a record with no components named\n",
    "`last_called_by_is_done', `next_value', or `IsDoneIterator'");
  fi;

  iter:=rec( last_called_by_is_done:=false,
    
    next_value:=fail,

    IsDoneIterator:=function(iter)
      if iter!.last_called_by_is_done then 
        return iter!.next_value=fail;
      fi;
      iter!.last_called_by_is_done:=true;
      iter!.next_value:=record!.NextIterator(iter);
      if iter!.next_value=fail then 
        return true;
      fi;
      return false;
    end,

    NextIterator:=function(iter) 
      if not iter!.last_called_by_is_done then 
        IsDoneIterator(iter);
      fi;
      iter!.last_called_by_is_done:=false;
      return iter!.next_value;
    end);

  for comp in RecNames(record) do 
    if comp="ShallowCopy" then 
      shallow:=record.ShallowCopy(iter);
      shallow.last_called_by_is_done:=false;
      shallow.next_value:=fail;
      iter.ShallowCopy:= iter-> shallow;
    elif comp<>"NextIterator" then 
      iter.(comp):=record.(comp);
    fi;
  od;
  return IteratorByFunctions(iter);
end);

# <baseiter> should be an iterator where NextIterator(baseiter) has a method for
# Iterator. More specifically, if iter:=Iterator(x) where <x> 
# is a returned value of convert(NextIterator(baseiter)), then NextIterator of
# IteratorByIterOfIter returns NextIterator(iter) until
# IsDoneIterator(iter) then iter is replaced by
# Iterator(convert(NextIterator(baseiter)))
# until IsDoneIterator(baseiter), where <convert> is a function. 

InstallGlobalFunction(IteratorByIterOfIter,
function(s, baseiter, convert, filts)
  local iter, filt;

  iter:=IteratorByFunctions(rec(
   
    s:=s,

    iter:=baseiter,
    
    iterofiter:=fail,

    IsDoneIterator:=iter-> IsDoneIterator(iter!.iter) and 
     IsDoneIterator(iter!.iterofiter), 

    NextIterator:=function(iter)
      local iterofiter, next, source;

      if IsDoneIterator(iter) then 
        return fail;
      fi;

      if iter!.iterofiter=fail or IsDoneIterator(iter!.iterofiter) then 
        iter!.iterofiter:=Iterator(convert(NextIterator(iter!.iter)));
      fi;
      
      return NextIterator(iter!.iterofiter);
    end,

    ShallowCopy:=iter -> rec(iter:=baseiter, iterorfiter:=fail)));
  
  for filt in filts do
    SetFilterObj(iter, filt);
  od;
  return iter;
end);

# for: baseiter, convert[, list of filts, isnew, record]

InstallGlobalFunction(IteratorByIterator,
function(arg)
  local iter, filt, convert, isnew;
 
  # process incoming functions 
  if NumberArgumentsFunction(arg[2])=1 then 
    convert:=function(iter, x) 
      return arg[2](x);
    end;
  else
    convert:=arg[2];
  fi;

  if not IsBound(arg[3]) then 
    arg[3]:=[];
  fi;

  if IsBound(arg[4]) then 
    if NumberArgumentsFunction(arg[4])=1 then 
      isnew:=function(iter, x)
        return arg[4](x);
      end;
    else
      isnew:=arg[4];
    fi;
  fi;

  # prepare iterator rec()
  if IsBound(arg[5]) then 
    iter:=arg[5];
  else
    iter:=rec();
  fi;

  iter.baseiter:=arg[1]; 
  
  iter.ShallowCopy:=iter-> rec(baseiter:=ShallowCopy(arg[1]));
  
  iter.IsDoneIterator:=iter-> IsDoneIterator(iter!.baseiter);

  # get NextIterator
  if Length(arg)=3 then 
    iter.NextIterator:=function(iter)
      local x;
      x:=NextIterator(iter!.baseiter);
      if x=fail then
        return fail;
      fi;
      return convert(iter, x);
    end;
  else
    iter.NextIterator:=function(iter)
      local baseiter, x;
      baseiter:=iter!.baseiter;
      repeat 
        x:=NextIterator(baseiter);
      until IsDoneIterator(baseiter) or isnew(iter, x);
    
      if x=fail then 
        return fail;
      fi;
      return convert(iter, x);
    end;
  fi;

  iter:=IteratorByFunctions(iter); 

  for filt in arg[3] do #filters
    SetFilterObj(iter, filt);
  od;

  return iter;
end);

# iterator [, length of iterator]

InstallGlobalFunction(ListIterator,
function(arg)
  local out, i, x;
  
  if IsBound(arg[2]) then 
    out:=EmptyPlist(arg[2]);
  else
    out:=[];
  fi;

  i:=0;

  for x in arg[1] do
    i:=i+1;
    out[i]:=x;
  od;

  return out;
end);

# everything else...

# Notes: the previous inverse method used D-classes instead of R-classes.

# same method for regular/inverse 

InstallMethod(Iterator, "for an acting semigroup",
[IsActingSemigroup], 5, #to beat the method for semigroup ideals
function(s)
  local iter;

  if HasAsSSortedList(s) then 
    iter:=IteratorList(AsSSortedList(s));
    SetIsIteratorOfSemigroup(iter, true);
    return iter;
  fi;

  return IteratorByIterOfIter(s, IteratorOfRClasses(s), x-> x,
   [IsIteratorOfSemigroup]);
end);

# same method for regular/inverse

InstallMethod(Iterator, "for a D-class of an acting semigroup", 
[IsGreensDClass and IsActingSemigroupGreensClass], 
function(d)
  local iter, s;
  
  if HasAsSSortedList(d) then 
    iter:=IteratorList(AsSSortedList(d));
    SetIsIteratorOfDClassElements(iter, true);
    return iter;
  fi;

  s:=Parent(d);
  return IteratorByIterOfIter(s, Iterator(GreensRClasses(d)), x-> x,
   [IsIteratorOfDClassElements]);
end);

# same method for regular/inverse

InstallMethod(Iterator, "for a H-class of an acting semigroup", 
[IsGreensHClass and IsActingSemigroupGreensClass], 
function(h)
  local iter, s;
  
  if HasAsSSortedList(h) then 
    iter:=IteratorList(AsSSortedList(h));
    SetIsIteratorOfDClassElements(iter, true);
    return iter;
  fi;

  s:=Parent(h);
  return IteratorByIterator(Iterator(SchutzenbergerGroup(h)), x->
   Representative(h)*x, [IsIteratorOfHClassElements]);
end);

# same method for regular, there should be a different method for inverseJDM!?
# the inverse method will be almost identical to the R-class method, hence we
# should extract the relevant bits from both the L and R method and make a new
# function like in NrIdempotents@ for example. JDM

InstallMethod(Iterator, "for an L-class of an acting semigp",
[IsGreensLClass and IsActingSemigroupGreensClass],
function(l)
  local o, m, mults, iter, scc;

  if HasAsSSortedList(l) then 
    iter:=IteratorList(AsSSortedList(l));
    SetIsIteratorOfLClassElements(iter, true);
    return iter;
  fi;

  o:=RhoOrb(l); 
  m:=RhoOrbSCCIndex(l);
  mults:=RhoOrbMults(o, m);
  scc:=OrbSCC(o)[m];

  iter:=IteratorByFunctions(rec(

    #schutz:=List(SchutzenbergerGroup(r), x-> Representative(r)*x), 
    schutz:=Enumerator(SchutzenbergerGroup(l)),
    at:=[0,1],
    m:=Length(scc),
    n:=Size(SchutzenbergerGroup(l)), 

    IsDoneIterator:=iter-> iter!.at[1]=iter!.m and iter!.at[2]=iter!.n,

    NextIterator:=function(iter)
      local at;

      at:=iter!.at;
      
      if at[1]=iter!.m and at[2]=iter!.n then 
        return fail;
      fi;

      if at[1]<iter!.m then
        at[1]:=at[1]+1;
      else
        at[1]:=1; at[2]:=at[2]+1;
      fi;
     
      return mults[scc[at[1]]][1]*Representative(l)*iter!.schutz[at[2]];
    end,
    
    ShallowCopy:=iter -> rec(schutz:=iter!.schutz, at:=[0,1], 
     m:=iter!.m, n:=iter!.n)));
  
  SetIsIteratorOfLClassElements(iter, true);
  return iter;
end);

# Notes: this method makes Iterator of a semigroup much better!!

# same method for regular/inverse

InstallMethod(Iterator, "for an R-class of an acting semigp",
[IsGreensRClass and IsActingSemigroupGreensClass],
function(r)
  local o, m, mults, iter, scc;

  if HasAsSSortedList(r) then 
    iter:=IteratorList(AsSSortedList(r));
    SetIsIteratorOfRClassElements(iter, true);
    return iter;
  fi;

  o:=LambdaOrb(r); 
  m:=LambdaOrbSCCIndex(r);
  mults:=LambdaOrbMults(o, m);
  scc:=OrbSCC(o)[m];

  iter:=IteratorByFunctions(rec(

    #schutz:=List(SchutzenbergerGroup(r), x-> Representative(r)*x), 
    schutz:=Enumerator(SchutzenbergerGroup(r)),
    at:=[0,1],
    m:=Length(scc),
    n:=Size(SchutzenbergerGroup(r)), 

    IsDoneIterator:=iter-> iter!.at[1]=iter!.m and iter!.at[2]=iter!.n,

    NextIterator:=function(iter)
      local at;

      at:=iter!.at;
      
      if at[1]=iter!.m and at[2]=iter!.n then 
        return fail;
      fi;

      if at[1]<iter!.m then
        at[1]:=at[1]+1;
      else
        at[1]:=1; at[2]:=at[2]+1;
      fi;
     
      return Representative(r)*iter!.schutz[at[2]]*mults[scc[at[1]]][1];
    end,
    
    ShallowCopy:=iter -> rec(schutz:=iter!.schutz, at:=[0,1], 
     m:=iter!.m, n:=iter!.n)));
  
  SetIsIteratorOfRClassElements(iter, true);
    return iter;
end);

#JDM this should be improved at some point

# different method for regular/inverse

InstallMethod(IteratorOfDClasses, "for an acting semigroup",
[IsActingSemigroup],
function(s)
  local iter;
  
  if IsClosed(SemigroupData(s)) then 
    iter:=IteratorList(GreensDClasses(s));
    SetIsIteratorOfDClasses(iter, true);
    return iter;
  fi;
  
  return IteratorByIterator(
    IteratorOfRClassData(s),  # baseiter
    function(iter, x)         # convert
      local d;
      d:=DClassOfRClass(CallFuncList(CreateRClassNC, x));
      Add(iter!.classes, d);
      return d;
    end,
    [IsIteratorOfDClasses], 
    function(iter, x)         #isnew
      return x=fail or ForAll(iter!.classes, d-> not x[4] in d);
     end,
    rec(classes:=[]));        #iter
end);

# JDM could use IteratorOfRClasses here instead, not sure which is better...
# JDM should be different method for regular/inverse

InstallMethod(IteratorOfHClasses, "for an acting semigroup",
[IsActingSemigroup],
function(s)
  local iter;
  
  if HasGreensHClasses(s) then 
    iter:=IteratorList(GreensHClasses(s));
    SetIsIteratorOfHClasses(iter, true);
    return iter;
  fi;

  return IteratorByIterOfIter(s, IteratorOfDClasses(s), GreensHClasses, 
   [IsIteratorOfHClasses]);
end);

# different method for regular/inverse

InstallMethod(IteratorOfLClasses, "for an acting semigroup",
[IsActingSemigroup],
function(s)
  local iter;
  
  if HasGreensLClasses(s) then 
    iter:=IteratorList(GreensLClasses(s));
    SetIsIteratorOfLClasses(iter, true);
    return iter;
  fi;
  
  return IteratorByIterOfIter(s, IteratorOfDClasses(s), GreensLClasses, 
  [IsIteratorOfLClasses]);
end);

# different method for regular/inverse

InstallMethod(IteratorOfRClasses, "for an acting semigroup",
[IsActingSemigroup],
function(s)
  local iter;

  if HasGreensRClasses(s) then 
    iter:=IteratorList(GreensRClasses(s));
    SetIsIteratorOfRClasses(iter, true);
    return iter;
  fi;

  return IteratorByIterator(IteratorOfRClassData(s), x->
   CallFuncList(CreateRClassNC, x), [IsIteratorOfRClasses]);
end);

#different method for regular/inverse

InstallMethod(IteratorOfRClassData, "for an acting semigroup",
[IsActingSemigroup],
function(s)

  return IteratorByNextIterator( rec( 
    
    i:=1,

    NextIterator:=function(iter)
      local data;

      iter!.i:=iter!.i+1;
      
      data:=Enumerate(SemigroupData(s), iter!.i, ReturnFalse);

      if iter!.i>Length(data!.orbit) then 
        return fail;
      fi;
      return data[iter!.i];
    end,
    
    ShallowCopy:=iter-> rec(i:=1)));
end);

# no method required for inverse/regular

InstallMethod(Iterator, "for a full transformation semigroup",
[IsTransformationSemigroup and IsFullTransformationSemigroup and HasGeneratorsOfSemigroup], 
function(s)
  local iter;
  
  iter:= IteratorByFunctions( rec(

    s:=s,

    tups:=IteratorOfTuples([1..DegreeOfTransformationSemigroup(s)],
     DegreeOfTransformationSemigroup(s)),

    NextIterator:=iter-> TransformationNC(NextIterator(iter!.tups)),
  
    IsDoneIterator:=iter -> IsDoneIterator(iter!.tups),
    
    ShallowCopy:= iter -> rec(tups:=
  
    IteratorOfTuples([1..DegreeOfTransformationSemigroup(s)],
     DegreeOfTransformationSemigroup(s)))));

  SetIsIteratorOfSemigroup(iter, true);
  return iter;
end);

# Notes: required until Enumerator for a trans. semigp does not call iterator. 
# This works but is maybe not the best!

# same method for regular/inverse

InstallOtherMethod(Iterator, "for a trivial acting semigp", 
[IsActingSemigroup and HasGeneratorsOfSemigroup and IsTrivial], 9999,
function(s)
  return TrivialIterator(Generators(s)[1]);
end);

# different method for regular/inverse

InstallMethod(IteratorOfDClassReps, "for an acting semigroup",
[IsActingSemigroup],
s-> IteratorByIterator(IteratorOfDClasses(s), Representative,
[IsIteratorOfDClassReps]));

#JDM should be a different  method for regular/inverse using
#IteratorOfHClassData (not yet written);

InstallMethod(IteratorOfHClassReps, "for an acting semigroup",
[IsActingSemigroup],
s-> IteratorByIterator(IteratorOfHClasses(s), Representative,
[IsIteratorOfHClassReps]));

# different method for regular/inverse

InstallMethod(IteratorOfLClassReps, "for an acting semigroup",
[IsActingSemigroup],
s-> IteratorByIterator(IteratorOfLClasses(s), Representative,
[IsIteratorOfLClassReps]));

# same method for inverse/regular.

InstallMethod(IteratorOfRClassReps, "for an acting semigroup",
[IsActingSemigroup],
s-> IteratorByIterator(IteratorOfRClassData(s), x-> x[4],
[IsIteratorOfRClassReps]));

#
   
InstallMethod(PrintObj, [IsIteratorOfDClassElements],
function(iter)
  Print( "<iterator of D-class>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfHClassElements],
function(iter)
  Print( "<iterator of H-class>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfLClassElements],
function(iter)
  Print( "<iterator of L-class>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfRClassElements],
function(iter)
  Print("<iterator of R-class>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfDClassReps],
function(iter)
  Print("<iterator of D-class reps>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfHClassReps],
function(iter)
  Print("<iterator of H-class reps>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfLClassReps], 
function(iter)
  Print( "<iterator of L-class reps>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfRClassReps],
function(iter)
  Print("<iterator of R-class reps>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfDClasses], 
function(iter)
  Print( "<iterator of D-classes>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfHClasses], 
function(iter)
  Print( "<iterator of H-classes>");
  return;
end);
 
#

InstallMethod(PrintObj, [IsIteratorOfLClasses],
function(iter)
  Print( "<iterator of L-classes>");
  return;
end);

#

InstallMethod(PrintObj, [IsIteratorOfRClasses],
function(iter)
  Print( "<iterator of R-classes>");
  return;
end); 

#

InstallMethod(PrintObj, [IsIteratorOfSemigroup],
function(iter)
  if IsFullTransformationSemigroup(iter!.s) then
    Print("<iterator of full transformation semigroup>");
  elif IsTransformationSemigroup(iter!.s) then
    Print("<iterator of transformation semigroup>");
  elif IsPartialPermSemigroup(iter!.s) and IsInverseSemigroup(iter!.s) then
    Print("<iterator of inverse semigroup>");
  elif IsPartialPermSemigroup(iter!.s) then 
    Print("<iterator of semigroup of partial perms>");
  elif IsSymmetricInverseSemigroup(iter!.s) then 
    Print("<iterator of symmetric inverse semigroup>");
  fi;
  return;
end);

#EOF
