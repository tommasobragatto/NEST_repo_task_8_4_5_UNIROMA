function [NODI_sotto,LEVEL]= district_down(mpc,nodo_partenza,nodo_sotto)


% ##mpc2=load('mpc_g1.csv');
% ##mpc=  mpc2.mpcn;    % case33bw; 
%nodo= 1;  %%% nodo di partenza

[MC0,lista]= calcolo_MC(mpc,nodo_partenza);

%nodo= 21; %%% nodo di cui trovare i nodi sottostanti
[NODI_sotto,LEVEL]= find_nodes_down(mpc,MC0,lista,nodo_sotto);


end
