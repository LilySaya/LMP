function [f]=F(xa,aggNo)

global Agg

% The third parameter is the index of the PV scenario.
% [f]=([Fprime(xa,Agg(aggNo).hpv{1},1,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{2},2,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{3},3,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{4},4,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{5},5,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{6},6,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{7},7,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{8},8,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{9},9,aggNo)+...
%       Fprime(xa,Agg(aggNo).hpv{10},10,aggNo)])/10;


[f]=([Fprime(xa,Agg(aggNo).hpv{2},2,aggNo)])
      













