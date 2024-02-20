function[CONGESTIONS] = lf_final(mpc, ideal_solution, F, mpopt, KC, Nq)  
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

  mpc_2=mpc;
    TAB_CON= zeros(BUS_N,length(mpc.branch(:,1)));
  [~,b1] = sort(abs(TAB_CON),2,'descend');
  V_CON = TAB_CON(sub2ind(size(TAB_CON),[1:length(TAB_CON(:,1))]',b1(:,1)));
  Pmeas= P_TOT_BUS_TS(:,1) + V_CON .* ideal_solution ./ Nq_BUS .* F ./100 .* P_LOAD_NOMINALI';
  Qmeas= Q_TOT_BUS_TS(:,1);
  mpc_2.bus(:,3)=Pmeas;
  mpc_2.bus(:,4)=Qmeas;
  r=runpf(mpc_2,mpopt);
  OVf= sqrt(r.branch(:,14).^2 + r.branch(:,15).^2)  ./ r.branch(:,6);
  OVt= sqrt(r.branch(:,16).^2 + r.branch(:,17).^2)  ./ r.branch(:,6);
  OVm2= max(abs(OVf),abs(OVt));

  CONGESTIONS(1).ideal_solution= ideal_solution;
  CONGESTIONS(1).P_flex_ideal_measurements= sum( abs( ideal_solution ./ Nq_BUS .* F ./100 .* P_LOAD_NOMINALI' ) );
  fprintf('\n Flexibility power required (MW) : %f\n',CONGESTIONS(1).P_flex_ideal_measurements)
  CONGESTIONS(1).number_residual_congestions_ideal_measurements= length(find(OVm2 > KC));

end