function[OVf, OVt, OVm, P_OVR] = congestion_calc(mpc, KC, mpopt, F, G, Nq)  
P_TOT_BUS_TS=    mpc.bus(:,3);          
Q_TOT_BUS_TS=    mpc.bus(:,4);      
P_LOAD_TOT=      abs(mpc.bus(:,3));   
P_LOAD_NOMINALI= abs(mpc.bus(:,3))';

BUS_N= length(mpc.bus(:,1)); % non da impostare


q_load = quantile(P_LOAD_NOMINALI, [0.33 0.66]);
Nq_BUS= ones(BUS_N,1);
Nq_BUS(find(P_LOAD_NOMINALI <= q_load(1)),1)= Nq(1);
Nq_BUS(find(P_LOAD_NOMINALI > q_load(1) & P_LOAD_NOMINALI <= q_load(2)),1)= Nq(2);
Nq_BUS(find(P_LOAD_NOMINALI > q_load(2)),1)= Nq(3);


ideal_solution= zeros(BUS_N,1);
  V_CON= zeros(BUS_N,1);

  %fprintf('\n         CONGESTION ANALYSIS WITH IDEAL MEASUREMENTS \n');
  mpc_2=mpc;
  Pmeas= P_TOT_BUS_TS(:,1);
  Qmeas= Q_TOT_BUS_TS(:,1);
  mpc_2.bus(:,3)=Pmeas;
  mpc_2.bus(:,4)=Qmeas;
  r=runpf(mpc_2,mpopt);
  r_before= r;
  OVf= sqrt(r.branch(:,14).^2 + r.branch(:,15).^2)  ./ r.branch(:,6);
  OVt= sqrt(r.branch(:,16).^2 + r.branch(:,17).^2)  ./ r.branch(:,6);
  OVm= max(abs(OVf),abs(OVt));
  

  CONGESTIONS(1).ID_congestions_benchmark= find( OVm > KC );
  CONGESTIONS(1).number_congestions_benchmark= length(find( OVm > KC ) );
  fprintf('\n congestions number : %d \n',CONGESTIONS(1).number_congestions_benchmark);
  CONGESTIONS(1).overload_benchmark= sum( OVm( find( OVm > KC ) ) .* r.branch(find( OVm > KC ),6) - KC .* r.branch(find( OVm > KC ),6) );
  fprintf('\n total overload  (MW): %f\n',CONGESTIONS(1).overload_benchmark);
  CONGESTIONS(1).losses_benchmark= sum(real(get_losses(r)));
  fprintf('\n losses  (percentage): %f \n',100*sum(real(get_losses(r)))/sum(abs(Pmeas)));

  fprintf('\n\n')
  CONGESTIONS(1).Nq_BUS= Nq_BUS;
  CONGESTIONS(1).F= F;

  TAB_CON= zeros(BUS_N,length(mpc.branch(:,1)));

  ID_congestions= find( OVm > KC );

  for k= 1:length(ID_congestions)
          bus1= mpc_2.branch(ID_congestions(k),1);
          bus2= mpc_2.branch(ID_congestions(k),2);
          PP= [1  -2*abs(r.branch(ID_congestions(k),14))  abs(r.branch(ID_congestions(k),14))^2 + abs(r.branch(ID_congestions(k),15))^2 - (KC*mpc.branch(ID_congestions(k),6))^2  ];
          sol_rad= roots(PP);

          P_OVR(k,1)=  min(sol_rad) ; % MW
          
          if r.branch(ID_congestions(k),14) > 0
                TAB_CON(G(r.branch(ID_congestions(k),2)).down,ID_congestions(k))= -1;
          else
                TAB_CON(G(r.branch(ID_congestions(k),2)).down,ID_congestions(k))= +1;
          end
  end

end