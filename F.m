function [f]=F(xa,aggNo)

global Agg

[f]=([Fprime(xa,Agg(aggNo).hpv{1},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{2},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{3},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{4},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{5},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{6},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{7},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{8},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{9},aggNo)+...
      Fprime(xa,Agg(aggNo).hpv{10},aggNo)])/10;


% [f]=([Fprime(xa,Agg(aggNo).hpv{2},aggNo)])
      













