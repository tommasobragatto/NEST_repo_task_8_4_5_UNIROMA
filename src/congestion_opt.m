function[ideal_solution, B_IN] = congestion_opt(mpc, KC, F, G, OVm, P_OVR, Nq)

mpc.branch= mpc.branch(find(mpc.branch(:,11)==1),:); %%% remove branch out of service
BUS_N= length(mpc.bus(:,1)); % non da impostare


P_TOT_BUS_TS=    mpc.bus(:,3);          
Q_TOT_BUS_TS=    mpc.bus(:,4);      
P_LOAD_TOT=      abs(mpc.bus(:,3));   
P_LOAD_NOMINALI= abs(mpc.bus(:,3))';       

q_load = quantile(P_LOAD_NOMINALI, [0.33 0.66]);
Nq_BUS= ones(BUS_N,1);
Nq_BUS(find(P_LOAD_NOMINALI <= q_load(1)),1)= Nq(1);
Nq_BUS(find(P_LOAD_NOMINALI > q_load(1) & P_LOAD_NOMINALI <= q_load(2)),1)= Nq(2);
Nq_BUS(find(P_LOAD_NOMINALI > q_load(2)),1)= Nq(3);


AA = sdpvar(BUS_N,1);
  F3=[];
  obj=[];
  %%% funzione obiettivo da minimizzare
  obj= sum( AA ./ Nq_BUS .* F / 100 .* P_LOAD_NOMINALI');
  ID_congestions= find( OVm > KC );  
  mpc_2= mpc;

  B_EX= [1:BUS_N]';
  for j=1:length(P_OVR)
        AB= G(mpc_2.branch(ID_congestions(j),2)).down;
        B_EX= setdiff(B_EX,AB);
        RISS2= AA(AB) ./ Nq_BUS(AB) .* F(AB) ./ 100 .* P_LOAD_NOMINALI(AB)';
        if sum( F(AB) ./ 100 .* P_LOAD_NOMINALI(AB)' ) >= abs(P_OVR(j))
           F3=[ F3 ;  sum(RISS2) >= abs(P_OVR(j)) ];
        end
  end
   B_IN= setdiff([1:BUS_N]',B_EX);
  F3= [F3; integer(AA) ; AA >= 0 ; AA <= Nq_BUS ]; %AA(B_IN) >= -Nq_BUS(B_IN) ; AA(B_IN) <= Nq_BUS(B_IN) ; AA(B_EX) == 0]; 
  
  ops= sdpsettings('verbose',0,'solver','GUROBI');
  RO= optimize(F3,obj,ops);
  if RO.problem ~= 0
       fprint('\n optimization error IDEAL \n')
       ideal_solution= zeros(BUS_N,1);
  else
       AA= value(AA);
       ideal_solution= AA;
  end

end