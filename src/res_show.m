function[]=res_show(mpc, F, B_IN, OVm, KC, P_OVR, Nq)  
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


figure
  G88=graph(mpc.branch(ismember(mpc.branch(:,11),1),1),mpc.branch(ismember(mpc.branch(:,11),1),2));
  H88= plot(G88,'NodeLabel',mpc.bus(:,1),'Layout','force');%,'NodeLabel',mpc.bus(:,1),'Layout','force');
  title('CONGESTIONS ANALYSIS WITH IDEAL MEASUREMENTS','Fontsize',20);

  for s=1:length(B_IN)
   
         labelnode(H88,B_IN(s), B_IN(s) + " // " + round( 1000 .* AA(B_IN(s)) ./ Nq_BUS(B_IN(s)) .* F(B_IN(s)) ./100 .* P_LOAD_NOMINALI(B_IN(s))') + " kW" )
         if 1000 .* AA(B_IN(s)) ./ Nq_BUS(B_IN(s)) .* F(B_IN(s)) ./100 .* P_LOAD_NOMINALI(B_IN(s))' ~= 0
              highlight(H88,B_IN(s),'NodeFontSize',14,'NodeLabelColor','g','NodeColor','g','MarkerSize',7);
         end
  end

    ID_congestions= find( OVm > KC );  

  for k= 1:length(ID_congestions)
         labeledge(H88,mpc.branch(ID_congestions(k),1),mpc.branch(ID_congestions(k),2), " // " + round( P_OVR(k).*1000) + " kW" );
         highlight(H88,mpc.branch(ID_congestions(k),1),mpc.branch(ID_congestions(k),2),'EdgeFontSize',14,'EdgeLabelColor','r','EdgeColor','r');
  end
  txt = 'I rami rossi sono i rami congestionati; i nodi verdi sono i nodi dove è stata richiesta la flessibilità';
  text(-5,-5,txt)

end